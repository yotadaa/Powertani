import 'package:dart_openai/dart_openai.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'dart:convert';

String generatePrompt({
  required List<JenisTanaman> jenisTanamanData,
  required List<Tanaman> tanamanData,
  required String
      customPrompt, // Custom prompt from user for how to manage data
}) {
  List<Map<String, dynamic>> jenisTanamanJson =
      jenisTanamanData.map((jenisTanaman) {
    return jenisTanaman.toJson();
  }).toList();

  List<Map<String, dynamic>> tanamanJson = tanamanData.map((tanaman) {
    return tanaman.toJson();
  }).toList();

  return '''
Here is the custom prompt for how to manage the data: "$customPrompt".

JenisTanaman Data:
${jsonEncode(jenisTanamanJson)}

Tanaman Data:
${jsonEncode(tanamanJson)}

Your task is to apply the custom prompt to filter and manage the data, the filtered_data will only consists of Tanaman Data namaLatin. 
Please return the final result **ONLY in JSON format** (no extra information). Ensure that the result is valid JSON. The filtered data may have one or more data.
Example: 
{
  "header": 'Kalimat umum berdasarkan custom prompt maksimal 20 kata',
  "mode" : 0 or 1, // 0  if custom prompt not able to filter data, 1 if it does 
  "data": [
    {
      "filteredResults": [namaLatin1, namaLatin2, ...] // this is the namaLatin of filtered tanaman, return only [] if the promt isnt relevant with the data
    },
      ...
  ]
}
  ''';
}

Future<String?> generateFilteredData(String apiKey, String customPrompt,
    List<JenisTanaman> jenisTanamanData, List<Tanaman> tanamanData) async {
  try {
    OpenAI.apiKey = apiKey;

    // Generate the prompt
    String prompt = generatePrompt(
      jenisTanamanData: jenisTanamanData,
      tanamanData: tanamanData,
      customPrompt: customPrompt,
    );

    // Define the messages to be passed to OpenAI
    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are an assistant that processes plant data.")
          ]),
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
        ], // Use the generated prompt here
      ),
    ];

    // Send the request to OpenAI
    final chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini-2024-07-18", // Use the appropriate model
      messages: messages,
      temperature: 0,
    );

    // Extract the content and return as a parsed JSON response
    final responseText =
        chatCompletion.choices.first.message.content?.first.text;
    print("Full response: $responseText");
    if (responseText != null &&
        responseText.toString().startsWith("{") &&
        responseText.toString().endsWith("}")) {
      // Attempt to parse the response as JSON
      try {
        return jsonEncode(
            jsonDecode(responseText.toString())); // If valid JSON, return it
      } catch (e) {
        print("Failed to parse response as JSON: $e");
      }
    }
    return null; // Return null if response isn't valid JSON
  } catch (e) {
    print("Error generating response: $e");
    return null;
  }
}

Future<String?> generateFilteredDataUsingAssistant(
    String apiKey,
    String customPrompt,
    List<JenisTanaman> jenisTanamanData,
    List<Tanaman> tanamanData) async {
  try {
    OpenAI.apiKey = apiKey;

    // Generate the prompt for the Assistant API
    String prompt = generatePrompt(
      jenisTanamanData: jenisTanamanData,
      tanamanData: tanamanData,
      customPrompt: customPrompt,
    );

    // Prepare the messages for the Assistant API
    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are an assistant that processes plant data and helps with agricultural insights.")
          ]),
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
        ],
      ),
    ];

    // Sending the request to Assistant API (assuming Assistant endpoint)
    final chatCompletion = await OpenAI.instance.chat.create(
      model: "assistant-v1", // Replace with actual Assistant API model name
      messages: messages,
      temperature: 0,
    );

    final responseText =
        chatCompletion.choices.first.message.content?.first.text;

    // Parse and return the response if valid JSON
    if (responseText != null &&
        responseText.startsWith("{") &&
        responseText.endsWith("}")) {
      try {
        return jsonEncode(jsonDecode(responseText));
      } catch (e) {
        print("Failed to parse response as JSON: $e");
      }
    }
    return null;
  } catch (e) {
    print("Error during Assistant API request: $e");
    return null;
  }
}
