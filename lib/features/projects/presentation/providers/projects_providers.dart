import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/features/projects/data/datasource/projects_remotes_datasource.dart';
import 'package:my_portfolio_web_app/features/projects/data/repository/projects_repository.dart';
import 'package:my_portfolio_web_app/core/network/firestore_provider.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';

final _projectsDatasourceProvider = Provider((ref) {
  return ProjectsRemoteDatasource(ref.watch(firestoreProvider));
});

final projectsRepositoryProvider = Provider((ref) {
  return ProjectsRepositoryImpl(ref.watch(_projectsDatasourceProvider));
});

//.family caches per domainId — switching between two already-visited
//domains in the carousel costs zero extra reads.
final projectsByDomainProvider =
    FutureProvider.family<List<ProjectEntity>, String>((ref, domainId) {
      return ref
          .watch(projectsRepositoryProvider)
          .getProjectsByDomain(domainId);
    });

//Only used as a deep-link fallback — normal
//in-app navigation passes the entity via go_router 'extra' instead.
final projectByIdProvider = FutureProvider.family<ProjectEntity?, String>((
  ref,
  projectId,
) {
  return ref.watch(projectsRepositoryProvider).getProjectById(projectId);
});
