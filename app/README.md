# DookAI - Your Smart AI Assistant

A modern, beautiful, and optimized AI chatbot application built with Flutter and Firebase. DookAI provides a seamless conversational experience with intelligent AI responses, similar to Gemini and ChatGPT.

## 🌟 Features

### Authentication
- ✅ Google Sign-In with Firebase Authentication
- ✅ Auto-login for returning users with session persistence
- ✅ Secure logout functionality
- ✅ Smooth authentication transitions

### User Interface
- ✅ Beautiful splash screen with smooth animations
- ✅ Modern login screen with Google Sign-In
- ✅ Personalized home screen with welcome message
- ✅ Dark mode and light mode support
- ✅ Smooth animations and transitions throughout the app

### Chat Features
- ✅ Real-time AI chat responses with streaming output
- ✅ Markdown formatting support with syntax highlighting
- ✅ Copy message functionality
- ✅ Favorite/bookmark responses
- ✅ AI typing animation
- ✅ Message regeneration
- ✅ Suggested prompts

### Chat Management
- ✅ Multiple conversations with unique IDs
- ✅ Chat history saved in Firestore
- ✅ Rename and delete chats
- ✅ Pin favorite chats
- ✅ Search functionality across chats
- ✅ Recent chats display with pinned section

### Additional Features
- ✅ User profile page with account information
- ✅ Settings page with theme customization
- ✅ Firebase integration for secure backend
- ✅ Optimized performance for mobile devices
- ✅ Responsive design for all screen sizes

## 📋 Project Structure

```
app/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── firebase_options.dart     # Firebase configuration
│   ├── screens/                  # All screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── settings_screen.dart
│   │   └── index.dart
│   ├── models/                   # Data models
│   │   ├── chat_model.dart
│   │   ├── message_model.dart
│   │   ├── user_model.dart
│   │   └── index.dart
│   ├── services/                 # Business logic
│   │   ├── auth_service.dart
│   │   ├── firebase_service.dart
│   │   ├── ai_service.dart
│   │   └── index.dart
│   ├── providers/                # Riverpod state management
│   │   └── app_providers.dart
│   ├── widgets/                  # Reusable widgets
│   │   └── custom_widgets.dart
│   └── utils/                    # Utilities and constants
│       ├── theme.dart
│       ├── constants.dart
│       └── formatters.dart
├── assets/                       # Images, icons, fonts
├── android/                      # Android native code
├── ios/                          # iOS native code
├── pubspec.yaml                  # Dependencies
├── analysis_options.yaml         # Linting rules
└── README.md                     # This file
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+ ([Download](https://flutter.dev/docs/get-started/install))
- Dart SDK 3.0+
- Firebase Project ([Create](https://console.firebase.google.com))
- Git

### Installation

1. **Clone the repository**
   ```bash
   cd /workspaces/Dookai-/app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Create apps for your platforms (Android, iOS, Web)
   - Update `lib/firebase_options.dart` with your Firebase credentials
   - Enable Google Sign-In in Firebase Authentication
   - Create Firestore database with appropriate security rules

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Setup

1. **Create Firestore Database**
   - Go to Firestore Database in Firebase Console
   - Create a database in production mode
   - Set up the following collections:

   ```
   users/
   ├── {uid}
   │   ├── email: string
   │   ├── displayName: string
   │   ├── photoUrl: string
   │   ├── createdAt: timestamp
   │   ├── lastLoginAt: timestamp
   │   └── isDarkMode: boolean

   chats/
   ├── {chatId}
   │   ├── userId: string
   │   ├── title: string
   │   ├── lastMessage: string
   │   ├── createdAt: timestamp
   │   ├── updatedAt: timestamp
   │   ├── isPinned: boolean
   │   ├── messageCount: integer
   │   └── messages/ (subcollection)
   │       └── {messageId}
   │           ├── chatId: string
   │           ├── userId: string
   │           ├── content: string
   │           ├── sender: string (user/ai)
   │           ├── createdAt: timestamp
   │           └── isFavorite: boolean
   ```

