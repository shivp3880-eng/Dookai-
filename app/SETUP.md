# DookAI Setup Guide

This guide will help you set up DookAI on your local machine and deploy it to Firebase.

## Prerequisites

- **Flutter**: 3.0 or higher - [Install](https://flutter.dev/docs/get-started/install)
- **Dart**: 3.0 or higher (included with Flutter)
- **Git**: For version control
- **Firebase Project**: Create one at [Firebase Console](https://console.firebase.google.com)
- **Google Cloud Account**: For Google Sign-In
- **IDE**: VS Code, Android Studio, or Xcode

## Step 1: Flutter Setup

### Install Flutter

```bash
# macOS
brew install flutter

# Windows
# Download from https://flutter.dev/docs/get-started/install/windows

# Linux
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
```

### Verify Installation

```bash
flutter doctor
```

### Install Android SDK (for Android development)

```bash
# macOS
brew install android-studio

# Or download from https://developer.android.com/studio
```

### Accept Android Licenses

```bash
flutter doctor --android-licenses
```

## Step 2: Firebase Project Setup

### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Enter project name: "DookAI"
4. Accept the terms and create the project

### Enable Required Services

1. **Firestore Database**
   - Go to "Firestore Database" in the left menu
   - Click "Create Database"
   - Choose "Production mode"
   - Select your region

2. **Authentication**
   - Go to "Authentication" in the left menu
   - Click "Get Started"
   - Enable "Google" sign-in method
   - Configure OAuth consent screen with your app info

3. **Storage**
   - Go to "Storage" in the left menu
   - Click "Get Started"

## Step 3: Configure Firebase for Each Platform

### For Android

1. Go to Project Settings
2. Click "Add App" → Select Android
3. Enter package name: `com.example.dookai`
4. Download `google-services.json`
5. Place it in: `app/android/app/google-services.json`

### For iOS

1. Go to Project Settings
2. Click "Add App" → Select iOS
3. Enter bundle ID: `com.example.dookai`
4. Download `GoogleService-Info.plist`
5. Place it in: `app/ios/Runner/GoogleService-Info.plist`

### For Web

1. Go to Project Settings
2. Click "Add App" → Select Web
3. Copy the Firebase config
4. Save in your configuration file

## Step 4: Update Firebase Configuration

Edit `lib/firebase_options.dart` and replace placeholder values:

```dart
// Find your credentials in Firebase Console > Project Settings
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);

// Repeat for iOS, Web, macOS, and Windows
```

## Step 5: Project Setup

### Clone/Navigate to Project

```bash
cd /workspaces/Dookai-/app
```

### Get Dependencies

```bash
flutter pub get
```

### Generate Build Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 6: Firestore Security Rules

Update Firestore security rules:

1. Go to Firestore → Rules
2. Replace with these rules:

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

3. Click "Publish"

## Step 7: Running the App

### Android

```bash
# Connect Android device or start emulator
flutter devices

# Run on device
flutter run

# Or specify device
flutter run -d emulator-5554
```

### iOS

```bash
# Install CocoaPods (first time only)
sudo gem install cocoapods

# Run on device
flutter run

# Or specify device
flutter run -d "iPhone 14"
```

### Web

```bash
flutter run -d chrome
```

## Step 8: AI API Integration

Currently, the app uses simulated AI responses. To integrate a real AI API:

### Option A: Google Gemini API

1. Enable Generative Language API in Google Cloud
2. Get API key from Google Cloud Console
3. Update `lib/services/ai_service.dart`:

```dart
Future<String> generateResponse(String prompt) async {
  try {
    final response = await _dio.post(
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$_apiKey',
      data: {
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ]
      },
    );
    
    final text = response.data['candidates'][0]['content']['parts'][0]['text'];
    return text;
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
```

### Option B: OpenAI API

1. Create account at [OpenAI](https://openai.com)
2. Generate API key from account settings
3. Update `lib/services/ai_service.dart`:

```dart
Future<String> generateResponse(String prompt) async {
  try {
    final response = await _dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt}
        ]
      },
      options: Options(
        headers: {'Authorization': 'Bearer $_apiKey'}
      ),
    );
    
    return response.data['choices'][0]['message']['content'];
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
```

## Step 9: Testing

### Run Tests

```bash
flutter test
```

### Build APK

```bash
flutter build apk --release
```

### Build App Bundle

```bash
flutter build appbundle --release
```

## Troubleshooting

### Issue: "No Android SDK found"
```bash
flutter config --android-sdk /path/to/android/sdk
```

### Issue: "Pod install error"
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### Issue: Firebase not initialized
- Ensure `google-services.json` is in the correct location
- Rebuild the app: `flutter clean && flutter pub get && flutter run`

### Issue: Google Sign-In fails
- Check Firebase Console authentication settings
- Verify package name matches your app
- Ensure Google Sign-In is enabled in Firebase

## Performance Tips

1. Use `--profile` mode for testing performance
   ```bash
   flutter run --profile
   ```

2. Check performance with DevTools
   ```bash
   flutter pub global activate devtools
   devtools
   ```

3. Profile with Android Profiler or Xcode Instruments

## Next Steps

1. ✅ Complete the setup steps above
2. ✅ Test the app locally
3. ✅ Configure your AI API
4. ✅ Customize branding and colors
5. ✅ Deploy to app stores

## Support

For issues:
- Check Flutter documentation: https://flutter.dev/docs
- Check Firebase documentation: https://firebase.google.com/docs
- Review project README.md
- Check GitHub issues

## Resources

- [Flutter Official](https://flutter.dev)
- [Firebase Official](https://firebase.google.com)
- [Dart Documentation](https://dart.dev)
- [Riverpod Documentation](https://riverpod.dev)

---

Happy coding! 🚀
