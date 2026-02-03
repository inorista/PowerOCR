import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, context),
            const SizedBox(height: 24),
            _buildMainAction(context, theme),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Recent Scans',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildRecentScansList(theme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.scanning),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'PowerOCR',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    theme.brightness == Brightness.light
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainAction(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withBlue(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push(AppRouter.scanning),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.document_scanner,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Start Scanning',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Digitize your documents',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentScansList(ThemeData theme) {
    // Placeholder for empty state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No recent scans',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scanned documents will appear here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
