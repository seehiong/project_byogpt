import 'package:flutter/material.dart';

import '../apis/openai_api.dart';
import '../widgets/user_bubble.dart';
import '../widgets/gpt_bubble.dart';

class ChatModel extends ChangeNotifier {
  final List<Widget> _messages = [];

  List<Widget> get getMessages => _messages;

  Future<void> sendChat(String txt) async {
    addUserMessage(txt);

    var response = await OpenAiRepository.getOpenAICompletion(txt);

    //remove the last item
    _messages.removeLast();

    if (!response['hasError']) {
      _messages.add(GptBubble(response['text']));
    } else {
      _messages.add(GptBubble("ERROR: ${response['text']}"));
    }

    notifyListeners();
  }

  void addUserMessage(txt) {
    _messages.add(UserBubble(txt));
    _messages.add(const GptBubble("..."));
    notifyListeners();
  }
}
