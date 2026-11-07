import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spicy_eats_admin/Authentication/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:spicy_eats_admin/Authentication/ForgotPassword/ResetPasswordScreen.dart';

void main() {
  group('ForgotPasswordScreen widget tests', () {
    testWidgets('renders all initial UI elements properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ForgotPasswordScreen())),
      );

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('validates empty email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ForgotPasswordScreen())),
      );

      // Tap Send Reset Link without entering email
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ForgotPasswordScreen())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'not-an-email',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });
  });

  group('ResetPasswordScreen widget tests', () {
    testWidgets('renders initial UI elements properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ResetPasswordScreen())),
      );

      expect(find.text('Create New Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm New Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('validates empty and short passwords', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ResetPasswordScreen())),
      );

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('New password is required'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'New Password'),
        '1234',
      );
      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(
        find.text('Password must be at least 9 characters'),
        findsOneWidget,
      );
    });

    testWidgets('validates mismatching passwords', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ResetPasswordScreen())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'New Password'),
        'pass123456',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm New Password'),
        'passdifferent',
      );
      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });
}
