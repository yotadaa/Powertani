import 'package:flutter/material.dart';
import 'package:powertani/Home/EduTani.dart';
import 'package:powertani/Home/Header.dart';
import 'package:powertani/Home/Search.dart';
import 'package:powertani/Home/Weather.dart';
import 'package:powertani/Home/DaftarMenu.dart';
import 'package:powertani/OpenAI/OpenAIService.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:powertani/components/Text.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.user,
      this.showPopup = false,
      required void Function() activatePopUp,
      required void Function() deactivatePopUp});

  bool showPopup;

  Map<String, dynamic> user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double navigationHeight = 70;
  final String? apiKeyId = dotenv.env['apiKeyId'] ?? '';

  final OpenAIServer openAiServer = OpenAIServer();

  final String apiKey =
      '94eeeb8caa2b423584953817242311 '; // Replace with your API key
  final String apiUrl = 'https://api.weatherapi.com/v1/current.json';
  String cityName = 'London';

  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic>? weatherData = {};
  bool isLoading = false;
  String errorMessage = '';
  bool widgetWeatherSwells = false;
  double spacing = 20;
  String response = "The text will appear here";

  Future<void> fetchWeather() async {
    if (!mounted) return; // Cek apakah widget masih terpasang
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = Uri.parse('$apiUrl?key=$apiKey&q=$cityName');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (!mounted) return; // Cek ulang sebelum setState
        setState(() {
          weatherData = data;
        });
      } else {
        if (!mounted) return; // Cek ulang sebelum setState
        setState(() {
          errorMessage =
              'Failed to fetch weather data: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      if (!mounted) return; // Cek ulang sebelum setState
      setState(() {
        errorMessage = 'An error occurred: $error';
      });
    } finally {
      if (!mounted) return; // Cek ulang sebelum setState
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPngName(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

  Map<String, dynamic> getWeatherSummary(Map<String, dynamic>? weatherData) {
    if (weatherData == null || weatherData['current'] == null) {
      return {
        'cloud': 'NA',
        'precip_mm': 'NA',
        'name': "N/A",
        'temperature': 'N/A',
        'condition': 'Data not available',
        'iconUrl': '',
        'humidity': 'N/A',
        'windSpeed': 'N/A',
        'precipitation': 'N/A',
      };
    }

    final current = weatherData['current'];
    final condition = current['condition'] ?? {};
    return {
      'cloud': current['cloud'],
      'precip_mm': current['precip_mm'],
      'name': weatherData['location']['name'] ?? "N/A",
      'temperature': '${current['temp_c'] ?? 'N/A'}°C',
      'condition': condition['text'] ?? 'Unknown condition',
      'iconUrl': condition['icon'] != null ? 'https:${condition['icon']}' : '',
      'humidity': '${current['humidity'] ?? 'N/A'}%',
      'windSpeed': '${current['wind_kph'] ?? 'N/A'} km/j',
      'precipitation': '${current['precip_mm'] ?? 'N/A'} mm',
    };
  }

  Future<void> getLocation(BuildContext context) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Show an alert dialog if GPS is not activated
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Location Required"),
            content: Text("Please enable Location to use this feature."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      }
    }

    // Check if permission is granted
    await location.requestPermission();
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission not granted");
        return;
      }
    }

    // Get the user's location
    try {
      _locationData = await location.getLocation();

      double latitude = _locationData.latitude!;
      double longitude = _locationData.longitude!;

      // Get the address from the coordinates
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geocode.Placemark place = placemarks[0];
        setState(() {
          this.cityName = place.administrativeArea ?? "London";
        });

        fetchWeather();
      } else {
        print("No address found for the coordinates.");
      }
    } catch (e) {
      print("Error while fetching the location: $e");
    }
  }

  Future<String?> generateResponse(String prompt) async {
    String? apiKey = await openAiServer.getApiKey(apiKeyId!);
    String? textResponse = await openAiServer.generateResponse(prompt, apiKey!);
    setState(() {
      this.response = textResponse!;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    final weatherSummary =
        weatherData != {} ? getWeatherSummary(weatherData!) : {};
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderApp(user: widget.user),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: spacing,
                        ),
                        WeatherMenu(
                          widgetWeatherSwells: widgetWeatherSwells,
                          fetchWeather: fetchWeather,
                          weatherSummary: weatherSummary,
                          openWeatherWidget: () => {
                            setState(() {
                              widgetWeatherSwells = !widgetWeatherSwells;
                            }),
                            fetchWeather(),
                          },
                        ),
                        SizedBox(
                          height: spacing,
                        ),
                        SearchBox(
                          controller: _searchController,
                          onSearch: () => {
                            print(_searchController.text.trim()),
                            generateResponse(_searchController.text.trim()),
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Constrain the width of the text
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    // Ensure the text takes available space and wraps
                                    child: StdText(
                                      text: response,
                                      fontSize: 12,
                                      font: "Montserrat",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DaftarMenu(
                          user: widget.user,
                        ),
                        EduTani(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
