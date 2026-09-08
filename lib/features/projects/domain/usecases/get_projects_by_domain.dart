import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';
import 'package:my_portfolio_web_app/features/projects/domain/repository/projects_repository.dart';

class GetProjectsByDomain {
  const GetProjectsByDomain(this._repository);
  final ProjectsRepository _repository;

  Future<List<ProjectEntity>> call(String domainId) =>
      _repository.getProjectsByDomain(domainId);
}
