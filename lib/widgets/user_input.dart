import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';

class UserInput extends StatefulWidget {
  final TextEditingController chatController;
  
  const UserInput({
    Key? key,
    required this.chatController,
  }) : super(key: key);

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    widget.chatController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.chatController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = widget.chatController.text.trim().isNotEmpty;
    });
  }

  void _handleSubmit() {
    final text = widget.chatController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatModel>().sendChat(text);
      widget.chatController.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: widget.chatController,
                    onSubmitted: (_) => _handleSubmit(),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: _isComposing 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _isComposing ? _handleSubmit : null,
                  icon: Icon(
                    Icons.send_rounded,
                    color: _isComposing
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  tooltip: 'Send message',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}