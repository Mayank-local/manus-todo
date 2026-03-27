# Development Guide

## Development Environment Setup

### Prerequisites

Before you start developing, ensure you have the following installed:

- **Flutter SDK**: Version 3.0 or higher ([Download](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: Version 3.0 or higher (included with Flutter)
- **Android Studio** or **Xcode**: For emulator and device support
- **Git**: For version control
- **VS Code** or **Android Studio**: Recommended IDEs with Flutter extensions

### Verify Installation

Run the following commands to verify your setup:

```bash
flutter --version
dart --version
flutter doctor
```

The `flutter doctor` command should show all green checkmarks for a complete setup.

## Project Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd todo_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

This command reads `pubspec.yaml` and installs all required packages.

### 3. Run the App

```bash
flutter run
```

For a specific device:

```bash
flutter run -d <device_id>
```

To list available devices:

```bash
flutter devices
```

## Development Workflow

### Code Structure

The project follows a clean architecture with the following structure:

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   └── task.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── add_edit_task_screen.dart
│   └── about_screen.dart
├── widgets/                  # Reusable widgets
│   ├── task_card.dart
│   └── empty_state.dart
└── services/                 # Business logic and data
    ├── task_service.dart
    └── task_provider.dart
```

### Adding New Features

#### 1. Create a New Model

Create a new file in `lib/models/`:

```dart
// lib/models/new_model.dart
class NewModel {
  final String id;
  final String name;
  
  NewModel({required this.id, required this.name});
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  
  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(id: json['id'], name: json['name']);
  }
}
```

#### 2. Create a Service

Create a new file in `lib/services/`:

```dart
// lib/services/new_service.dart
class NewService {
  static Future<void> initializeService() async {
    // Initialize service
  }
  
  static Future<List<NewModel>> getAll() async {
    // Fetch data
  }
}
```

#### 3. Create a Provider

Extend the existing provider or create a new one:

```dart
// lib/services/new_provider.dart
class NewProvider extends ChangeNotifier {
  List<NewModel> _items = [];
  
  List<NewModel> get items => _items;
  
  Future<void> loadItems() async {
    _items = await NewService.getAll();
    notifyListeners();
  }
}
```

#### 4. Create UI Components

Create screens and widgets in `lib/screens/` and `lib/widgets/`:

```dart
// lib/screens/new_screen.dart
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Consumer<NewProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(provider.items[index].name));
            },
          );
        },
      ),
    );
  }
}
```

## Code Style and Conventions

### Naming Conventions

- **Classes**: PascalCase (e.g., `TaskProvider`, `HomeScreen`)
- **Variables and Functions**: camelCase (e.g., `taskTitle`, `loadTasks()`)
- **Constants**: camelCase (e.g., `maxTaskLength`)
- **Files**: snake_case (e.g., `task_provider.dart`)

### Code Formatting

Run the formatter before committing:

```bash
dart format lib/
```

Check code style:

```bash
dart analyze lib/
```

### Documentation

Add documentation comments to all public classes and methods:

```dart
/// Loads all tasks from local storage
/// 
/// Returns a list of [Task] objects sorted by priority and completion status.
/// Throws an exception if the database operation fails.
Future<List<Task>> loadTasks() async {
  // Implementation
}
```

## Testing

### Running Tests

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

### Writing Tests

Create test files in the `test/` directory:

```dart
// test/models/task_test.dart
void main() {
  group('Task Model', () {
    test('Task creation', () {
      final task = Task(title: 'Test Task');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, false);
    });
    
    test('Task copyWith', () {
      final task = Task(title: 'Original');
      final updated = task.copyWith(title: 'Updated');
      expect(updated.title, 'Updated');
      expect(task.title, 'Original');
    });
  });
}
```

## Debugging

### Debug Mode

Run the app in debug mode (default):

```bash
flutter run
```

### Release Mode

Run the app in release mode:

```bash
flutter run --release
```

### Hot Reload

During development, use hot reload to see changes instantly:

- Press `r` in the terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Flutter DevTools

Open DevTools for debugging:

```bash
flutter pub global activate devtools
devtools
```

Then run your app with:

```bash
flutter run --observatory-port=8888
```

## Building for Production

### Android Build

Generate a signed APK:

```bash
flutter build apk --release
```

Generate an App Bundle:

```bash
flutter build appbundle --release
```

### iOS Build

Generate an iOS app:

```bash
flutter build ios --release
```

### Web Build

Generate a web build:

```bash
flutter build web --release
```

## Dependency Management

### Adding Dependencies

Add dependencies to `pubspec.yaml`:

```yaml
dependencies:
  new_package: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Updating Dependencies

Update all dependencies:

```bash
flutter pub upgrade
```

Update a specific package:

```bash
flutter pub upgrade package_name
```

### Checking for Outdated Packages

```bash
flutter pub outdated
```

## Common Issues and Solutions

### Issue: "Flutter not found"

**Solution**: Add Flutter to your PATH environment variable. See [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).

### Issue: "Gradle build failed"

**Solution**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "iOS build fails"

**Solution**:
```bash
cd ios
pod install
cd ..
flutter run
```

### Issue: "Hot reload not working"

**Solution**: Use hot restart instead:
```bash
Press R in the terminal
```

## Performance Optimization

### Tips for Better Performance

1. **Use const constructors**: Mark widgets as const when possible
2. **Avoid rebuilds**: Use Consumer or Selector to rebuild only necessary widgets
3. **Lazy load data**: Load data only when needed
4. **Optimize images**: Use appropriate image sizes and formats
5. **Profile your app**: Use DevTools to identify performance bottlenecks

### Profiling

Use the DevTools Performance tab to profile your app:

```bash
flutter run --profile
```

## Git Workflow

### Commit Messages

Use clear, descriptive commit messages:

```
feat: Add task search functionality
fix: Fix task sorting issue
docs: Update README
refactor: Simplify task loading logic
```

### Branch Naming

Use descriptive branch names:

```
feature/task-search
bugfix/sorting-issue
docs/update-readme
```

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v1
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Material 3 Design](https://m3.material.io/)
- [Provider Package Documentation](https://pub.dev/packages/provider)
- [Hive Database Documentation](https://docs.hivedb.dev/)

## Support and Contribution

For issues, questions, or contributions, please contact:

- **Email**: devmayank.inbox@gmail.com
- **Organization**: DML Labs

---

Happy coding! 🚀
