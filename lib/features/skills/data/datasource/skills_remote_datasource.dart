import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/skill_category_model.dart';

class SkillsRemoteDatasource {
  const SkillsRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  /// Single doc .get() — the whole skills list is one small document,
  /// not a per-category collection, since categories are never queried
  /// or filtered individually.
  Future<List<SkillCategoryModel>> fetchCategories() async {
    final doc = await _firestore.collection('skills').doc('main').get();
    final data = doc.data();
    if (data == null) return const [];
    final raw = List<Map<String, dynamic>>.from(
      (data['categories'] as List? ?? const []).map(
        (e) => Map<String, dynamic>.from(e as Map),
      ),
    );
    return raw.map(SkillCategoryModel.fromMap).toList();
  }
}
