import 'package:my_portfolio_web_app/features/skills/domain/entities/skill_category_entity.dart';

abstract class SkillsRepository {
  Future<List<SkillCategoryEntity>> getSkillCategories();
}
