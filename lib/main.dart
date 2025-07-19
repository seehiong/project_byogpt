import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/chat_model.dart';
import './widgets/user_input.dart';
import './widgets/chat_list.dart';
import './widgets/settings_dialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatModel(),
      child: MaterialApp(
        title: "AI Chat Assistant",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF10A37F),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF10A37F),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatModel>(
          builder: (context, model, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (model.isUsingLocalLLM || model.isUsingCactus)
                        ? Colors.orange.withOpacity(0.2)
                        : Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    (model.isUsingLocalLLM || model.isUsingCactus) ? Icons.computer : Icons.cloud,
                    color: (model.isUsingLocalLLM || model.isUsingCactus)
                        ? Colors.orange
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      model.isUsingCactus 
                          ? 'Cactus LLM' 
                          : model.isUsingLocalLLM 
                              ? 'Local LLM' 
                              : 'OpenAI GPT',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: (model.isUsingLocalLLM || model.isUsingCactus)
                            ? Colors.orange
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<ChatModel>(
            builder: (context, model, child) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsDialog(context, model),
                tooltip: 'Settings',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ChatModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              if ((model.isUsingLocalLLM && model.localLLMUrl.isEmpty) || 
                  (model.isUsingCactus && model.modelUrl.isEmpty))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.orange.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          model.isUsingCactus 
                              ? 'Cactus LLM model URL not configured'
                              : 'Local LLM not configured. Default: Ollama (localhost:11434)',
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showSettingsDialog(context, model),
                        child: const Text('Configure'),
                      ),
                    ],
                  ),
                ),
              if (model.isUsingCactus && model.isInitializingCactus)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue.withOpacity(0.1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Initializing Cactus LLM model... This may take a few minutes.',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ChatList(messages: model.getMessages),
              ),
              UserInput(chatController: chatController),
            ],
          );
        },
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, ChatModel model) {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(model: model),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Assistant'),
        content: const Text(
          'This Flutter app supports both OpenAI\'s GPT API and local LLM servers. '
          'Switch between them in settings to use your preferred AI model.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}