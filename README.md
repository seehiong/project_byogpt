# AI Chat Assistant - Flutter App

A beautiful Flutter application that connects to OpenAI's GPT API to provide AI-powered conversations. Features a modern Material Design 3 UI with dark/light theme support.

## Features

- 🤖 AI-powered conversations using OpenAI's GPT API
- 🎨 Modern Material Design 3 UI
- 🌙 Dark/Light theme support (follows system preference)
- 📱 Responsive design for all screen sizes
- 💬 Chat bubbles with copy functionality
- ⚡ Real-time typing indicators
- 🔄 Loading states and error handling

## Screenshots

The app features a clean, modern interface with:
- Welcoming empty state with conversation starters
- Distinct user and AI message bubbles
- Smooth animations and transitions
- Intuitive input field with send button

## Prerequisites

Before running this project, make sure you have:

1. **Flutter SDK** installed (version 3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **OpenAI API Key**
   - Sign up at: https://platform.openai.com/
   - Generate an API key from your dashboard

## Setup Instructions

### 1. Clone and Setup

```bash
# Clone the repository (if using git)
git clone <your-repo-url>
cd project_byogpt

# Or if you have the project files locally, navigate to the project directory
cd path/to/project_byogpt
```

### 2. Configure OpenAI API Key

**⚠️ IMPORTANT: Update your API key**

Edit the file `lib/constants/gpt_constant.dart` and replace the placeholder API key:

```dart
const openaiKey = 'your-actual-openai-api-key-here';
```

**Security Note:** Never commit your actual API key to version control. Consider using environment variables or secure storage for production apps.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

#### For Development (Debug Mode)
```bash
flutter run
```

#### For Specific Platforms

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

### 5. Build for Production

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
├── main.dart                 # App entry point and main UI
├── models/
│   └── chat_model.dart      # Chat state management
├── widgets/
│   ├── chat_list.dart       # Chat messages list
│   ├── user_bubble.dart     # User message bubble
│   ├── gpt_bubble.dart      # AI message bubble
│   └── user_input.dart      # Message input field
├── apis/
│   └── openai_api.dart      # OpenAI API integration
└── constants/
    └── gpt_constant.dart    # API configuration
```

## Troubleshooting

### Common Issues

1. **API Key Error**
   - Make sure you've updated the API key in `lib/constants/gpt_constant.dart`
   - Verify your OpenAI account has sufficient credits
   - Check that your API key is valid and active

2. **Flutter Doctor Issues**
   ```bash
   flutter doctor
   ```
   Follow the suggestions to resolve any issues.

3. **Dependencies Issues**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Platform-Specific Issues**
   - **Android**: Ensure Android SDK is properly installed
   - **iOS**: Requires Xcode (macOS only)
   - **Web**: Use a modern browser (Chrome recommended)

### Network Issues

If you're experiencing network connectivity issues:

1. Check your internet connection
2. Verify firewall settings allow Flutter/Dart
3. For corporate networks, you may need to configure proxy settings

## API Usage and Costs

- This app uses OpenAI's GPT-3.5-turbo model by default
- Each message sent incurs a small cost based on OpenAI's pricing
- Monitor your usage at: https://platform.openai.com/usage
- Consider implementing usage limits for production apps

## Customization

### Changing the AI Model

Edit `lib/apis/openai_api.dart` and modify the model parameter:

```dart
"model": "gpt-4", // or other available models
```

### Theming

The app uses Material Design 3 with a custom color scheme. Modify the theme in `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF10A37F), // Change this color
  brightness: Brightness.light,
),
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Review Flutter documentation: https://flutter.dev/docs
3. Check OpenAI API documentation: https://platform.openai.com/docs
4. Create an issue in the repository

---

**Happy coding! 🚀**