import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';

class DomainModel extends DomainEntity {
  const DomainModel({
    required super.id,
    required super.title,
    required super.description,
    required super.carouselImageUrl,
    required super.sortOrder,
  });

  factory DomainModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return DomainModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      carouselImageUrl: data['carousel_image_url'] as String? ?? '',
      sortOrder: (data['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}
