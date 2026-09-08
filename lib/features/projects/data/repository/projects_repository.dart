import 'package:my_portfolio_web_app/features/projects/data/datasource/projects_remotes_datasource.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';
import 'package:my_portfolio_web_app/features/projects/domain/repository/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  const ProjectsRepositoryImpl(this._datasource);
  final ProjectsRemoteDatasource _datasource;

  @override
  Future<List<ProjectEntity>> getProjectsByDomain(String domainId) =>
      _datasource.fetchByDomain(domainId);

  @override
  Future<ProjectEntity?> getProjectById(String projectId) =>
      _datasource.fetchById(projectId);
}
