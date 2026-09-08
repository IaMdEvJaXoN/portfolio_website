import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.characterDuration = const Duration(milliseconds: 140),
    this.showCursor = true,
    this.startDelay = Duration.zero,
    this.onComplete,
  });

  final String text;
  final TextStyle? style;
  final Duration characterDuration;
  final bool showCursor;
  final Duration startDelay;

  //Fired once typing finishes — lets a parent chain the next animation
  //without having to independently recompute this widget's duration.
  final VoidCallback? onComplete;

  //Total wall-clock time this widget will take, INCLUDING startDelay.
  //Exposed so a parent sequencing multiple animations can compute the
  //next widget's startDelay without duplicating the character-count math.
  static Duration totalDuration(
    String text,
    Duration characterDuration,
    Duration startDelay,
  ) {
    return startDelay + characterDuration * text.characters.length;
  }

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late final AnimationController _typeController;
  AnimationController? _cursorController;
  late final bool _reduceMotion;

  @override
  void initState() {
    super.initState();
    _reduceMotion = SchedulerBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;

    final charCount = widget.text.characters.length;
    _typeController = AnimationController(
      vsync: this,
      duration: widget.characterDuration * charCount,
    );

    if (_reduceMotion) {
      //Skip straight to the end — no delay, no cursor, no motion.
      _typeController.value = 1.0;
      widget.onComplete?.call();
      return;
    }

    if (widget.showCursor) {
      _cursorController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat(reverse: true);
      _typeController.addStatusListener(_onTypeStatusChanged);
    }

    //Delay the actual start rather than delaying the whole widget's
    //build — the widget (and an empty-text cursor, if shown) is still
    //present in the tree during the delay, it just hasn't started
    //consuming characters yet.
    Future.delayed(widget.startDelay, () {
      if (mounted) _typeController.forward();
    });

    if (!widget.showCursor) {
      _typeController.addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete?.call();
      });
    }
  }

  void _onTypeStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _cursorController?.dispose();
      setState(() => _cursorController = null);
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _typeController.removeStatusListener(_onTypeStatusChanged);
    _typeController.dispose();
    _cursorController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charCount = widget.text.characters.length;

    return AnimatedBuilder(
      animation: Listenable.merge([_typeController, _cursorController]),
      builder: (context, _) {
        final visibleCount = (_typeController.value * charCount).floor();
        final visibleText = widget.text.characters
            .take(visibleCount)
            .toString();

        final cursorVisible =
            _cursorController != null && _cursorController!.value > 0.5;

        return RichText(
          text: TextSpan(
            style: widget.style,
            children: [
              TextSpan(text: visibleText),
              if (_cursorController != null)
                TextSpan(text: cursorVisible ? '|' : ' ', style: widget.style),
            ],
          ),
        );
      },
    );
  }
}
