import 'package:advent_calendar_app/screens/calendar_screen.dart';
import 'package:advent_calendar_app/services/calendar_controller.dart';
import 'package:advent_calendar_app/services/unlock_repository.dart';
import 'package:advent_calendar_app/widgets/calendar_door.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _InMemoryUnlockRepository extends UnlockRepository {
  _InMemoryUnlockRepository({Iterable<int>? initial})
      : _store = <int>{...?(initial?.toList())};

  final Set<int> _store;

  @override
  Future<Set<int>> loadUnlockedDays() async => <int>{..._store};

  @override
  Future<void> saveUnlockedDays(Set<int> days) async {
    _store
      ..clear()
      ..addAll(days);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CalendarScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    testWidgets('locks future days and allows current day', (tester) async {
      final repository = _InMemoryUnlockRepository();
      final controller = CalendarController(
        repository: repository,
        nowBuilder: () => DateTime(2023, 12, 5),
      );
      await controller.initialize();

      final router = GoRouter(
        initialLocation: CalendarScreen.routePath,
        routes: <RouteBase>[
          GoRoute(
            path: CalendarScreen.routePath,
            builder: (context, state) => const CalendarScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CalendarController>.value(value: controller),
            Provider<UnlockRepository>.value(value: repository),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();

      final finderDay5 = find.widgetWithText(CalendarDoor, '5');
      final finderDay6 = find.widgetWithText(CalendarDoor, '6');

      expect(finderDay5, findsOneWidget);
      expect(finderDay6, findsOneWidget);

      await tester.tap(finderDay5);
      await tester.pumpAndSettle();

      expect(controller.statusForDay(5), CalendarDoorState.opened);
      expect(controller.statusForDay(6), CalendarDoorState.locked);
    });
  });
}
