import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/philosophy/domain/entities/philosophy_entity.dart';

class PhilosophyModel extends PhilosophyEntity {
  const PhilosophyModel({required super.contentMarkdown});

  factory PhilosophyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const {};
    return PhilosophyModel(
      contentMarkdown: data['content_markdown'] as String? ?? '',
    );
  }
}
