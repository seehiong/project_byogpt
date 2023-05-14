import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/gpt_constant.dart';

class OpenAiRepository {
  static var client = http.Client();

  static Future<Map<String, dynamic>> getOpenAIChatCompletion(
      String prompt) async {
    final response = await http.post(
      Uri.parse(openaiChatCompletionEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openaiKey"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": openaiChatRole, "content": prompt}
        ]
      }),
    );

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        List<dynamic> choices = responseBody['choices'];
        if (choices.isNotEmpty) {
          // Extract the first choice from the choices array
          dynamic firstChoice = choices[0];

          // Check if the first choice has a message field
          if (firstChoice.containsKey('message')) {
            // Extract the message field from the first choice
            return {
              "hasError": false,
              "text": firstChoice['message']['content'],
            };
          } else {
            // Handle the case where the first choice does not have a message field
            return {
              "hasError": true,
              "text": 'No message generated, please try again',
            };
          }
        } else {
          // Handle the case where the choices array is empty
          return {
            "hasError": true,
            "text": 'No choices generated, please try again',
          };
        }
      } catch (e) {
        return {
          "hasError": true,
          "text": 'Failed to decode OpenAI response: $e',
        };
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return {
        "hasError": true,
        "text": 'OpenAI API error: ${response.statusCode}',
      };
    } else {
      return {
        "hasError": true,
        "text":
            'Failed to get OpenAI completion. Error code: ${response.statusCode}',
      };
    }
  }

  static Future<Map<String, dynamic>> getOpenAICompletion(String prompt) async {
    final response = await http.post(
      Uri.parse(openaiCompletionEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openaiKey"
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": prompt,
        "max_tokens": 150,
        "temperature": 0.2,
        "top_p": 1
      }),
    );

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        List<dynamic> choices = responseBody['choices'];
        if (choices.isNotEmpty) {
          // Extract the first choice from the choices array
          dynamic firstChoice = choices[0];

          // Check if the first choice has a text field
          if (firstChoice.containsKey('text')) {
            // Extract the text field from the first choice
            return {
              "hasError": false,
              "text": firstChoice['text'],
            };
          } else {
            // Handle the case where the first choice does not have a text field
            return {
              "hasError": true,
              "text": 'No text generated, please try again',
            };
          }
        } else {
          // Handle the case where the choices array is empty
          return {
            "hasError": true,
            "text": 'No choices generated, please try again',
          };
        }
      } catch (e) {
        return {
          "hasError": true,
          "text": 'Failed to decode OpenAI response: $e',
        };
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return {
        "hasError": true,
        "text": 'OpenAI API error: ${response.statusCode}',
      };
    } else {
      return {
        "hasError": true,
        "text":
            'Failed to get OpenAI completion. Error code: ${response.statusCode}',
      };
    }
  }
}
