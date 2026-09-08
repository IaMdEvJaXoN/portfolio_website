import 'package:flutter/material.dart';
import 'package:my_portfolio_web_app/core/router/morph_route_transition.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/theme/app_theme.dart';
import 'package:my_portfolio_web_app/core/widgets/accent_border_chip.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});
  final ProjectEntity project;
  final VoidCallback onTap;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        // MorphHero tag matches the tag used on CaseStudyScreen's header —
        // this is what drives the card -> full-screen shape morph.
        child: MorphHero(
          tag: 'project-${widget.project.id}',
          child: AnimatedContainer(
            duration: AppTheme.motionDuration,
            curve: AppTheme.motionCurve,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color: _hovered ? AppColors.accent : AppColors.border,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppColors.background,
                    child: widget.project.thumbnailUrl.isNotEmpty
                        ? Image.network(
                            widget.project.thumbnailUrl,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.project.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.project.shortSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.project.techStack
                      .take(3)
                      .map((t) => AccentBorderChip(label: t))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
