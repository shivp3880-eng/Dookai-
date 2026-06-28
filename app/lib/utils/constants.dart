import 'package:intl/intl.dart';

class AppConstants {
  static const appName = 'DookAI';
  static const appVersion = '1.0.0';
  static const appDescription = 'Your Smart AI Assistant';

  // Firebase collection names
  static const String usersCollection = 'users';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';

  // Padding and margins
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;

  // Animation durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // UI Constants
  static const int maxChatTitleLength = 100;
  static const int maxMessagePreviewLength = 100;
}

class AppStrings {
  // Auth
  static const String continueWithGoogle = 'Continue with Google';
  static const String signInRequired = 'Sign in to your account';
  static const String signedInSuccessfully = 'Signed in successfully!';
  static const String failedToSignIn = 'Failed to sign in. Please try again.';

  // Home
  static const String welcomeMessage = 'Welcome back';
  static const String newChat = 'New Chat';
  static const String searchChats = 'Search chats';
  static const String recentChats = 'Recent Chats';
  static const String pinnedChats = 'Pinned Chats';
  static const String noChats = 'No chats yet. Start a new conversation!';

  // Chat
  static const String typeMessage = 'Type your message...';
  static const String sendMessage = 'Send';
  static const String regenerate = 'Regenerate';
  static const String copyMessage = 'Copy';
  static const String deleteMessage = 'Delete';
  static const String favoriteMessage = 'Favorite';

  // Profile
  static const String profile = 'Profile';
  static const String email = 'Email';
  static const String logout = 'Logout';
  static const String logoutConfirmation = 'Are you sure you want to logout?';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountConfirmation =
      'Are you sure? This will permanently delete your account and all data.';

  // Settings
  static const String settings = 'Settings';
  static const String darkMode = 'Dark Mode';
  static const String about = 'About';
  static const String appInfo = 'Application Information';
  static const String version = 'Version';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';

  // Messages
  static const String loading = 'Loading...';
  static const String error = 'Error occurred';
  static const String tryAgain = 'Try Again';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String save = 'Save';
}

class AppFormatters {
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  static String formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday =
        now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat('EEE').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  static String truncateString(String str, int length) {
    return str.length > length ? str.substring(0, length) + '...' : str;
  }
}

class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
