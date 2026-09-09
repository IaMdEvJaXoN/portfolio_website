import 'dart:math';

class GreetingsDeterminer {
  GreetingsDeterminer._();

  static final Random _random = Random();

  static const _morning = [
    'Voltage is up, so am I.Good morning.',
    'Wavefunction collapsed into "awake." Good morning.',
    "Good morning — entropy hasn't won yet.",
    'Rise and Fourier transform.',
    'Morning. Ground state exited successfully.',
  ];

  static const _afternoon = [
    'Midday checkpoint.No bugs found yet.',
    'Peak load hours. Good afternoon.',
    'Halfway through the duty cycle.',
    'Operating comfortably within the Nyquist limit today.',
    "Afternoon — Schrödinger's coffee: both full and empty.",
    'Still coherent.Barely. Good afternoon.',
    'No observed collapse in productivity yet.',
  ];

  static const _evening = [
    'Evening — decoherence setting in.',
    'Good evening. Entropy finally winning.',
    'Evening. Bandwidth throttled, spirits high.',
    'Powering down the op-amp of the day.',
  ];

  static const _lateNight = [
    'Running past bedtime like an infinite loop.',
    'Late-night debugging hours.',
    'Hey — quantum tunneling through bedtime.',
    'Still up? Must be in an excited state.',
    "Hey. Heisenberg couldn't tell you if it's late or early either.",
    'Running on stack overflow and caffeine. Hey.',
  ];

  static String determineGreeting(DateTime now) {
    final hour = now.hour;

    final List<String> pool;
    if (hour > 4 && hour < 12) {
      pool = _morning;
    } else if (hour > 11 && hour < 17) {
      pool = _afternoon;
    } else if (hour > 16 && hour < 21) {
      pool = _evening;
    } else {
      pool = _lateNight;
    }

    return pool[_random.nextInt(pool.length)];
  }
}
