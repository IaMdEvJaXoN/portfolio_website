import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_web_app/core/theme/app_theme.dart';

class MorphPage<T> extends CustomTransitionPage<T> {
  MorphPage({required super.child, required LocalKey super.key})
    : super(
        transitionDuration: AppTheme.motionDuration,
        reverseTransitionDuration: AppTheme.motionDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: AppTheme.motionCurve,
            reverseCurve: AppTheme.motionCurve.flipped,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      );
}

//Wrap the card (closed state) and the case-study header (open state)
//with this using the SAME [tag]. Handles the border-radius morph that
//a plain [Hero] can't do on its own.
class MorphHero extends StatelessWidget {
  const MorphHero({
    super.key,
    required this.tag,
    required this.child,
    this.borderRadius = AppTheme.radius,
  });

  final Object tag;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder:
          (flightContext, animation, direction, fromCtx, toCtx) {
            final isForward = direction == HeroFlightDirection.push;
            final beginRadius = isForward ? AppTheme.radius : 0.0;
            final endRadius = isForward ? 0.0 : AppTheme.radius;
            final radiusTween = Tween<double>(
              begin: beginRadius,
              end: endRadius,
            );
            final toWidget = toCtx.widget as Hero;
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) => ClipRRect(
                borderRadius: BorderRadius.circular(
                  radiusTween.evaluate(animation),
                ),
                child: isForward ? toWidget.child : toWidget.child,
              ),
            );
          },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
