import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cactus/cactus.dart';

import '../apis/openai_api.dart';
import '../widgets/user_bubble.dart';
import '../widgets/gpt_bubble.dart';

class ChatModel extends ChangeNotifier {
  final List<Widget> _messages = [];
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;
  bool _isUsingLocalLLM = false;
  String _localLLMUrl = 'http://localhost:11434/v1/chat/completions';
  dynamic _cactusLM;
  bool _isUsingCactus = false;
  String _modelUrl = 'https://huggingface.co/Cactus-Compute/Gemma3-1B-Instruct-GGUF/resolve/main/gemma-3-1b-it-Q4_K_M.gguf';
  bool _isInitializingCactus = false;
  String _cactusInitStatus = '';
  double? _cactusInitProgress;
  String _openaiApiKey = '';
  String _openaiApiUrl = 'https://api.openai.com/v1/chat/completions';

  List<Widget> get getMessages => _messages;
  bool get isLoading => _isLoading;
  bool get isUsingLocalLLM => _isUsingLocalLLM;
  String get localLLMUrl => _localLLMUrl;
  bool get isUsingCactus => _isUsingCactus;
  String get modelUrl => _modelUrl;
  bool get isInitializingCactus => _isInitializingCactus;
  String get cactusInitStatus => _cactusInitStatus;
  double? get cactusInitProgress => _cactusInitProgress;
  String get openaiApiKey => _openaiApiKey;
  String get openaiApiUrl => _openaiApiUrl;

  bool get isCactusSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  void updateSettings({
    required bool isUsingLocalLLM, 
    required String localLLMUrl,
    bool isUsingCactus = false,
    String modelUrl = '',
    String openaiApiKey = '',
    String openaiApiUrl = '',
  }) {
    _isUsingLocalLLM = isUsingLocalLLM;
    _localLLMUrl = localLLMUrl;
    _isUsingCactus = isUsingCactus && isCactusSupported;
    _modelUrl = modelUrl;
    _openaiApiKey = openaiApiKey;
    _openaiApiUrl = openaiApiUrl.isNotEmpty ? openaiApiUrl : 'https://api.openai.com/v1/chat/completions';
    
    // Show warning if trying to use Cactus on unsupported platform
    if (isUsingCactus && !isCactusSupported) {
      print('Warning: Cactus LLM is not supported on this platform. Falling back to OpenAI.');
      _isUsingCactus = false;
    }
    
    // Dispose existing Cactus instance if switching away
    if (!_isUsingCactus && _cactusLM != null) {
      try {
        _cactusLM.dispose();
      } catch (e) {
        print('Error disposing Cactus LM: $e');
      }
      _cactusLM = null;
    }
    
    notifyListeners();
  }

  Future<void> initializeCactus() async {
    if (!isCactusSupported) {
      print('Cactus LLM is not supported on this platform');
      _cactusInitStatus = 'Platform not supported';
      notifyListeners();
      return;
    }
    
    if (_modelUrl.isEmpty) {
      _cactusInitStatus = 'Model URL not configured';
      notifyListeners();
      return;
    }
    
    if (_cactusLM != null) {
      _cactusInitStatus = 'Already initialized';
      notifyListeners();
      return;
    }
    
    _isInitializingCactus = true;
    _cactusInitStatus = 'Starting initialization...';
    _cactusInitProgress = null;
    notifyListeners();
    
    try {
      _cactusInitStatus = 'Downloading model...';
      notifyListeners();
      
      _cactusLM = await CactusLM.init(
        modelUrl: _modelUrl,
        contextSize: 2048,
        gpuLayers: 0, // CPU only for compatibility
        onProgress: (progress, status, isError) {
          _cactusInitProgress = progress;
          _cactusInitStatus = status ?? 'Initializing...';
          if (isError) {
            _cactusInitStatus = 'Error: $status';
          }
          notifyListeners();
        },
      );
      
      _cactusInitStatus = 'Model ready!';
      _cactusInitProgress = 1.0;
    } catch (e) {
      print('Failed to initialize Cactus LM: $e');
      _cactusInitStatus = 'Failed to initialize: $e';
      _cactusInitProgress = null;
      _cactusLM = null;
      _isUsingCactus = false;
    } finally {
      _isInitializingCactus = false;
      notifyListeners();
    }
  }

