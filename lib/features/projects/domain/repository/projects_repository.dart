import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<List<ProjectEntity>> getProjectsByDomain(String domainId);
  Future<ProjectEntity?> getProjectById(String projectId);
}
