import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

/// Service class for managing task persistence using Hive
class TaskService {
  static const String _boxName = 'tasks';

  /// Initialize Hive and open the tasks box
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  /// Get the tasks box
  static Box<String> _getBox() {
    return Hive.box<String>(_boxName);
  }

  /// Get all tasks from local storage
  static Future<List<Task>> getAllTasks() async {
    try {
      final box = _getBox();
      final tasks = <Task>[];

      for (var key in box.keys) {
        final jsonString = box.get(key);
        if (jsonString != null) {
          final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
          tasks.add(Task.fromJson(jsonMap));
        }
      }

      // Sort tasks: incomplete first, then by priority, then by creation date
      tasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        final priorityOrder = {
          TaskPriority.high: 0,
          TaskPriority.medium: 1,
          TaskPriority.low: 2,
        };
        final priorityDiff =
            (priorityOrder[a.priority] ?? 2).compareTo(priorityOrder[b.priority] ?? 2);
        if (priorityDiff != 0) return priorityDiff;
        return b.createdAt.compareTo(a.createdAt);
      });

      return tasks;
    } catch (e) {
      print('Error getting all tasks: $e');
      return [];
    }
  }

  /// Get a single task by ID
  static Future<Task?> getTaskById(String id) async {
    try {
      final box = _getBox();
      final jsonString = box.get(id);
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return Task.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      print('Error getting task by ID: $e');
      return null;
    }
  }

  /// Add a new task
  static Future<void> addTask(Task task) async {
    try {
      final box = _getBox();
      final jsonString = jsonEncode(task.toJson());
      await box.put(task.id, jsonString);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  /// Update an existing task
  static Future<void> updateTask(Task task) async {
    try {
      final box = _getBox();
      final jsonString = jsonEncode(task.toJson());
      await box.put(task.id, jsonString);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  /// Delete a task by ID
  static Future<void> deleteTask(String id) async {
    try {
      final box = _getBox();
      await box.delete(id);
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// Toggle task completion status
  static Future<void> toggleTaskCompletion(String id) async {
    try {
      final task = await getTaskById(id);
      if (task != null) {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await updateTask(updatedTask);
      }
    } catch (e) {
      print('Error toggling task completion: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  static Future<void> deleteAllTasks() async {
    try {
      final box = _getBox();
      await box.clear();
    } catch (e) {
      print('Error deleting all tasks: $e');
      rethrow;
    }
  }

  /// Get tasks filtered by category
  static Future<List<Task>> getTasksByCategory(TaskCategory category) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.category == category).toList();
    } catch (e) {
      print('Error getting tasks by category: $e');
      return [];
    }
  }

  /// Get tasks filtered by priority
  static Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.priority == priority).toList();
    } catch (e) {
      print('Error getting tasks by priority: $e');
      return [];
    }
  }

  /// Get completed tasks
  static Future<List<Task>> getCompletedTasks() async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.isCompleted).toList();
    } catch (e) {
      print('Error getting completed tasks: $e');
      return [];
    }
  }

  /// Get incomplete tasks
  static Future<List<Task>> getIncompleteTasks() async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => !task.isCompleted).toList();
    } catch (e) {
      print('Error getting incomplete tasks: $e');
      return [];
    }
  }
}
