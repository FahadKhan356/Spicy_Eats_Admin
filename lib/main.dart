import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/config/router.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:spicy_eats_admin/utils/reload_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await runZonedGuarded(() async {
    // The binding must be initialised inside the same zone that later calls
    // `runApp`, otherwise Flutter reports "Zone mismatch" and zone-scoped
    // error handling silently stops working.
    WidgetsFlutterBinding.ensureInitialized();

    var supabaseReady = false;
    try {
      await Supabase.initialize(
        url: supabaseURL,
        anonKey: supabaseAnonKey,
      );
      supabaseReady = true;
    } catch (e) {
      debugPrint('Supabase init failed: $e');
    }

    if (supabaseReady) {
      final uri = Uri.base;
      final hasOAuthParams = uri.queryParameters.containsKey('code') ||
          uri.queryParameters.containsKey('access_token');

      if (hasOAuthParams) {
        try {
          await supabaseClient.auth.getSessionFromUrl(uri, storeSession: true);
        } catch (e) {
          debugPrint('OAuth session restore failed: $e');
        }
      }

      listenToAuth();
    }

    FlutterError.onError = (details) {
      debugPrint('FlutterError: ${details.exceptionAsString()}');
      debugPrint(details.stack.toString());
    };

    ErrorWidget.builder = (details) =>
        ErrorCrashView(message: details.exception.toString());

    if (!supabaseReady) {
      runApp(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BootstrapErrorScreen(),
        ),
      );
      return;
    }

    runApp(const ProviderScope(child: SpicyEatsAdminApp()));
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error');
    debugPrint(stack.toString());
  });
}

class BootstrapErrorScreen extends StatelessWidget {
  const BootstrapErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 44, color: Colors.red),
                const SizedBox(height: 14),
                const Text(
                  'Cannot reach Spicy Eats',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The backend did not start. Check your internet connection '
                  'and the Supabase keys, then reload this page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorCrashView extends StatelessWidget {
  final String message;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const ErrorCrashView({super.key, required this.message, this.stackTrace, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    // `ErrorWidget.builder` output is mounted where the failing widget used to
    // be, which can be above `MaterialApp` and therefore have no ambient
    // `Directionality`/`Material`. Without these wrappers this view throws as
    // well and Flutter falls back to its raw red error screen.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bug_report_outlined,
                        size: 44, color: Colors.red),
                    const SizedBox(height: 14),
                    const Text(
                      'This screen hit an error',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black87),
                      ),
                    ),
                    if (isWeb && stackTrace != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          stackTrace.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (onRetry != null)
                      FilledButton(
                        onPressed: onRetry,
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text('Try again'),
                      ),
                    if (isWeb) ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: reloadPage,
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text('Reload page'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpicyEatsAdminApp extends StatefulWidget {
  const SpicyEatsAdminApp({super.key});

  @override
  State<SpicyEatsAdminApp> createState() => _SpicyEatsAdminAppState();
}

class _SpicyEatsAdminAppState extends State<SpicyEatsAdminApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Spicy Eats Partner Portal',
      builder: (context, child) => ErrorBoundary(child: child ?? const SizedBox()),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(245, 245, 245, 1),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (details) {
      debugPrint('Widget build error: ${details.exception}');
      return ErrorCrashView(
        message: details.exception.toString(),
        stackTrace: details.stack,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
