import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//One-shot staggered per-word drop, now with [startDelay] for sequencing
//and reduced-motion support.
class DropInText extends StatefulWidget {
  const DropInText({
    super.key,
    required this.text,
    required this.style,
    this.dropDistance = 18.0,
    this.staggerPerWord = const Duration(milliseconds: 160),
    this.wordDuration = const Duration(milliseconds: 550),
    this.wordSpacing = 6.0,
    this.startDelay = Duration.zero,
  });

  final String text;
  final TextStyle? style;
  final double dropDistance;
  final Duration staggerPerWord;
  final Duration wordDuration;
  final double wordSpacing;
  final Duration startDelay;

  @override
  State<DropInText> createState() => _DropInTextState();
}

class _DropInTextState extends State<DropInText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<String> _words;
  late final bool _reduceMotion;

  @override
  void initState() {
    super.initState();
    _reduceMotion = SchedulerBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;

    _words = widget.text.split(' ').where((w) => w.isNotEmpty).toList();
    final totalMs =
        widget.staggerPerWord.inMilliseconds * _words.length +
        widget.wordDuration.inMilliseconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    if (_reduceMotion) {
      _controller.value = 1.0;
      return;
    }

    Future.delayed(widget.startDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _controller.duration!.inMilliseconds;
    final staggerMs = widget.staggerPerWord.inMilliseconds;
    final wordMs = widget.wordDuration.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Wrap(
          spacing: widget.wordSpacing,
          runSpacing: 4,
          children: List.generate(_words.length, (i) {
            final startMs = i * staggerMs;
            final endMs = (startMs + wordMs).clamp(0, totalMs);
            final interval = Interval(
              startMs / totalMs,
              endMs / totalMs,
              curve: Curves.fastOutSlowIn,
            );
            final t = interval.transform(_controller.value);

            return Transform.translate(
              offset: Offset(0, (1 - t) * -widget.dropDistance),
              child: Opacity(
                opacity: t,
                child: Text(_words[i], style: widget.style),
              ),
            );
          }),
        );
      },
    );
  }
}
