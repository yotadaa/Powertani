import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'dart:convert';

Future<String?> getGeminiResponse({
  required List<JenisTanaman> jenisTanamanData,
  required List<Tanaman> tanamanData,
  required String
      customPrompt, // Custom prompt from user for how to manage data
}) async {
  List<Map<String, dynamic>> jenisTanamanJson =
      jenisTanamanData.map((jenisTanaman) {
    return jenisTanaman.toJson();
  }).toList();

  List<Map<String, dynamic>> tanamanJson = tanamanData.map((tanaman) {
    return tanaman.toJson();
  }).toList();

  try {
    final value = await Gemini.instance.prompt(parts: [
      Part.text('Prompt: ${customPrompt}'),
      Part.text('Reference data:'),
      Part.text('Tanaman: ${tanamanJson}'),
      Part.text('Jenis Tanaman: ${jenisTanamanJson}'),
      Part.text('=============='),
      Part.text(
          'Write a JSON response based on Prompt with the following fields:'),
      Part.text(
          'header: Kalimat umum berdasarkan custom prompt maksimal 20 kata'),
      Part.text(
          'mode: 0 or 1, // 0  if custom prompt not able to filter data, 1 if it does '),
      Part.text(
          'filteredResults: [namaLatin1, namaLatin2, ...] // this is the namaLatin of filtered tanaman, return only [] if the promt isnt relevant with the data')
    ]);
    String? responseText =
        value?.output ?? 'An error occurred'; // Handle null case
    responseText = extractJson(responseText);
    if (responseText != null &&
        responseText.toString().startsWith("{") &&
        responseText.toString().endsWith("}")) {
      // Attempt to parse the response as JSON
      try {
        return jsonEncode(
            jsonDecode(responseText.toString())); // If valid JSON, return it
      } catch (e) {}
    }
    return "{}"; // Return null if response isn't valid JSON
  } catch (e) {
    return 'An error occurred';
  }
}

String extractJson(String input) {
  List<String> lines = input.split('\n');
  int lastIndex = lines.length - 2; // Index of the last line

  List<String> extractedLines =
      lines.sublist(1, lastIndex); // Extract lines from 3rd to last

  return extractedLines.join('\n');
}


// "Tanaman di musim hujan"