import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

class OpenAIServer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> listModels() async {
    try {
      List<OpenAIModelModel> models = await OpenAI.instance.model.list();

      // Pretty print each model
      for (var model in models) {
        print('Model ID: ${model.id}');
        print('Owned by: ${model.ownedBy}');
        print('Permission: ${jsonEncode(model.permission)}\n');
      }

      // Alternatively, print the entire list in JSON format
    } catch (e) {
      print('Error fetching models: $e');
    }
  }

  Future<String?> generateResponse(String prompt, String apiKey) async {
    OpenAI.apiKey = apiKey;

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          prompt,
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      // responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    return chatCompletion.choices.first.message.content?.first.text;
  }

  Future<String?> getApiKey(String documentId) async {
    try {
      final snapshot =
          await _firestore.collection('services').doc(documentId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!['openai_api'] as String?;
      } else {
        print('API key not found in Firestore');
        return null;
      }
    } catch (e) {
      print('Error fetching API key: $e');
      return null;
    }
  }

  /// Generate a response using the OpenAI API.
  Future<String> generateResponse2(String prompt, String apiKey) async {
    const apiUrl = 'https://api.openai.com/v1/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "GPT-4o mini",
          "prompt": prompt,
          "max_tokens": 100,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].trim();
      } else {
        return 'Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
