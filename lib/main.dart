import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:numeracy_app/models/operation.dart';
import 'package:numeracy_app/screens/home/home.dart';
import 'package:numeracy_app/screens/questions/question.dart';
import 'package:numeracy_app/screens/splash/splash_screen.dart';
import 'package:numeracy_app/screens/stats/stats.dart';
import 'package:numeracy_app/screens/layout/main_layout.dart';
import 'package:numeracy_app/services/stats_service.dart';
import 'package:numeracy_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Initialize the stats service
  await StatsService.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late final GoRouter _router = GoRouter(
    initialLocation: '/', // Start with splash screen
    routes: [
      // Splash Screen Route
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Main Layout with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Home Route
          GoRoute(
            path: '/home',
            builder: (context, state) => const Home(),
          ),

          // Stats Route
          GoRoute(
            path: '/stats',
            builder: (context, state) => const Stats(),
          ),
        ],
      ),

      // Questions Route (outside of main layout)
      GoRoute(
        path: '/questions',
        builder: (context, state) {
          final range = state.uri.queryParameters['range'] ?? 'b';
          final operationsParam = state.uri.queryParameters['operations'];

          List<Operation> operations;
          if (operationsParam != null && operationsParam.isNotEmpty) {
            operations = operationsParam
                .split(',')
                .map((op) => OperationExtension.fromString(op))
                .toList();
          } else {
            operations = Operation.values;
          }

          return Question(range: range, operations: operations);
        },
      ),

      // Nested Questions Route from Home
      GoRoute(
        path: '/home/questions',
        builder: (context, state) {
          final range = state.uri.queryParameters['range'] ?? 'b';
          final operationsParam = state.uri.queryParameters['operations'];

          List<Operation> operations;
          if (operationsParam != null && operationsParam.isNotEmpty) {
            operations = operationsParam
                .split(',')
                .map((op) => OperationExtension.fromString(op))
                .toList();
          } else {
            operations = Operation.values;
          }

          return Question(range: range, operations: operations);
        },
      ),
    ],
    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: primaryTheme,
      routerConfig: _router,
      title: 'Numeracy',
      debugShowCheckedModeBanner: false, // Remove debug banner for cleaner look
    );
  }
}

// Error screen for handling navigation errors
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Oops!'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.errorColor,
              ),
              SizedBox(height: AppDimensions.spacingM),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                'We encountered an unexpected error. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
