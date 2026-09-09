import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_web_app/core/widgets/app_shell.dart';
import 'package:my_portfolio_web_app/features/domains/presentation/screens/domains_corousel_screen.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/screens/hero_screen.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';
import 'package:my_portfolio_web_app/features/projects/presentation/screens/projects_grid_screen.dart';
import 'package:my_portfolio_web_app/features/projects/presentation/screens/case_study_screen.dart';
import 'package:my_portfolio_web_app/features/skills/presentation/screens/skills_screen.dart';
import 'package:my_portfolio_web_app/features/philosophy/presentation/screens/philosophy_screen.dart';
import 'package:my_portfolio_web_app/core/router/morph_route_transition.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
//final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Manual provider exposing the configured router.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (c, s) => const HeroScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (c, s) => const DomainsCarouselScreen(),
                routes: [
                  GoRoute(
                    path: ':domainId', // Depth 2
                    builder: (c, s) => ProjectsGridScreen(
                      domainId: s.pathParameters['domainId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/skills', builder: (c, s) => const SkillsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/philosophy',
                builder: (c, s) => const PhilosophyScreen(),
              ),
            ],
          ),
        ],
      ),
      //Depth 3 — deliberately OUTSIDE the shell tree, using the root
      //navigator, so it renders full-screen over the shell
      //as specified. `extra` carries the already-fetched
      //ProjectEntity to skip a redundant Firestore read; CaseStudyScreen
      //falls back to fetching by id if this is a direct deep link.
      GoRoute(
        path: '/case-study/:projectId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final project = extra is ProjectEntity ? extra : null;
          return MorphPage(
            key: state.pageKey,
            child: CaseStudyScreen(
              projectId: state.pathParameters['projectId']!,
              preloaded: project,
            ),
          );
        },
      ),
    ],
  );
});
