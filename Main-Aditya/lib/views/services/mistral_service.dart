import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralService {
  final String apiKey = 'Ron6BgvCaxE2clyt0TjrVZsoPnjwFcpd';
  final String apiUrl = "https://api.mistral.ai/v1/chat/completions";

  Future<String> getResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "mistral-medium",
          "messages": [
            {"role": "system", "content": "You are a helpful chatbot."},
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? "No response";
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
