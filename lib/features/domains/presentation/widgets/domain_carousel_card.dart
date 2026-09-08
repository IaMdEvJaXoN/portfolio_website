import 'package:flutter/material.dart';
import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/theme/app_theme.dart';

class DomainCarouselCard extends StatelessWidget {
  const DomainCarouselCard({
    super.key,
    required this.domain,
    required this.onTap,
    this.parallax = 0.0,
  });

  final DomainEntity domain;
  final VoidCallback onTap;

  //-1..1: this card's offset from the centered page, supplied by the
  //PageView's AnimatedBuilder. Drives the background pan below —
  //clamped upstream so the image translation stays bounded regardless
  //of overscroll.
  final double parallax;

  //How far the background travels across the full -1..1 parallax range.
  //Kept modest so the image never pans past its oversized bounds.
  static const double _panExtentPx = 40.0;
  //Background is scaled up beyond the card so panning never exposes
  //an edge/gap — this is what makes the pan look continuous rather
  //than clipped.
  static const double _bgOverscale = 1.25;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (domain.carouselImageUrl.isNotEmpty)
                //Translate opposite to scroll direction: as the user
                //drags left (page increasing, parallax -> +1 for a card
                //moving off to the right of center), the background
                //shifts the other way, giving the "background pans
                //against the scroll" effect the spec asks for.
                Transform.translate(
                  offset: Offset(-parallax * _panExtentPx, 0),
                  child: Transform.scale(
                    scale: _bgOverscale,
                    child: Image.network(
                      domain.carouselImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              // Scrim so the title/description stay legible over any image.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.85),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        domain.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        domain.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
