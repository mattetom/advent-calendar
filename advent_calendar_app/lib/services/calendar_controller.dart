import 'dart:async';

import 'package:flutter/foundation.dart';

import 'unlock_repository.dart';

enum CalendarDoorState { locked, available, opened }

class CalendarController extends ChangeNotifier {
  CalendarController({
    required UnlockRepository repository,
    DateTime Function()? nowBuilder,
  })  : _repository = repository,
        _nowBuilder = nowBuilder ?? defaultNowBuilder;

  static DateTime Function() defaultNowBuilder = DateTime.now;

  final UnlockRepository _repository;
  final DateTime Function() _nowBuilder;

  bool _initialized = false;
  Set<int> _openedDays = <int>{};

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _openedDays = await _repository.loadUnlockedDays();
    _initialized = true;
    notifyListeners();
  }

  CalendarDoorState statusForDay(int day) {
    if (_openedDays.contains(day)) {
      return CalendarDoorState.opened;
    }
    return _isDayAvailable(day)
        ? CalendarDoorState.available
        : CalendarDoorState.locked;
  }

  bool canOpenDay(int day) => statusForDay(day) != CalendarDoorState.locked;

  Future<bool> openDay(int day) async {
    if (!canOpenDay(day)) {
      return false;
    }
    if (_openedDays.add(day)) {
      await _repository.saveUnlockedDays(_openedDays);
      notifyListeners();
    }
    return true;
  }

  bool _isDayAvailable(int day) {
    final now = _nowBuilder();
    if (now.month != DateTime.december) {
      return false;
    }
    final candidate = DateTime(now.year, DateTime.december, day);
    final nowDateOnly = DateTime(now.year, now.month, now.day);
    return !candidate.isAfter(nowDateOnly);
  }
}
