import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> generateResponse(String prompt) async {
    const apiUrl = 'https://api.openai.com/v1/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "text-davinci-003", // Adjust the model as needed
          "prompt": prompt,
          "max_tokens": 100,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].trim();
      } else {
        return "Error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
