import 'package:advent_calendar_app/main.dart' as app;
import 'package:advent_calendar_app/services/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    CalendarController.defaultNowBuilder = DateTime.now;
  });

  testWidgets('opens available day and persists state', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    CalendarController.defaultNowBuilder = () => DateTime(2023, 12, 1);

    await app.main();
    await tester.pumpAndSettle();

    final doorOne = find.text('1');
    expect(doorOne, findsOneWidget);

    await tester.tap(doorOne);
    await tester.pumpAndSettle();

    expect(find.textContaining('Giorno 1'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('opened_days'), contains('1'));
  });
}
