import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'task_service.dart';

/// Provider class for managing task state and business logic
class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  /// Get the current list of tasks
  List<Task> get tasks => _tasks;

  /// Check if tasks are being loaded
  bool get isLoading => _isLoading;

  /// Get count of incomplete tasks
  int get incompleteTaskCount => _tasks.where((task) => !task.isCompleted).length;

  /// Get count of completed tasks
  int get completedTaskCount => _tasks.where((task) => task.isCompleted).length;

  /// Initialize and load all tasks from storage
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await TaskService.getAllTasks();
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await TaskService.addTask(task);
      _tasks.add(task);
      _sortTasks();
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await TaskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        _sortTasks();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  /// Delete a task by ID
  Future<void> deleteTask(String id) async {
    try {
      await TaskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        final task = _tasks[index];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await TaskService.updateTask(updatedTask);
        _tasks[index] = updatedTask;
        _sortTasks();
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling task completion: $e');
      rethrow;
    }
  }

  /// Get tasks filtered by category
  List<Task> getTasksByCategory(TaskCategory category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  /// Get tasks filtered by priority
  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  /// Get incomplete tasks
  List<Task> getIncompleteTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  /// Get completed tasks
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  /// Search tasks by title or description
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    final lowerQuery = query.toLowerCase();
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(lowerQuery) ||
            task.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Sort tasks by priority and completion status
  void _sortTasks() {
    _tasks.sort((a, b) {
      // Incomplete tasks first
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Then by priority (high to low)
      final priorityOrder = {
        TaskPriority.high: 0,
        TaskPriority.medium: 1,
        TaskPriority.low: 2,
      };
      final priorityDiff = (priorityOrder[a.priority] ?? 2)
          .compareTo(priorityOrder[b.priority] ?? 2);
      if (priorityDiff != 0) return priorityDiff;
      // Finally by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    try {
      await TaskService.deleteAllTasks();
      _tasks.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing all tasks: $e');
      rethrow;
    }
  }
}
