import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio_web_app/core/router/morph_route_transition.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
import 'package:my_portfolio_web_app/core/widgets/outlined_action_button.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';
import 'package:my_portfolio_web_app/features/projects/presentation/providers/projects_providers.dart';

//Depth 3. comes from go_router's `extra` on the normal
//grid -> case-study path (zero extra reads). If null — i.e. someone
//opened this URL directly — falls back to 'projectByIdProvider',
//a single doc .get().
class CaseStudyScreen extends ConsumerWidget {
  const CaseStudyScreen({super.key, required this.projectId, this.preloaded});

  final String projectId;
  final ProjectEntity? preloaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (preloaded != null) {
      return _CaseStudyBody(project: preloaded!);
    }
    final asyncProject = ref.watch(projectByIdProvider(projectId));
    return asyncProject.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Failed to load project: $e')),
      ),
      data: (project) {
        if (project == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Project not found.')),
          );
        }
        return _CaseStudyBody(project: project);
      },
    );
  }
}

class _CaseStudyBody extends StatelessWidget {
  const _CaseStudyBody({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedWidth(
                maxWidth: 900,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Same tag as ProjectCard — completes the morph flight.
                      MorphHero(
                        tag: 'project-${project.id}',
                        borderRadius: 0,
                        child: Container(
                          height: 320,
                          width: double.infinity,
                          color: AppColors.surface,
                          child: project.thumbnailUrl.isNotEmpty
                              ? Image.network(
                                  project.thumbnailUrl,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        project.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          OutlinedActionButton(
                            label: 'Repository',
                            icon: Icons.code,
                            onTap: () =>
                                launchUrl(Uri.parse(project.repositoryUrl)),
                          ),
                          if (project.demoUrl.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            OutlinedActionButton(
                              label: 'Live Demo',
                              icon: Icons.open_in_new,
                              onTap: () =>
                                  launchUrl(Uri.parse(project.demoUrl)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 32),
                      MarkdownBody(
                        data: project.caseStudyMarkdown,
                        styleSheet: MarkdownStyleSheet(
                          p: Theme.of(context).textTheme.bodyLarge,
                          h2: Theme.of(context).textTheme.headlineMedium,
                          blockquoteDecoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: AppColors.accent,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 16,
            //   left: 16,
            //   child: OutlinedActionButton(
            //     label: 'Back',
            //     icon: Icons.arrow_back,
            //     onTap: () => context.pop(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
