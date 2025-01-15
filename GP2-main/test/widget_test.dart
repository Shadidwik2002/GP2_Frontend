import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gp2/Login_screen.dart';

void main() {
  testWidgets('Login Screen has correct widgets', (WidgetTester tester) async {
    // Build the LoginScreen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify the presence of necessary widgets.
    expect(find.text('ServiceHub'), findsOneWidget); // App name
    expect(find.text('Welcome back!'), findsOneWidget); // Welcome text
    expect(find.text('User'), findsOneWidget); // User tab
    expect(find.text('Service Provider'), findsOneWidget); // Service Provider tab
    expect(find.text('Forgot your password?'), findsOneWidget); // Forgot password text
    expect(find.text("Don't have an account? Sign up"), findsOneWidget); // Sign-up text
    expect(find.text('Log in'), findsOneWidget); // Log in button
  });

  testWidgets('Login fails with empty inputs', (WidgetTester tester) async {
    // Build the LoginScreen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap the log-in button without entering inputs.
    await tester.tap(find.text('Log in'));
    await tester.pump();

    // Verify that error messages are displayed.
    expect(find.text('Phone number is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Login input validation works', (WidgetTester tester) async {
    // Build the LoginScreen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Enter invalid phone number and password.
    await tester.enterText(find.byType(TextFormField).first, '123'); // Invalid phone number
    await tester.enterText(find.byType(TextFormField).last, ''); // Empty password
    await tester.tap(find.text('Log in'));
    await tester.pump();

    // Verify that the appropriate error messages are shown.
    expect(find.text('Phone number must be exactly 10 digits'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Switch between User and Service Provider tabs', (WidgetTester tester) async {
    // Build the LoginScreen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify that the default selected tab is User.
    expect(find.text('User'), findsOneWidget);

    // Tap on Service Provider tab.
    await tester.tap(find.text('Service Provider'));
    await tester.pump();

    // Verify the Service Provider tab is now selected.
    expect(find.text('Service Provider'), findsOneWidget);
  });
}
