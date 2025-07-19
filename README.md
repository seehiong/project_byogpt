# AI Chat Assistant - Flutter App

A beautiful Flutter application that supports OpenAI's GPT API, local LLM servers, and on-device Cactus LLM for AI-powered conversations. Features a modern Material Design 3 UI with dark/light theme support and the flexibility to switch between cloud, local, and on-device AI models.

## Features

- 🤖 **Triple AI Support**: Switch between OpenAI's GPT API, local LLM servers, and on-device Cactus LLM
- 🏠 **Local LLM Integration**: Connect to LM Studio, Ollama, or any OpenAI-compatible local server
- ☁️ **Cloud AI**: Full OpenAI GPT integration with API key support
- 📱 **On-Device AI**: Run GGUF models directly in your app with Cactus LLM (Android/iOS only)
- 🎨 **Modern Material Design 3 UI** with beautiful animations
- 🌙 **Dark/Light theme support** (follows system preference)
- 📱 **Responsive design** for all screen sizes
- 💬 **Enhanced chat bubbles** with copy functionality
- ⚡ **Real-time indicators** showing current AI model and loading states
- 🔄 **Easy switching** between AI models via settings
- 📊 **Download progress tracking** for Cactus models
- 🛠️ **Comprehensive error handling** and user feedback

## Screenshots

The app features:
- **Dynamic header** showing current AI model (Cloud/Local/Cactus)
- **Settings dialog** for easy switching between AI providers
- **Visual indicators** for connection status
- **Setup guidance** for local LLM and Cactus configuration
- **Modern chat interface** with distinct user and AI message bubbles
- **Download progress** for Cactus model initialization

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

### For Cactus LLM (On-Device):
4. **Android or iOS Device** (Cactus LLM is not supported on web/desktop)
   - Requires sufficient storage for model files (1-4GB depending on model)
   - Recommended: 4GB+ RAM for optimal performance

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

In the app settings:
1. Select "OpenAI GPT" option
2. Enter your OpenAI API key
3. Optionally customize the API URL

**Security Note:** API keys are stored locally on device only.

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

### 4. Setup Cactus LLM (On-Device AI)

**Platform Support:** Android and iOS only

1. **Select Cactus LLM** in app settings
2. **Choose a model URL** (default: Gemma3-1B-Instruct recommended)
3. **Click "Download & Initialize Model"**
4. **Wait for download** (progress shown with percentage)
5. **Start chatting** once "Model ready!" appears

#### Recommended Models:
- **Gemma3-1B-Instruct** (1GB) - Fast, good quality, default option
- **Phi-3-mini** (2GB) - Microsoft's balanced performance model
- **Llama-3.2-1B** (1GB) - Meta's efficient model
- **TinyLlama** (600MB) - Ultra-fast, basic responses

#### Custom Models:
- Use any GGUF format model from Hugging Face
- Direct download URLs work best
- Smaller models (1-2GB) recommended for mobile devices

### 5. Run the Application

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
# Note: Cactus LLM not available on web
```

**Desktop:**
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
# Note: Cactus LLM not available on desktop
```

### 6. Using the App

1. **First Launch**: The app starts with OpenAI mode by default
2. **Switch AI Models**: 
   - Tap the settings icon in the app bar
   - Select your preferred option:
     - **OpenAI GPT** (cloud-based, requires API key)
     - **Local LLM** (your own server)
     - **Cactus LLM** (on-device, Android/iOS only)
   - Configure the selected option
   - Save settings
3. **Visual Indicators**: 
   - Cloud icon = OpenAI mode
   - Computer icon = Local LLM mode
   - Memory chip icon = Cactus LLM mode
   - Orange warning = Configuration needed
4. **For Cactus LLM**:
   - First use requires model download
   - Progress shown with percentage
   - Works offline after initial setup

### 7. Build for Production

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
# Note: Cactus LLM features disabled on web
```

## Project Structure

```
lib/
├── main.dart                    # App entry point with triple AI support
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
   - Enter valid API key in settings
   - Verify account has sufficient credits
   - Check API key validity at https://platform.openai.com/

