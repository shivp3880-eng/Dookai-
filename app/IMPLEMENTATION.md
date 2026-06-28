# DookAI Implementation Guide

Complete guide to implementing and customizing DookAI for your needs.

## Table of Contents
1. [Project Structure](#project-structure)
2. [Core Components](#core-components)
3. [Feature Implementation](#feature-implementation)
4. [Customization](#customization)
5. [Deployment](#deployment)

## Project Structure

```
DookAI/
├── app/                          # Main Flutter application
│   ├── lib/
│   │   ├── main.dart            # Entry point, routing
│   │   ├── firebase_options.dart # Firebase configuration
│   │   ├── screens/             # UI screens (6 screens)
│   │   ├── models/              # Data models (Chat, Message, User)
│   │   ├── services/            # Business logic (Auth, Firebase, AI)
│   │   ├── providers/           # Riverpod state management
│   │   ├── widgets/             # Reusable UI components
│   │   └── utils/               # Utilities (theme, constants)
│   ├── test/                    # Unit and widget tests
│   ├── android/                 # Android native code
│   ├── ios/                     # iOS native code
│   ├── web/                     # Web platform code
│   ├── pubspec.yaml            # Dependencies
│   └── analysis_options.yaml   # Linting rules
├── SETUP.md                     # Detailed setup instructions
├── README.md                    # Project overview
├── CONTRIBUTING.md              # Contribution guidelines
├── CHANGELOG.md                 # Version history
└── LICENSE                      # MIT License
```

## Core Components

### 1. Authentication (`services/auth_service.dart`)

Handles user authentication with Google Sign-In and Firebase.

**Key Methods:**
```dart
// Sign in with Google
Future<UserModel?> signInWithGoogle()

// Sign out
Future<void> signOut()

// Get user data from Firestore
Future<UserModel?> getUserData(String uid)

// Update theme preference
Future<void> updateThemePreference(String uid, bool isDarkMode)

// Delete account
Future<void> deleteAccount(String uid)
```

**Usage Example:**
```dart
final authService = ref.read(authServiceProvider);
final user = await authService.signInWithGoogle();
```

### 2. Firebase Service (`services/firebase_service.dart`)

Manages all Firestore operations for chats and messages.

**Key Methods:**
```dart
// Chat operations
Future<Chat> createChat(String userId, String title)
Stream<List<Chat>> getUserChats(String userId)
Future<void> updateChatTitle(String chatId, String newTitle)
Future<void> togglePinChat(String chatId, bool isPinned)
Future<void> deleteChat(String chatId)

// Message operations
Future<Message> addMessage(String chatId, String userId, String content, String sender)
Stream<List<Message>> getChatMessages(String chatId)
Future<void> toggleFavoriteMessage(String chatId, String messageId, bool isFavorite)
```

**Usage Example:**
```dart
final firebaseService = ref.read(firebaseServiceProvider);
final chat = await firebaseService.createChat(userId, 'New Chat');
final messages = firebaseService.getChatMessages(chatId);
```

### 3. AI Service (`services/ai_service.dart`)

Handles AI response generation.

**Current Implementation:** Simulated responses
**Ready for Integration:** Gemini API, OpenAI API, or custom services

**Key Methods:**
```dart
Future<String> generateResponse(String prompt)
Stream<String> streamAIResponse(String prompt)
List<String> getSuggestedPrompts()
```

### 4. State Management (Riverpod)

Manages app-wide state using Riverpod providers.

**Key Providers:**
```dart
// Authentication state
final authStateProvider = StreamProvider<User?>
final currentUserProvider = Provider<User?>
final userDataProvider = FutureProvider.family<UserModel?, String>

// Chat state
final userChatsProvider = StreamProvider<List<Chat>>
final chatProvider = FutureProvider.family<Chat?, String>
final chatMessagesProvider = StreamProvider.family<List<Message>, String>

// UI state
final suggestedPromptsProvider = Provider<List<String>>
```

## Feature Implementation

### Adding a New Feature

#### 1. Create Model (if needed)
```dart
// lib/models/new_model.dart
class NewModel {
  final String id;
  final String userId;
  // ... other fields
  
  factory NewModel.fromFirestore(DocumentSnapshot doc) { }
  Map<String, dynamic> toFirestore() { }
}
```

#### 2. Create Service
```dart
// lib/services/new_service.dart
class NewService {
  Future<NewModel> getData() async { }
  Stream<List<NewModel>> streamData() { }
}
```

#### 3. Create Provider
```dart
// In lib/providers/app_providers.dart
final newDataProvider = StreamProvider<List<NewModel>>((ref) {
  final service = ref.watch(newServiceProvider);
  return service.streamData();
});
```

#### 4. Create UI Screen
```dart
// lib/screens/new_screen.dart
class NewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(newDataProvider);
    return data.when(
      data: (items) => ListView(...),
      loading: () => LoadingWidget(),
      error: (err, stack) => ErrorWidget(...),
    );
  }
}
```

#### 5. Add Routing
```dart
// In main.dart
routes: {
  '/new-screen': (context) => const NewScreen(),
},
```

## Customization

### 1. Branding

Update app colors in `lib/utils/theme.dart`:

```dart
static const primaryColor = Color(0xFF6366F1);  // Your brand color
static const secondaryColor = Color(0xFF8B5CF6);
static const accentColor = Color(0xFFEC4899);
```

### 2. App Name and Info

Update in `lib/utils/constants.dart`:

```dart
static const appName = 'DookAI';
static const appVersion = '1.0.0';
static const appDescription = 'Your Smart AI Assistant';
```

### 3. Firebase Configuration

Update `lib/firebase_options.dart` with your credentials.

### 4. AI Service Integration

Replace simulation in `lib/services/ai_service.dart`:

```dart
Future<String> generateResponse(String prompt) async {
  // Replace with your AI API implementation
  // Example: Gemini, OpenAI, or custom API
}
```

### 5. UI Customization

- **Fonts**: Update in `pubspec.yaml` and `lib/utils/theme.dart`
- **Icons**: Add to `assets/icons/` and reference in code
- **Images**: Add to `assets/images/` and reference in code
- **Animations**: Adjust duration constants in `lib/utils/constants.dart`

## Screens Overview

### 1. Splash Screen (`screens/splash_screen.dart`)
- App initialization
- Auto-redirect to login or home based on auth state
- Logo animation
- Loading indicator

### 2. Login Screen (`screens/login_screen.dart`)
- Google Sign-In integration
- Feature highlights
- Smooth animations
- Error handling

### 3. Home Screen (`screens/home_screen.dart`)
- Personalized welcome message
- New Chat button
- Search functionality
- Chat list with pinned section
- Chat management (pin/delete)

### 4. Chat Screen (`screens/chat_screen.dart`)
- Message display with streaming
- User message input
- AI response generation
- Message actions (copy, favorite, delete)
- Chat renaming and deletion

### 5. Profile Screen (`screens/profile_screen.dart`)
- User profile information
- Account details display
- Logout functionality
- Account deletion option

### 6. Settings Screen (`screens/settings_screen.dart`)
- Dark/light mode toggle
- App information
- Support and feedback options
- Links to privacy policy and terms

## Deployment

### Android Deployment

```bash
# Generate signed APK
flutter build apk --release

# Generate app bundle for Play Store
flutter build appbundle --release
```

**Deployment Steps:**
1. Create developer account on Google Play
2. Create new app
3. Fill in app details
4. Upload app bundle
5. Add screenshots and description
6. Submit for review

### iOS Deployment

```bash
# Generate iOS build
flutter build ios --release
```

**Deployment Steps:**
1. Create developer account on Apple Developer
2. Create App ID in App Store Connect
3. Create iOS signing certificates
4. Archive in Xcode
5. Submit to App Store
6. Add app metadata
7. Submit for review

### Web Deployment

```bash
# Build web version
flutter build web --release
```

**Deployment Options:**
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages
- AWS Amplify
- Custom server

## Performance Optimization

### Database Indexing

Create Firestore indexes for better query performance:
```
Collection: chats
Fields: userId (Ascending), updatedAt (Descending)

Collection: chats > messages
Fields: createdAt (Ascending)
```

### Image Caching

Use `cached_network_image` package for efficient image loading:
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

### Query Optimization

- Use `.limit()` for pagination
- Use `.where()` to filter data
- Create indexes for frequently queried fields
- Use batch writes for bulk operations

## Testing

### Unit Tests

```bash
flutter test test/models/
flutter test test/services/
```

### Widget Tests

```bash
flutter test test/widgets/
flutter test test/screens/
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## Monitoring and Analytics

### Firebase Crashlytics

```dart
FirebaseCrashlytics.instance.recordError(error, stackTrace);
```

### Firebase Analytics

```dart
FirebaseAnalytics.instance.logEvent(name: 'chat_created');
```

## Security Checklist

- ✅ Firebase Security Rules configured
- ✅ Google Sign-In authentication enabled
- ✅ HTTPS for all API calls
- ✅ No hardcoded secrets in code
- ✅ Environment variables for sensitive data
- ✅ Input validation on all forms
- ✅ Error handling without exposing sensitive info
- ✅ Regular security updates for dependencies

## Troubleshooting

### Common Issues

**Issue: Firebase not initialized**
- Check `firebase_options.dart` configuration
- Ensure `google-services.json` is in the right location
- Run `flutter clean && flutter pub get`

**Issue: Google Sign-In fails**
- Verify Firebase Authentication settings
- Check OAuth consent screen configuration
- Ensure package name matches app configuration

**Issue: Firestore security errors**
- Check security rules in Firebase Console
- Verify user UID in security rules
- Check collection/document paths

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Dart Effective Guide](https://dart.dev/guides/language/effective-dart)

---

For more information, refer to README.md and SETUP.md
