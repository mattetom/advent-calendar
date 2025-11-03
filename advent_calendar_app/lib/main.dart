import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/calendar_screen.dart';
import 'screens/content_screen.dart';
import 'services/calendar_controller.dart';
import 'services/unlock_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = UnlockRepository();
  final controller = CalendarController(repository: repository);
  await controller.initialize();

  final router = GoRouter(
    initialLocation: CalendarScreen.routePath,
    routes: <RouteBase>[
      GoRoute(
        path: CalendarScreen.routePath,
        builder: (context, state) => const CalendarScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: '${ContentScreen.routePath}/:day',
            builder: (context, state) {
              final day = int.tryParse(state.pathParameters['day'] ?? '') ?? 1;
              return ContentScreen(day: day);
            },
          ),
        ],
      ),
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarController>.value(value: controller),
        Provider<UnlockRepository>.value(value: repository),
      ],
      child: AdventCalendarApp(router: router),
    ),
  );
}

class AdventCalendarApp extends StatelessWidget {
  const AdventCalendarApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Advent Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade700),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
