# Contributing to DookAI

Thank you for your interest in contributing to DookAI! We welcome contributions from everyone.

## Code of Conduct

Please be respectful and constructive in your interactions with other contributors.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported
2. Create a new GitHub issue
3. Include:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Your environment (OS, Flutter version, etc.)

### Suggesting Features

1. Create a new GitHub issue with the `enhancement` label
2. Describe the feature and why it would be useful
3. Include examples if applicable

### Code Contributions

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/Dookai.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow Flutter and Dart best practices
   - Write clear, well-commented code
   - Run `flutter analyze` to check for issues
   - Run `dart format` to format code

4. **Test your changes**
   ```bash
   flutter test
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Clear description of changes
   - Reference any related issues
   - Include screenshots for UI changes

## Code Style Guide

### Dart/Flutter Code

- Use meaningful variable and function names
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `const` where possible
- Document public APIs with comments
- Max line length: 80 characters (comments) / 100 characters (code)

### Example:

```dart
/// Generates an AI response for the given prompt.
/// 
/// Returns the generated response text.
/// Throws an exception if the API call fails.
Future<String> generateResponse(String prompt) async {
  if (prompt.isEmpty) {
    throw ArgumentError('Prompt cannot be empty');
  }
  
  // Implementation here
  return response;
}
```

### Naming Conventions

- **Classes**: PascalCase (`UserModel`, `ChatScreen`)
- **Functions/Variables**: camelCase (`getUserData`, `messageCount`)
- **Constants**: camelCase in classes (`defaultPadding`)
- **Private members**: Prefix with underscore (`_controller`, `_init()`)

### File Organization

```
lib/
├── screens/          # UI screens
├── models/           # Data models
├── services/         # Business logic
├── providers/        # State management
├── widgets/          # Reusable components
└── utils/           # Utilities and helpers
```

## Testing

### Unit Tests

```dart
test('validateEmail should return error for invalid email', () {
  expect(
    AppValidators.validateEmail('invalid'),
    isNotNull,
  );
});
```

### Widget Tests

```dart
testWidgets('CustomButton displays label', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: CustomButton(
          label: 'Test',
          onPressed: () {},
        ),
      ),
    ),
  );
  
  expect(find.text('Test'), findsOneWidget);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/user_model_test.dart

# Run tests with coverage
flutter test --coverage
```

## Commit Message Guidelines

- Use imperative mood ("Add feature" not "Added feature")
- Reference issues when applicable (#123)
- Keep first line under 50 characters
- Separate subject from body with blank line

### Example:

```
Add dark mode theme support

- Implement dark theme in AppTheme
- Update Settings screen with toggle
- Add theme preference to user model
- Persist theme preference to Firestore

Fixes #42
```

## Documentation

- Update README.md for user-facing changes
- Add docstring comments for new functions
- Include inline comments for complex logic
- Update CHANGELOG.md with notable changes

## Pull Request Process

1. Update documentation as needed
2. Add tests for new functionality
3. Run `flutter analyze` and `dart format`
4. Ensure all tests pass
5. Keep PRs focused on a single feature
6. Be responsive to code review feedback

## Review Process

- Maintainers will review within 1-2 weeks
- We may request changes or clarifications
- Once approved, your PR will be merged

## Development Setup

```bash
# Clone the repo
git clone https://github.com/yourusername/Dookai.git
cd Dookai/app

# Get dependencies
flutter pub get

# Run dev version
flutter run

# Run with hot reload
flutter run -v

# Run tests
flutter test
```

## Getting Help

- Check existing documentation
- Review similar code in the project
- Ask in GitHub issues
- Check Flutter/Firebase documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

We appreciate your contributions to making DookAI better! 🙏
