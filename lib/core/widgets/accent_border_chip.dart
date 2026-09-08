import 'package:flutter/material.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/theme/app_theme.dart';
import 'package:my_portfolio_web_app/core/theme/app_typography.dart';

//Skills chips and Project tech-stack tags.
class AccentBorderChip extends StatefulWidget {
  const AccentBorderChip({super.key, required this.label});
  final String label;

  @override
  State<AccentBorderChip> createState() => _AccentBorderChipState();
}

class _AccentBorderChipState extends State<AccentBorderChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppTheme.motionDuration,
        curve: AppTheme.motionCurve,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(
            color: _hovered ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(widget.label, style: AppTypography.monoSmall),
      ),
    );
  }
}
