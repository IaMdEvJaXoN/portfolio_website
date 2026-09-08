import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/core/network/firestore_provider.dart';
import 'package:my_portfolio_web_app/features/skills/data/datasource/skills_remote_datasource.dart';
import 'package:my_portfolio_web_app/features/skills/data/repository/skills_repository_impl.dart';
import 'package:my_portfolio_web_app/features/skills/domain/entities/skill_category_entity.dart';
import 'package:my_portfolio_web_app/features/skills/domain/usecases/get_skill_categories.dart';

final _skillsDatasourceProvider = Provider((ref) {
  return SkillsRemoteDatasource(ref.watch(firestoreProvider));
});

final _skillsRepositoryProvider = Provider((ref) {
  return SkillsRepositoryImpl(ref.watch(_skillsDatasourceProvider));
});

final _getSkillCategoriesProvider = Provider((ref) {
  return GetSkillCategories(ref.watch(_skillsRepositoryProvider));
});

final skillCategoriesProvider = FutureProvider<List<SkillCategoryEntity>>((
  ref,
) {
  return ref.watch(_getSkillCategoriesProvider).call();
});
