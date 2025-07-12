# AI Chat Assistant - Flutter App

A beautiful Flutter application that supports both OpenAI's GPT API and local LLM servers for AI-powered conversations. Features a modern Material Design 3 UI with dark/light theme support and the flexibility to switch between cloud and local AI models.

## Features

- 🤖 **Dual AI Support**: Switch between OpenAI's GPT API and local LLM servers
- 🏠 **Local LLM Integration**: Connect to LM Studio, Ollama, or any OpenAI-compatible local server
- ☁️ **Cloud AI**: Full OpenAI GPT integration with API key support
- 🎨 **Modern Material Design 3 UI** with beautiful animations
- 🌙 **Dark/Light theme support** (follows system preference)
- 📱 **Responsive design** for all screen sizes
- 💬 **Enhanced chat bubbles** with copy functionality
- ⚡ **Real-time indicators** showing current AI model and loading states
- 🔄 **Easy switching** between AI models via settings
- 🛠️ **Comprehensive error handling** and user feedback

## Screenshots

The app features:
- **Dynamic header** showing current AI model (Cloud/Local)
- **Settings dialog** for easy switching between AI providers
- **Visual indicators** for connection status
- **Setup guidance** for local LLM configuration
- **Modern chat interface** with distinct user and AI message bubbles

## Prerequisites

### For Flutter Development:
1. **Flutter SDK** (version 3.0 or higher)
   - Download: https://flutter.dev/docs/get-started/install
   - Verify: `flutter doctor`

### For OpenAI (Cloud AI):
2. **OpenAI API Key**
   - Sign up: https://platform.openai.com/
   - Generate API key from dashboard

### For Local LLM:
3. **Local LLM Server** (choose one):
   - **LM Studio**: https://lmstudio.ai/ (Recommended - user-friendly GUI)
   - **Ollama**: https://ollama.ai/ (Command-line focused)
   - **Text Generation WebUI**: https://github.com/oobabooga/text-generation-webui
   - **Any OpenAI-compatible server**

## Setup Instructions

### 1. Clone and Setup Project

```bash
# Clone the repository
git clone <your-repo-url>
cd project_byogpt

# Install dependencies
flutter pub get
```

### 2. Configure OpenAI API Key (for Cloud AI)

**⚠️ IMPORTANT: Update your API key for OpenAI functionality**

Edit `lib/constants/gpt_constant.dart`:

```dart
const openaiKey = 'your-actual-openai-api-key-here';
```

**Security Note:** Never commit your actual API key to version control.

### 3. Setup Local LLM (Optional)

#### Option A: LM Studio (Recommended for beginners)
1. Download and install LM Studio from https://lmstudio.ai/
2. Download a model (e.g., Llama 2, Mistral, CodeLlama)
3. Load the model in LM Studio
4. Start the local server (usually runs on `http://localhost:1234`)
5. In the app settings, enter: `http://localhost:1234/v1/chat/completions`

#### Option B: Ollama
1. Install Ollama: https://ollama.ai/
2. Pull a model: `ollama pull llama2`
3. Run the model: `ollama run llama2`
4. The server typically runs on `http://localhost:11434`
5. Use endpoint: `http://localhost:11434/v1/chat/completions`

#### Option C: Text Generation WebUI
1. Follow setup instructions: https://github.com/oobabooga/text-generation-webui
2. Enable OpenAI API extension
3. Start with `--api` flag
4. Default endpoint: `http://localhost:5000/v1/chat/completions`

### 4. Run the Application

#### Development Mode
```bash
flutter run
```

#### Platform-Specific Commands

**Android:**
```bash
flutter run -d android
```

**iOS:** (macOS only)
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

**Desktop:**
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### 5. Using the App

1. **First Launch**: The app starts with OpenAI mode by default
2. **Switch to Local LLM**: 
   - Tap the settings icon in the app bar
   - Select "Local LLM" option
   - Enter your local server URL
   - Save settings
3. **Visual Indicators**: 
   - Cloud icon = OpenAI mode
   - Computer icon = Local LLM mode
   - Orange warning = Local LLM not configured

### 6. Build for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry point with dual AI support
├── models/
│   └── chat_model.dart         # Chat state management + AI switching logic
├── widgets/
│   ├── chat_list.dart          # Chat messages list with empty state
│   ├── user_bubble.dart        # User message bubble
│   ├── gpt_bubble.dart         # AI message bubble with copy function
│   ├── user_input.dart         # Message input field
│   └── settings_dialog.dart    # AI model switching interface
├── apis/
│   └── openai_api.dart         # OpenAI API integration
└── constants/
    └── gpt_constant.dart       # API configuration
```

## Troubleshooting

### Common Issues

1. **OpenAI API Key Error**
   - Update the key in `lib/constants/gpt_constant.dart`
   - Verify account has sufficient credits
   - Check API key validity at https://platform.openai.com/

2. **Local LLM Connection Failed**
   - Ensure your local LLM server is running
   - Check the URL format (include `/v1/chat/completions`)
   - Verify firewall isn't blocking the connection
   - Try `http://localhost:1234/v1/chat/completions` for LM Studio

3. **Flutter Setup Issues**
   ```bash
   flutter doctor
   flutter clean
   flutter pub get
   ```

4. **Local LLM Server Not Starting**
   - **LM Studio**: Check if model is loaded and server is started
   - **Ollama**: Run `ollama serve` then `ollama run <model-name>`
   - **Port conflicts**: Try different ports (1234, 5000, 8080, 11434)

### Network and Connectivity

1. **Corporate Networks**: May need proxy configuration
2. **Firewall Issues**: Ensure Flutter and your LLM server ports are allowed
3. **Local Server URLs**: Always use `http://` (not `https://`) for local servers

### Local LLM Specific

1. **Model Loading**: Ensure your model is fully loaded before testing
2. **Memory Issues**: Large models need sufficient RAM
3. **Response Format**: The app expects OpenAI-compatible JSON responses

## API Usage and Costs

### OpenAI
- Uses GPT-3.5-turbo by default (configurable)
- Each message incurs costs based on OpenAI pricing
- Monitor usage: https://platform.openai.com/usage

### Local LLM
- **Free to use** once set up
- **Privacy-focused** - all data stays local
- **No internet required** for inference
- **Hardware dependent** - performance varies by your system

## Customization

### Changing AI Models

**OpenAI Models** (edit `lib/apis/openai_api.dart`):
```dart
"model": "gpt-4", // or gpt-3.5-turbo, gpt-4-turbo, etc.
```

**Local LLM Models**: Change in your local server (LM Studio, Ollama, etc.)

### Theming

Modify colors in `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF10A37F), // Change this
  brightness: Brightness.light,
),
```

### Adding New Local LLM Providers

The app works with any OpenAI-compatible API. Just ensure your server:
1. Accepts POST requests to `/v1/chat/completions`
2. Uses OpenAI-compatible JSON format
3. Returns responses in the expected structure

## Popular Local LLM Models

- **Llama 2** (7B, 13B, 70B) - General purpose
- **Code Llama** - Programming focused
- **Mistral 7B** - Fast and efficient
- **Vicuna** - Conversation optimized
- **WizardCoder** - Code generation
- **Orca** - Reasoning tasks

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test with both OpenAI and local LLM
4. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues:
1. Check troubleshooting section above
2. Verify your local LLM server is OpenAI-compatible
3. Test with both AI modes to isolate issues
4. Create an issue with details about your setup

---

**Enjoy chatting with AI - both in the cloud and locally! 🚀**