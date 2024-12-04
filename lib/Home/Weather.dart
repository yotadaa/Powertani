import 'package:flutter/material.dart';
import 'package:powertani/components/Text.dart';

class WeatherMenu extends StatefulWidget {
  bool widgetWeatherSwells;
  VoidCallback fetchWeather;
  Map<dynamic, dynamic> weatherSummary;
  final VoidCallback openWeatherWidget;
  WeatherMenu({
    Key? key,
    required this.widgetWeatherSwells,
    required this.fetchWeather,
    required this.weatherSummary,
    required this.openWeatherWidget,
  }) : super(key: key);

  @override
  State<WeatherMenu> createState() => _WeatherMenuState();
}

class _WeatherMenuState extends State<WeatherMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.openWeatherWidget,
      child: Container(
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.easeInOut,
        height: widget.widgetWeatherSwells ? 130 : 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Rounded corners
          image: DecorationImage(
            image: AssetImage('assets/images/icons/weathers/bg-day.png'),
            fit: BoxFit.cover, // Cover the container
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Match border radius
                color: Colors.black
                    .withOpacity(0.4), // Semi-transparent black overlay
              ),
              padding: const EdgeInsets.all(
                  16.0), // Add padding inside the container
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Align to the left
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center vertically
                    children: [
                      WeatherWidget(
                        weatherSummary: widget.weatherSummary,
                        widgetWeatherSwells: widget.widgetWeatherSwells,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Map<dynamic, dynamic> weatherSummary;
  bool widgetWeatherSwells;

  WeatherWidget(
      {Key? key,
      required this.weatherSummary,
      required this.widgetWeatherSwells})
      : super(key: key);

  String getLocalIconPath(String? url) {
    if (url == null || url.isEmpty) {
      return 'assets/images/icons/weathers/176.png';
    }

    try {
      final pngName = Uri.parse(url).pathSegments.last; // Extracts '176.png'
      return 'assets/images/icons/weathers/$pngName';
    } catch (e) {
      return 'assets/images/icons/weathers/176.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconUrl = weatherSummary['iconUrl'];
    final localIconPath = getLocalIconPath(iconUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                    localIconPath,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                StdText(
                  text: weatherSummary['name'],
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StdText(
                  text: weatherSummary['temperature'],
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                StdText(
                  text: "${weatherSummary['condition']}",
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround, // Space between items
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wind_power, color: Colors.blue, size: 15),
                        SizedBox(width: 2), // Space between icon and text
                        StdText(
                          text: "${weatherSummary['windSpeed']}",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(width: 6),
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.grey, size: 15),
                        SizedBox(width: 2), // Space between icon and text
                        StdText(
                          text: "${weatherSummary['cloud']}%",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(width: 6),
                    Row(
                      children: [
                        Icon(Icons.water_drop, color: Colors.blue, size: 15),
                        SizedBox(width: 2), // Space between icon and text
                        StdText(
                          text: "${weatherSummary['precip_mm']} mm",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
