import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class SettingsDialog extends StatefulWidget {
  final ChatModel model;

  const SettingsDialog({
    super.key,
    required this.model,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _urlController;
  late bool _isUsingLocalLLM;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: widget.model.localLLMUrl.isEmpty 
          ? 'http://localhost:11434/v1/chat/completions'
          : widget.model.localLLMUrl
    );
    _isUsingLocalLLM = widget.model.isUsingLocalLLM;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Model Selection',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // OpenAI Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: !_isUsingLocalLLM 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: !_isUsingLocalLLM ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<bool>(
                title: Row(
                  children: [
                    Icon(
                      Icons.cloud,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('OpenAI GPT'),
                  ],
                ),
                subtitle: const Text('Use OpenAI\'s cloud-based GPT models'),
                value: false,
                groupValue: _isUsingLocalLLM,
                onChanged: (value) {
                  setState(() {
                    _isUsingLocalLLM = value!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Local LLM Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isUsingLocalLLM 
                      ? Colors.orange
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: _isUsingLocalLLM ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<bool>(
                title: Row(
                  children: [
                    Icon(
                      Icons.computer,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Local LLM'),
                  ],
                ),
                subtitle: const Text('Use your own local LLM server'),
                value: true,
                groupValue: _isUsingLocalLLM,
                onChanged: (value) {
                  setState(() {
                    _isUsingLocalLLM = value!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Local LLM URL Configuration
            if (_isUsingLocalLLM) ...[
              Text(
                'Local LLM Configuration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Local LLM URL',
                  hintText: 'http://localhost:11434/v1/chat/completions',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'Default: Ollama (port 11434) | LM Studio (port 1234)',
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Setup Instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Install Ollama (ollama.ai) or LM Studio\n'
                      '2. For Ollama: ollama pull llama2 && ollama serve\n'
                      '3. For LM Studio: Load model and start server\n'
                      '4. Default URLs: Ollama (11434) | LM Studio (1234)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.model.updateSettings(
              isUsingLocalLLM: _isUsingLocalLLM,
              localLLMUrl: _urlController.text.trim(),
            );
            Navigator.of(context).pop();
            
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isUsingLocalLLM 
                      ? 'Switched to Local LLM'
                      : 'Switched to OpenAI GPT',
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: MediaQuery.of(context).size.width - 250,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}