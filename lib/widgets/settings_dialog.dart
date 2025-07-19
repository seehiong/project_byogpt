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
  late TextEditingController _modelUrlController;
  late bool _isUsingLocalLLM;
  late bool _isUsingCactus;
  int _selectedOption = 0; // 0: OpenAI, 1: Local LLM, 2: Cactus

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: widget.model.localLLMUrl.isEmpty 
          ? 'http://localhost:11434/v1/chat/completions'
          : widget.model.localLLMUrl
    );
    _modelUrlController = TextEditingController(text: widget.model.modelUrl);
    _isUsingLocalLLM = widget.model.isUsingLocalLLM;
    _isUsingCactus = widget.model.isUsingCactus;
    
    // Set initial selection
    if (_isUsingCactus) {
      _selectedOption = 2;
    } else if (_isUsingLocalLLM) {
      _selectedOption = 1;
    } else {
      _selectedOption = 0;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _modelUrlController.dispose();
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
                  color: _selectedOption == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: _selectedOption == 0 ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<int>(
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
                value: 0,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Local LLM Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedOption == 1
                      ? Colors.orange
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: _selectedOption == 1 ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<int>(
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
                value: 1,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Cactus LLM Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedOption == 2
                      ? Colors.purple
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: _selectedOption == 2 ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<int>(
                title: Row(
                  children: [
                    Icon(
                      Icons.memory,
                      color: Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Cactus LLM'),
                  ],
                ),
                subtitle: const Text('Run GGUF models directly in the app'),
                value: 2,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Local LLM URL Configuration
            if (_selectedOption == 1) ...[
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
            
            // Cactus Model URL Configuration
            if (_selectedOption == 2) ...[
              Text(
                'Cactus LLM Configuration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _modelUrlController,
                decoration: InputDecoration(
                  labelText: 'Model URL',
                  hintText: 'huggingface/gguf/model-link',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'HuggingFace GGUF model URL or local file path',
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.purple, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Cactus LLM Info',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Runs GGUF models directly in your app\n'
                      '• No external server needed\n'
                      '• Works offline once model is downloaded\n'
                      '• Example: microsoft/DialoGPT-medium-gguf',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[700],
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
              isUsingLocalLLM: _selectedOption == 1,
              localLLMUrl: _urlController.text.trim(),
              isUsingCactus: _selectedOption == 2,
              modelUrl: _modelUrlController.text.trim(),
            );
            Navigator.of(context).pop();
            
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _selectedOption == 2
                      ? 'Switched to Cactus LLM'
                      : _selectedOption == 1
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