import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/weather_screen.dart';

void main() {
  group('Weather UI Widget Test', () {
    testWidgets('Displays weather UI and interacts properly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WeatherScreen()));

      // Let the FutureBuilder complete API call
      await tester.pumpAndSettle();

      // --- BASIC UI ELEMENTS ---
      expect(find.byType(DropdownButton<String>), findsOneWidget, reason: 'City selector should be present');
      expect(find.byType(Switch), findsOneWidget, reason: 'C/F toggle switch should be present');
      expect(find.textContaining("°"), findsWidgets, reason: 'Temperature display should be shown');
      expect(find.textContaining("☀️").first, findsWidgets, reason: 'Weather icon should be visible');

      // --- DROPDOWN INTERACTION ---
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Kathmandu'), findsOneWidget);
      expect(find.text('Pokhara'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);

      await tester.tap(find.text('Pokhara').last);
      await tester.pumpAndSettle();

      expect(find.text('Pokhara'), findsWidgets);

      // --- UNIT TOGGLE ---
      final switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining("°F"), findsWidgets, reason: 'Temperature should switch to Fahrenheit');

      // --- FORECAST LIST ---
      expect(find.byType(ListView), findsWidgets, reason: 'Forecast list views should be scrollable');
      expect(find.byType(Scrollable), findsWidgets);
    });
  });
}