  Future<void> sendChat(String txt) async {
    if (txt.trim().isEmpty) return;
    
    addUserMessage(txt);
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> response;
      
      if (_isUsingCactus) {
        if (isCactusSupported) {
          response = await _getCactusResponse(txt);
        } else {
          response = {
            "hasError": true,
            "text": "Cactus LLM is not supported on this platform. Please use OpenAI or Local LLM instead.",
          };
        }
      } else if (_isUsingLocalLLM) {
        response = await _getLocalLLMResponse(txt);
      } else {
        response = await _getOpenAIResponse(txt);
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
        
        // Add to chat history for Cactus context
        if (_isUsingCactus) {
          _chatHistory.add({'role': 'user', 'content': txt});
          _chatHistory.add({'role': 'assistant', 'content': response['text']});
          
          // Keep only last 10 messages for context
          if (_chatHistory.length > 20) {
            _chatHistory.removeRange(0, _chatHistory.length - 20);
          }
        }
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

  Future<Map<String, dynamic>> _getCactusResponse(String prompt) async {
    if (!isCactusSupported) {
      return {
        "hasError": true,
        "text": "Cactus LLM is not supported on this platform.",
      };
    }
    
    if (_cactusLM == null) {
      return {
        "hasError": true,
        "text": "Cactus LM not initialized. Please initialize the model first.",
      };
    }

    try {
      // Build conversation context using ChatMessage objects
      final messages = <ChatMessage>[
        ChatMessage(role: 'system', content: 'You are a helpful AI assistant.'),
        ..._chatHistory.map((msg) => ChatMessage(role: msg['role']!, content: msg['content']!)),
        ChatMessage(role: 'user', content: prompt),
      ];
      
      // Use streaming completion for better user experience
      String fullResponse = '';
      await _cactusLM!.completion(
        messages,
        maxTokens: 500,
        temperature: 0.7,
        onToken: (token) {
          fullResponse += token;
          // Update the UI with streaming response
          if (_messages.isNotEmpty && _messages.last is GptBubble) {
            final lastMessage = _messages.last as GptBubble;
            if (lastMessage.message == "...") {
              _messages.removeLast();
              _messages.add(GptBubble(fullResponse));
              notifyListeners();
            }
          }
          return true; // Continue streaming
        },
      );
      return {
        "hasError": false,
        "text": fullResponse,
      };
    } catch (e) {
      return {
        "hasError": true,
        "text": 'Cactus LM error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _getOpenAIResponse(String prompt) async {
    if (_openaiApiKey.isEmpty) {
      return {
        "hasError": true,
        "text": "OpenAI API key not configured. Please set it in settings.",
      };
    }

    try {
      final response = await http.post(
        Uri.parse(_openaiApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_openaiApiKey"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
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
                "text": 'No message generated from OpenAI',
              };
            }
          } else {
            return {
              "hasError": true,
              "text": 'No choices generated from OpenAI',
            };
          }
        } catch (e) {
          return {
            "hasError": true,
            "text": 'Failed to decode OpenAI response: $e',
          };
        }
      } else if (response.statusCode == 401) {
        return {
          "hasError": true,
          "text": 'Invalid OpenAI API key. Please check your API key in settings.',
        };
      } else if (response.statusCode == 429) {
        return {
          "hasError": true,
          "text": 'OpenAI API rate limit exceeded. Please try again later.',
        };
      } else {
        return {
          "hasError": true,
          "text": 'OpenAI API error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        "hasError": true,
        "text": 'Failed to connect to OpenAI: $e',
      };
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
    _chatHistory.clear();
    _isLoading = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    if (_cactusLM != null) {
      try {
        _cactusLM.dispose();
      } catch (e) {
        print('Error disposing Cactus LM: $e');
      }
    }
    super.dispose();
  }
}