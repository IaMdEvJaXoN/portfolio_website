import 'package:my_portfolio_web_app/features/skills/domain/entities/skill_category_entity.dart';
import 'package:my_portfolio_web_app/features/skills/domain/repository/skills_repository.dart';
import 'package:my_portfolio_web_app/features/skills/data/datasource/skills_remote_datasource.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  const SkillsRepositoryImpl(this._datasource);
  final SkillsRemoteDatasource _datasource;

  @override
  Future<List<SkillCategoryEntity>> getSkillCategories() =>
      _datasource.fetchCategories();
}
