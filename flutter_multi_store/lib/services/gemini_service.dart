import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // final _apiKey = 'AIzaSyCEVFhXUTYiJfPC7WHJ8Puy7DFxd9QwFaQ';
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyCEVFhXUTYiJfPC7WHJ8Puy7DFxd9QwFaQ',
  );

  Future<Map<String, dynamic>?> extractFilter(String userInput) async {
    final prompt = '''
Phân tích câu sau và trả về JSON với các trường category (string) và averageRating (số): "$userInput".
Nếu không rõ, hãy để category là "" và averageRating là 0.
Trả về JSON thuần, không thêm giải thích.
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    try {
      final text = response.text!;
      return _parseJson(text);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? _parseJson(String rawText) {
    try {
      final json = rawText.replaceAll('```json', '').replaceAll('```', '');
      return jsonDecode(json);
    } catch (e) {
      return null;
    }
  }
}
