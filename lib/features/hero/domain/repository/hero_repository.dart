import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';

abstract class HeroRepository {
  Future<HeroProfileEntity> getProfile();
}
