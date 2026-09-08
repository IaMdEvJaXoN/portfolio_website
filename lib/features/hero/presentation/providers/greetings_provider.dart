import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final randomGreetingsProvider = NotifierProvider(() {
  return RandomGreetingsNotifier();
});

class RandomGreetingsNotifier extends Notifier<DateTime> {
  Timer? _timer;
  @override
  DateTime build() {
    state = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      if (now.hour > 4 && now.hour < 12) {
        state = now;
      } else if (now.hour > 11 && now.hour < 17) {
        state = now;
      } else if (now.hour > 16 && now.hour < 21) {
        state = now;
      } else {
        state = now;
      }
    });
    ref.onDispose(() {
      _timer?.cancel();
    });
    return state;
  }
}
