import 'package:flutter/material.dart';

/// About screen displaying app information and credits
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.task_alt,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'To-Do List',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 0.1.0',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // About section
              Text(
                'About the App',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'To-Do List is a beautiful and intuitive task management application built with Flutter and Material 3 design. It helps you organize your tasks, set priorities, and track your productivity.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Features section
              Text(
                'Features',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.check_circle_outline,
                'Complete Task Management',
                'Create, read, update, and delete tasks with ease',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.priority_high,
                'Priority Levels',
                'Organize tasks by Low, Medium, and High priority',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.category_outlined,
                'Task Categories',
                'Categorize tasks: Work, Personal, Shopping, Health, and Other',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.calendar_today_outlined,
                'Due Dates',
                'Set due dates for your tasks to stay on track',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.storage_outlined,
                'Local Storage',
                'All your tasks are saved locally on your device',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                context,
                Icons.design_services_outlined,
                'Material 3 Design',
                'Beautiful and modern UI with smooth animations',
              ),
              const SizedBox(height: 32),

              // Developer section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developed by',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DML Labs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lead Engineer',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      'devmayank.inbox@gmail.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // License section
              Text(
                'License',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This app is built with Flutter and uses the Material 3 design system. All code is written in Dart and follows best practices for mobile app development.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  '© 2024 DML Labs. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a feature item
  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
