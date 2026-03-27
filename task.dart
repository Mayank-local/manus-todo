import 'package:uuid/uuid.dart';

/// Enumeration for task priority levels
enum TaskPriority {
  low,
  medium,
  high,
}

/// Enumeration for task categories
enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  other,
}

/// Model class representing a single task
class Task {
  /// Unique identifier for the task
  final String id;

  /// Title of the task
  String title;

  /// Detailed description of the task
  String description;

  /// Whether the task is completed
  bool isCompleted;

  /// Priority level of the task
  TaskPriority priority;

  /// Category of the task
  TaskCategory category;

  /// Date and time when the task was created
  final DateTime createdAt;

  /// Date and time when the task was last modified
  DateTime updatedAt;

  /// Optional due date for the task
  DateTime? dueDate;

  /// Constructor for creating a new Task instance
  Task({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.other,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a copy of the task with modified fields
  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Convert Task to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.toString(),
      'category': category.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => TaskCategory.other,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  /// Get a human-readable string for priority
  String get priorityLabel {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  /// Get a human-readable string for category
  String get categoryLabel {
    switch (category) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.other:
        return 'Other';
    }
  }

  @override
  String toString() => 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
}
