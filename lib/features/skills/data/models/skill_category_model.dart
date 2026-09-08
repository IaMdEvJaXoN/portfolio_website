import 'package:my_portfolio_web_app/features/skills/domain/entities/skill_category_entity.dart';

class SkillCategoryModel extends SkillCategoryEntity {
  const SkillCategoryModel({required super.name, required super.skills});

  factory SkillCategoryModel.fromMap(Map<String, dynamic> map) {
    return SkillCategoryModel(
      name: map['name'] as String? ?? '',
      skills: List<String>.from(map['skills'] as List? ?? const []),
    );
  }
}
