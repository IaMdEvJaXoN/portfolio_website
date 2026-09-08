import 'package:my_portfolio_web_app/features/skills/domain/entities/skill_category_entity.dart';
import 'package:my_portfolio_web_app/features/skills/domain/repository/skills_repository.dart';

class GetSkillCategories {
  const GetSkillCategories(this._repository);
  final SkillsRepository _repository;

  Future<List<SkillCategoryEntity>> call() => _repository.getSkillCategories();
}
