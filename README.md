# To-Do List Mobile App

A beautiful and intuitive task management application built with Flutter and Material 3 design. Organize your tasks, set priorities, and track your productivity with ease.

## 📋 Features

- **Complete CRUD Operations**: Create, read, update, and delete tasks seamlessly
- **Task Priorities**: Organize tasks by Low, Medium, and High priority levels
- **Task Categories**: Categorize tasks into Work, Personal, Shopping, Health, and Other
- **Due Dates**: Set due dates for your tasks to stay on track
- **Task Completion**: Mark tasks as complete or incomplete with a single tap
- **Local Data Persistence**: All tasks are saved locally using Hive database
- **Search Functionality**: Search tasks by title or description
- **Filter Options**: Filter tasks by All, Active, or Completed status
- **Swipe Actions**: Swipe left to delete or swipe right to edit tasks
- **Material 3 Design**: Beautiful and modern UI with smooth animations
- **Dark Mode Support**: Automatic light/dark theme based on system settings
- **Statistics Dashboard**: View task statistics in the app drawer

## 🎨 Design Highlights

- **Material 3 (Material You)**: Follows the latest Material Design guidelines with `useMaterial3: true`
- **Dynamic Color Scheme**: Color scheme generated from a seed color for consistency
- **Smooth Animations**: Transitions and interactions with smooth animations
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Intuitive UI**: Clean layout with clear visual hierarchy
- **Accessibility**: Proper contrast ratios and touch target sizes

## 🛠️ Technical Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Local Database**: Hive
- **UI Library**: Material 3
- **Date Formatting**: intl package
- **UUID Generation**: uuid package

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  provider: ^6.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.19.0
  uuid: ^4.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio or Xcode (for emulator/device)

### Installation

1. **Clone or extract the project**:
   ```bash
   cd todo_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

   Or for a specific device:
   ```bash
   flutter run -d <device_id>
   ```

### Running on Different Platforms

**Android**:
```bash
flutter run -d android
```

**iOS**:
```bash
flutter run -d ios
```

**Web** (if enabled):
```bash
flutter run -d chrome
```

## 📁 Project Structure

```
todo_app/
├── lib/
│   ├── main.dart                          # Entry point with theme configuration
│   ├── models/
│   │   └── task.dart                      # Task model with enums
│   ├── screens/
│   │   ├── home_screen.dart               # Main task list screen
│   │   ├── add_edit_task_screen.dart      # Add/edit task screen
│   │   └── about_screen.dart              # About and credits screen
│   ├── widgets/
│   │   ├── task_card.dart                 # Task card widget with swipe actions
│   │   └── empty_state.dart               # Empty state widget
│   └── services/
│       ├── task_service.dart              # Hive database operations
│       └── task_provider.dart             # State management with Provider
├── pubspec.yaml                           # Project dependencies
├── README.md                              # This file
└── android/                               # Android platform code
└── ios/                                   # iOS platform code
```

## 🎯 Usage Guide

### Creating a Task

1. Tap the **+** button in the bottom-right corner
2. Enter the task title (required)
3. Add an optional description
4. Select a priority level (Low, Medium, High)
5. Choose a category (Work, Personal, Shopping, Health, Other)
6. Optionally set a due date
7. Tap "Create Task"

### Editing a Task

- **Option 1**: Tap on the task card to open the edit screen
- **Option 2**: Swipe the task card to the left to reveal the edit button
- Make your changes and tap "Update Task"

### Completing a Task

- Tap the checkbox on the task card to mark it as complete/incomplete
- Completed tasks appear with a strikethrough and move to the bottom of the list

### Deleting a Task

- **Option 1**: Swipe the task card to the right to reveal the delete button
- **Option 2**: Swipe left and tap the delete button
- An undo option appears in the snackbar for 3 seconds

### Filtering Tasks

Use the filter chips at the top of the home screen:
- **All**: Show all tasks
- **Active**: Show only incomplete tasks
- **Completed**: Show only completed tasks

### Searching Tasks

Use the search bar to find tasks by title or description. Search works across all filter categories.

### Viewing Statistics

Open the app drawer (hamburger menu) to see:
- Total number of tasks
- Number of active tasks
- Number of completed tasks

### About the App

Tap the **ℹ️** icon in the app bar to view:
- App version and information
- Feature list
- Developer credits (DML Labs)
- Lead Engineer contact: devmayank.inbox@gmail.com

## 💾 Data Persistence

All tasks are stored locally using **Hive**, a fast and lightweight database for Flutter:

- **Storage Location**: Device-specific app documents directory
- **Automatic Sorting**: Tasks are automatically sorted by:
  1. Completion status (incomplete first)
  2. Priority level (High → Medium → Low)
  3. Creation date (newest first)
- **Data Sync**: Changes are immediately persisted to the database

## 🎨 Theme Customization

The app uses Material 3 with a custom color scheme. To customize colors:

1. Open `lib/main.dart`
2. Modify the `seedColor` in `ColorScheme.fromSeed()`:
   ```dart
   ColorScheme.fromSeed(
     seedColor: const Color(0xFF6750A4), // Change this color
     brightness: Brightness.light,
   ),
   ```

## 🧪 Testing

To run tests:

```bash
flutter test
```

## 📱 Supported Devices

- **Android**: 5.0 (API 21) and above
- **iOS**: 11.0 and above
- **Web**: Chrome, Firefox, Safari, Edge

## 🐛 Known Issues

None at this time. Please report any issues you encounter.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is developed by **DML Labs** and is provided as-is for educational and personal use.

## 👨‍💼 Developer Information

**Developed by**: DML Labs  
**Lead Engineer**: devmayank.inbox@gmail.com  
**Version**: 0.1.0

## 🔄 Future Enhancements

Planned features for future releases:

- Cloud synchronization
- Task reminders and notifications
- Recurring tasks
- Task attachments
- Collaboration features
- Export/Import functionality
- Custom themes and color schemes
- Task notes and comments

## 📞 Support

For issues, questions, or suggestions, please contact:
- **Email**: devmayank.inbox@gmail.com
- **Organization**: DML Labs

---

**Happy task management! 🚀**
