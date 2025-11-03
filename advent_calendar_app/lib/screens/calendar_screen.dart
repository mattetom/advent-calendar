import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../services/calendar_controller.dart';
import 'content_screen.dart';
import '../widgets/calendar_door.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const String routePath = '/';

  int _crossAxisCount(SizingInformation sizing) {
    if (sizing.screenSize.width >= 1200) {
      return 6;
    }
    if (sizing.deviceScreenType == DeviceScreenType.tablet ||
        sizing.screenSize.width >= 800) {
      return 5;
    }
    if (sizing.screenSize.width >= 500) {
      return 4;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CalendarController>();

    if (!controller.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario dell\'Avvento'),
      ),
      body: ScreenTypeLayout.builder(
        mobile: (context) => _buildGrid(context, controller),
        tablet: (context) => _buildGrid(context, controller),
        desktop: (context) => _buildGrid(context, controller),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, CalendarController controller) {
    return ResponsiveBuilder(
      builder: (context, sizing) {
        final crossAxisCount = _crossAxisCount(sizing);
        final spacing = sizing.screenSize.width >= 800 ? 24.0 : 12.0;

        return Padding(
          padding: EdgeInsets.all(spacing),
          child: GridView.builder(
            itemCount: 24,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              final day = index + 1;
              final status = controller.statusForDay(day);
              return CalendarDoor(
                day: day,
                state: status,
                onTap: () async {
                  final opened = await controller.openDay(day);
                  if (opened) {
                    if (!context.mounted) return;
                    context.go('${ContentScreen.routePath}/$day');
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Questa casella non è ancora disponibile. Torna più tardi!',
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