2. **Security Rules**

   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users collection
       match /users/{userId} {
         allow read, write: if request.auth.uid == userId;
       }

       // Chats collection
       match /chats/{chatId} {
         allow read, write: if request.auth.uid == resource.data.userId;
         allow create: if request.auth.uid == request.resource.data.userId;
         
         // Messages subcollection
         match /messages/{messageId} {
           allow read, write: if request.auth.uid == resource.data.userId;
           allow create: if request.auth.uid == request.resource.data.userId;
         }
       }
     }
   }
   ```

3. **Enable Google Sign-In**
   - Go to Authentication > Sign-in method in Firebase Console
   - Enable Google Sign-In
   - Configure OAuth consent screen

### AI Service Integration

Currently, `AIService` includes a simulated response generator. To integrate a real AI API:

1. **Option A: Using Gemini API**
   ```dart
   // Update lib/services/ai_service.dart
   final response = await _dio.post(
     'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent',
     data: {'contents': [{'parts': [{'text': prompt}]}]},
     queryParameters: {'key': _apiKey},
   );
   ```

2. **Option B: Using OpenAI API**
   ```dart
   final response = await _dio.post(
     'https://api.openai.com/v1/chat/completions',
     data: {
       'model': 'gpt-3.5-turbo',
       'messages': [{'role': 'user', 'content': prompt}],
     },
     options: Options(headers: {'Authorization': 'Bearer $_apiKey'}),
   );
   ```

## 📦 Dependencies

### Core
- `flutter`: Flutter SDK
- `firebase_core`: Firebase initialization
- `firebase_auth`: Google Sign-In authentication
- `cloud_firestore`: Database
- `firebase_storage`: File storage

### State Management
- `flutter_riverpod`: State management
- `provider`: Alternative provider pattern

### UI & Design
- `google_fonts`: Modern typography
- `animate_do`: Animations
- `lottie`: Complex animations
- `shimmer`: Loading effects

### Markdown & Code
- `flutter_markdown`: Markdown rendering
- `highlight`: Code syntax highlighting
- `markdown`: Markdown parsing

### Utilities
- `http` / `dio`: HTTP requests
- `intl`: Internationalization
- `uuid`: ID generation
- `connectivity_plus`: Network connectivity
- `cached_network_image`: Image caching
- `path_provider`: File paths

## 🏗️ Architecture

DookAI follows a clean architecture pattern:

```
Presentation Layer (Screens & Widgets)
        ↓
State Management Layer (Riverpod Providers)
        ↓
Business Logic Layer (Services)
        ↓
Data Layer (Models & Firebase)
```

### Data Flow

1. **User Interaction** → Screens capture user input
2. **Providers** → Manage state and trigger services
3. **Services** → Handle business logic
4. **Models** → Serialize/deserialize data
5. **Firebase** → Persist and retrieve data

## 🎨 Theming

The app supports both light and dark modes:

- **Light Theme**: Clean, bright interface with indigo primary color
- **Dark Theme**: Dark background with accent colors for optimal viewing

Switch themes in Settings screen or programmatically:

```dart
// Update theme preference
await authService.updateThemePreference(userId, isDarkMode: true);
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🔒 Security Best Practices

1. **Authentication**: Firebase handles secure authentication
2. **Database**: Firestore security rules restrict unauthorized access
3. **Encryption**: All data in transit uses HTTPS
4. **Environment Variables**: Sensitive configs in environment files
5. **No Hardcoded Secrets**: API keys stored securely

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📊 Performance Optimization

- ✅ Lazy loading of data
- ✅ Image caching
- ✅ Efficient stream subscriptions
- ✅ Widget rebuilding optimization
- ✅ Firebase indexing for queries

## 🐛 Debugging

Enable debug logging:
```dart
// In firebase_options.dart or main.dart
FirebaseOptions(..., enableLogging: true);
```

View Firebase logs:
```bash
flutter logs
```

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎓 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Dart Language](https://dart.dev/guides)

## 🆘 Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review code comments
- Contact the development team

## 🎯 Future Enhancements

- [ ] Voice input and output
- [ ] Image sharing in chats
- [ ] Real-time chat synchronization across devices
- [ ] Chat export (PDF, TXT)
- [ ] Advanced search with filters
- [ ] Chat categorization and tagging
- [ ] User preferences for AI response style
- [ ] Integration with more AI services
- [ ] Offline mode support
- [ ] Chat analytics and statistics

## 📄 Changelog

### Version 1.0.0
- Initial release
- Core features implemented
- Firebase integration
- Google Sign-In
- Dark mode support
- Chat management

---

**Made with ❤️ by DookAI Team**

Last Updated: June 2024
