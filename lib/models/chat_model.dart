import 'package:flutter/material.dart';

import '../apis/openai_api.dart';
import '../widgets/user_bubble.dart';
import '../widgets/gpt_bubble.dart';

class ChatModel extends ChangeNotifier {
  final List<Widget> _messages = [];
  bool _isLoading = false;

  List<Widget> get getMessages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendChat(String txt) async {
    if (txt.trim().isEmpty) return;
    
    addUserMessage(txt);
    _isLoading = true;
    notifyListeners();

    try {
      var response = await OpenAiRepository.getOpenAIChatCompletion(txt);

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