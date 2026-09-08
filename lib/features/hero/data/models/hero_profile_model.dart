import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';

class HeroProfileModel extends HeroProfileEntity {
  const HeroProfileModel({
    required super.name,
    required super.title,
    required super.mantra,
    required super.avatarUrl,
    required super.email,
    required super.linkedinUrl,
    required super.whatsappUrl,
  });

  factory HeroProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const {};
    return HeroProfileModel(
      name: data['name'] as String? ?? '',
      title: data['title'] as String? ?? '',
      mantra: data['mantra'] as String? ?? '',
      avatarUrl: data['avatar_url'] as String? ?? '',
      email: data['email'] as String? ?? '',
      linkedinUrl: data['linkedin_url'] as String? ?? '',
      whatsappUrl: data['whatsapp_url'] as String? ?? '',
    );
  }
}
