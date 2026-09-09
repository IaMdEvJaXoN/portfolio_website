import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
//import 'package:my_portfolio_web_app/core/widgets/outlined_action_button.dart';
import 'package:my_portfolio_web_app/features/domains/presentation/providers/domains_providers.dart';
import 'package:my_portfolio_web_app/features/projects/presentation/providers/projects_providers.dart';
import 'package:my_portfolio_web_app/features/projects/presentation/widgets/project_card.dart';

class ProjectsGridScreen extends ConsumerWidget {
  const ProjectsGridScreen({super.key, required this.domainId});
  final String domainId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsByDomainProvider(domainId));
    //Reuses the domains list already fetched for Depth 1 — no new
    //Firestore read, just a lookup by id in cached data.
    final domainsAsync = ref.watch(domainsListProvider);

    return SafeArea(
      child: ConstrainedWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  // OutlinedActionButton(
                  //   label: 'Domains',
                  //   icon: Icons.arrow_back,
                  //   onTap: () => context.go('/projects'),
                  // ),
                  const SizedBox(width: 16),
                  domainsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (domains) {
                      final match = domains.where((d) => d.id == domainId);
                      final title = match.isEmpty
                          ? domainId
                          : match.first.title;
                      return Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    Center(child: Text('Failed to load projects: $err')),
                data: (projects) {
                  if (projects.isEmpty) {
                    return const Center(
                      child: Text('No projects in this domain yet.'),
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 1000
                          ? 3
                          : constraints.maxWidth >= 650
                          ? 2
                          : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () => context.go(
                              '/case-study/${project.id}',
                              extra: project,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
