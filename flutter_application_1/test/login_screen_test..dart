// test/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/login_screeen.dart'; // change path if needed

void main() {
  testWidgets('LoginScreen UI and functionality test', (WidgetTester tester) async {
    String? testEmail;
    String? testPassword;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {
            testEmail = email;
            testPassword = password;},),),);
    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.byKey(const Key('loginButton'));
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.tap(loginButton);
    await tester.pump(); // To rebuild after tap
    expect(testEmail, 'test@example.com');
    expect(testPassword, 'password123');});}
