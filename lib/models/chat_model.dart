import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../apis/openai_api.dart';
import '../widgets/user_bubble.dart';
import '../widgets/gpt_bubble.dart';

class ChatModel extends ChangeNotifier {
  final List<Widget> _messages = [];
  bool _isLoading = false;
  bool _isUsingLocalLLM = false;
  String _localLLMUrl = '';

  List<Widget> get getMessages => _messages;
  bool get isLoading => _isLoading;
  bool get isUsingLocalLLM => _isUsingLocalLLM;
  String get localLLMUrl => _localLLMUrl;

  void updateSettings({required bool isUsingLocalLLM, required String localLLMUrl}) {
    _isUsingLocalLLM = isUsingLocalLLM;
    _localLLMUrl = localLLMUrl;
    notifyListeners();
  }

  Future<void> sendChat(String txt) async {
    if (txt.trim().isEmpty) return;
    
    addUserMessage(txt);
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> response;
      
      if (_isUsingLocalLLM) {
        response = await _getLocalLLMResponse(txt);
      } else {
        response = await OpenAiRepository.getOpenAIChatCompletion(txt);
      }

      // Remove the loading indicator
      if (_messages.isNotEmpty && _messages.last is GptBubble) {
        final lastMessage = _messages.last as GptBubble;
        if (lastMessage.message == "...") {
          _messages.removeLast();
        }
      }

      if (!response['hasError']) {
        _messages.add(GptBubble(response['text']));
      } else {
        _messages.add(GptBubble("ERROR: ${response['text']}"));
      }
    } catch (e) {
      // Remove the loading indicator
      if (_messages.isNotEmpty && _messages.last is GptBubble) {
        final lastMessage = _messages.last as GptBubble;
        if (lastMessage.message == "...") {
          _messages.removeLast();
        }
      }
      _messages.add(GptBubble("ERROR: Failed to get response. Please try again."));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _getLocalLLMResponse(String prompt) async {
    if (_localLLMUrl.isEmpty) {
      return {
        "hasError": true,
        "text": "Local LLM URL not configured. Please set it in settings.",
      };
    }

    try {
      final response = await http.post(
        Uri.parse(_localLLMUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "local-model", // This can be any string for local LLMs
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.7,
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);
          List<dynamic> choices = responseBody['choices'];
          if (choices.isNotEmpty) {
            dynamic firstChoice = choices[0];
            if (firstChoice.containsKey('message')) {
              return {
                "hasError": false,
                "text": firstChoice['message']['content'],
              };
            } else {
              return {
                "hasError": true,
                "text": 'No message generated from local LLM',
              };
            }
          } else {
            return {
              "hasError": true,
              "text": 'No choices generated from local LLM',
            };
          }
        } catch (e) {
          return {
            "hasError": true,
            "text": 'Failed to decode local LLM response: $e',
          };
        }
      } else {
        return {
          "hasError": true,
          "text": 'Local LLM server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        "hasError": true,
        "text": 'Failed to connect to local LLM: $e',
      };
    }
  }

  void addUserMessage(String txt) {
    _messages.add(UserBubble(txt));
    _messages.add(const GptBubble("..."));
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _isLoading = false;
    notifyListeners();
  }
}