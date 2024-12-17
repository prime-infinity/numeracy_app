import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numeracy_app/screens/home/home.dart';
import 'package:numeracy_app/shared/buttons/styled_button.dart';
import 'package:numeracy_app/shared/texts/styled_text.dart';
import 'package:numeracy_app/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
      // You can add more routes here later
    ],
    // Optional: Add error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: primaryTheme,
      routerConfig: _router,
      title: 'Numeracy',
    );
  }
}

// Optional error screen for handling navigation errors
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Something went wrong: ${error.toString()}'),
      ),
    );
  }
}

class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StyledSmallText("normal text", AppColors.black),
            StyledButton(
                text: "save",
                onPressed: () {
                  //print('Save button pressed');
                }),
            // With custom width and colors:
            StyledButton(
              text: "Delete",
              width: 200, // Specific width in pixels
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                //print('Delete button pressed');
              },
            ),
            // With loading state:
            StyledButton(
              text: "Loading Example",
              isLoading: true, // Shows loading spinner instead of text
              onPressed: () {
                //print('Button pressed');
              },
            ),
            StyledButton(
                text: "Primary button",
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  //print("primary button clicked");
                }),
          ],
        ),
      ),
    );
  }
}
