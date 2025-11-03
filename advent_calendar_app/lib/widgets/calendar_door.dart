import 'package:flutter/material.dart';

import '../services/calendar_controller.dart';

class CalendarDoor extends StatelessWidget {
  const CalendarDoor({
    required this.day,
    required this.state,
    required this.onTap,
    super.key,
  });

  final int day;
  final CalendarDoorState state;
  final VoidCallback onTap;

  Color _backgroundColor(ThemeData theme) {
    switch (state) {
      case CalendarDoorState.opened:
        return theme.colorScheme.secondaryContainer;
      case CalendarDoorState.available:
        return theme.colorScheme.primaryContainer;
      case CalendarDoorState.locked:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  IconData _icon() {
    switch (state) {
      case CalendarDoorState.opened:
        return Icons.emoji_events;
      case CalendarDoorState.available:
        return Icons.lock_open;
      case CalendarDoorState.locked:
        return Icons.lock_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Semantics(
      button: true,
      enabled: state != CalendarDoorState.locked,
      label: 'Casella del $day dicembre',
      child: Material(
        color: _backgroundColor(theme),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: state == CalendarDoorState.locked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icon(), size: 36),
                const SizedBox(height: 12),
                Text(
                  '$day',
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
