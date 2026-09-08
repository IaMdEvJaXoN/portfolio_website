import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FadeInText extends StatefulWidget {
  const FadeInText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 400),
    this.startDelay = Duration.zero,
    this.onComplete,
  });

  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration startDelay;
  final VoidCallback? onComplete;

  static Duration totalDuration(Duration duration, Duration startDelay) =>
      startDelay + duration;

  @override
  State<FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late bool _reduceMotion;

  // The text currently shown/being animated — deliberately separate from
  // widget.text so a mid-fade-out text change doesn't swap the label
  // before the fade-out has actually finished playing.
  late String _displayedText;

  @override
  void initState() {
    super.initState();
    _reduceMotion = SchedulerBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    _displayedText = widget.text;

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (_reduceMotion) {
      _controller.value = 1.0;
      widget.onComplete?.call();
      return;
    }

    _controller.addStatusListener(_onStatusChanged);

    Future.delayed(widget.startDelay, () {
      if (mounted) _controller.forward();
    });
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();
    }
  }

  @override
  void didUpdateWidget(covariant FadeInText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text == oldWidget.text) return;

    if (_reduceMotion) {
      // No animation either way — just swap the text immediately.
      setState(() => _displayedText = widget.text);
      return;
    }

    // Fade the old text out, then swap the string and fade the new one
    // in. reverse() runs 0.0<-1.0 using the same [duration], so the
    // out-fade and in-fade take equal time — one status listener handles
    // both halves rather than needing two separate controllers.
    _controller.reverse().then((_) {
      if (!mounted) return;
      setState(() => _displayedText = widget.text);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FadeTransition(
  //     opacity: _opacity,
  //     child: Text(_displayedText, style: widget.style),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        _displayedText,
        style: widget.style,
        maxLines: 2,
        overflow: TextOverflow
            .ellipsis, // truncates rather than overflowing a 3rd line
      ),
    );
  }
}
