import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_task_screen.dart';
import 'about_screen.dart';

/// Home screen displaying the list of tasks
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Current filter: all, incomplete, or completed
  TaskFilter _currentFilter = TaskFilter.all;

  /// Search query
  String _searchQuery = '';

  /// Search controller
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Load tasks when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get filtered tasks based on current filter and search query
  List<Task> _getFilteredTasks(List<Task> allTasks) {
    List<Task> filtered;

    switch (_currentFilter) {
      case TaskFilter.incomplete:
        filtered = allTasks.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = allTasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.all:
      default:
        filtered = allTasks;
    }

    if (_searchQuery.isEmpty) {
      return filtered;
    }

    final lowerQuery = _searchQuery.toLowerCase();
    return filtered
        .where((task) =>
            task.title.toLowerCase().contains(lowerQuery) ||
            task.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('To-Do List'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final filteredTasks = _getFilteredTasks(taskProvider.tasks);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search tasks...',
                  leading: const Icon(Icons.search),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        filter: TaskFilter.all,
                        count: taskProvider.tasks.length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Active',
                        filter: TaskFilter.incomplete,
                        count: taskProvider.incompleteTaskCount,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Completed',
                        filter: TaskFilter.completed,
                        count: taskProvider.completedTaskCount,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Task list
              Expanded(
                child: filteredTasks.isEmpty
                    ? EmptyState(
                        icon: Icons.task_alt_outlined,
                        title: _getEmptyStateTitle(),
                        subtitle: _getEmptyStateSubtitle(),
                        onAction: () {
                          _navigateToAddTask(context);
                        },
                        actionLabel: 'Add Task',
                      )
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return TaskCard(
                            task: task,
                            onTap: () {
                              _navigateToEditTask(context, task);
                            },
                            onToggleComplete: (isComplete) {
                              context
                                  .read<TaskProvider>()
                                  .toggleTaskCompletion(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isComplete
                                        ? 'Task marked as complete'
                                        : 'Task marked as incomplete',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            onDelete: () {
                              context.read<TaskProvider>().deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Task deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      context
                                          .read<TaskProvider>()
                                          .addTask(task);
                                    },
                                  ),
                                ),
                              );
                            },
                            onEdit: () {
                              _navigateToEditTask(context, task);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTask(context);
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build a filter chip
  Widget _buildFilterChip({
    required String label,
    required TaskFilter filter,
    required int count,
  }) {
    final isSelected = _currentFilter == filter;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _currentFilter = filter;
        });
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
      ),
    );
  }

  /// Get empty state title based on current filter
  String _getEmptyStateTitle() {
    switch (_currentFilter) {
      case TaskFilter.incomplete:
        return 'All caught up!';
      case TaskFilter.completed:
        return 'No completed tasks';
      case TaskFilter.all:
      default:
        return 'No tasks yet';
    }
  }

  /// Get empty state subtitle based on current filter
  String _getEmptyStateSubtitle() {
    switch (_currentFilter) {
      case TaskFilter.incomplete:
        return 'You have completed all your tasks. Great job!';
      case TaskFilter.completed:
        return 'Complete a task to see it here';
      case TaskFilter.all:
      default:
        return 'Create your first task to get started';
    }
  }

  /// Navigate to add task screen
  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEditTaskScreen(),
      ),
    );
  }

  /// Navigate to edit task screen
  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
  }

  /// Build the app drawer
  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 48,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(height: 16),
                Text(
                  'To-Do List',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, _) {
                    return Column(
                      children: [
                        _buildStatRow(
                          'Total Tasks',
                          taskProvider.tasks.length.toString(),
                          Icons.task_outlined,
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          'Active',
                          taskProvider.incompleteTaskCount.toString(),
                          Icons.circle_outlined,
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          'Completed',
                          taskProvider.completedTaskCount.toString(),
                          Icons.check_circle_outlined,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a statistic row in the drawer
  Widget _buildStatRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Enum for task filtering
enum TaskFilter { all, incomplete, completed }