2. **Local LLM Connection Failed**
   - Ensure your local LLM server is running
   - Check the URL format (include `/v1/chat/completions`)
   - Verify firewall isn't blocking the connection
   - Try `http://localhost:1234/v1/chat/completions` for LM Studio
   - Try `http://localhost:11434/v1/chat/completions` for Ollama

3. **Cactus LLM Issues**
   - **Platform Error**: Only works on Android/iOS
   - **Download Failed**: Check internet connection and storage space
   - **Model Not Loading**: Try smaller model or restart app
   - **Out of Memory**: Use smaller model (1GB recommended)

4. **Flutter Setup Issues**
   ```bash
   flutter doctor
   flutter clean
   flutter pub get
   ```

5. **Local LLM Server Not Starting**
   - **LM Studio**: Check if model is loaded and server is started
   - **Ollama**: Run `ollama serve` then `ollama run <model-name>`
   - **Port conflicts**: Try different ports (1234, 5000, 8080, 11434)

### Network and Connectivity

1. **Corporate Networks**: May need proxy configuration
2. **Firewall Issues**: Ensure Flutter and your LLM server ports are allowed
3. **Local Server URLs**: Always use `http://` (not `https://`) for local servers

### Cactus LLM Specific

1. **Model Download**: Requires stable internet for initial download
2. **Storage Space**: Ensure 2-5GB free space for model files
3. **Memory Issues**: Large models need sufficient RAM (4GB+ recommended)
4. **Platform Support**: Only Android and iOS supported
5. **First Run**: Model download may take 5-30 minutes depending on size and connection

## API Usage and Costs

### OpenAI
- Uses GPT-3.5-turbo by default (configurable in code)
- Each message incurs costs based on OpenAI pricing
- Monitor usage: https://platform.openai.com/usage

### Local LLM
- **Free to use** once set up
- **Privacy-focused** - all data stays local
- **No internet required** for inference
- **Hardware dependent** - performance varies by your system

### Cactus LLM
- **Free to use** after initial model download
- **Complete privacy** - everything runs on-device
- **Works offline** after setup
- **No API costs** - one-time download only
- **Mobile optimized** - designed for phones and tablets

## Customization

### Changing AI Models

**OpenAI Models** (edit `lib/models/chat_model.dart`):
```dart
"model": "gpt-4", // or gpt-3.5-turbo, gpt-4-turbo, etc.
```

**Local LLM Models**: Change in your local server (LM Studio, Ollama, etc.)

**Cactus Models**: Enter any GGUF model URL in settings

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

## Popular Models by Category

### OpenAI Models
- **GPT-3.5-turbo** - Fast, cost-effective
- **GPT-4** - Highest quality, more expensive
- **GPT-4-turbo** - Balanced performance and cost

### Local LLM Models
- **Llama 2** (7B, 13B, 70B) - General purpose
- **Code Llama** - Programming focused
- **Mistral 7B** - Fast and efficient
- **Vicuna** - Conversation optimized
- **WizardCoder** - Code generation
- **Orca** - Reasoning tasks

### Cactus LLM Models (GGUF)
- **Gemma3-1B-Instruct** (1GB) - Recommended starter
- **Phi-3-mini** (2GB) - Microsoft's efficient model
- **Llama-3.2-1B** (1GB) - Meta's mobile-optimized
- **TinyLlama** (600MB) - Ultra-fast responses
- **Qwen2-1.5B** (1.5GB) - Multilingual support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test with all three AI modes (OpenAI, Local LLM, Cactus)
4. Ensure Cactus works on Android/iOS
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues:
1. Check troubleshooting section above
2. Verify your setup matches the platform requirements
3. Test with different AI modes to isolate issues
4. For Cactus issues, ensure you're on Android/iOS
5. Create an issue with details about your setup and platform

---

**Enjoy chatting with AI - in the cloud, locally, and on-device! 🚀**