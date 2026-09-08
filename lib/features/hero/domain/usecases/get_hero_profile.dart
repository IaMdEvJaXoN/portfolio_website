import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';
import 'package:my_portfolio_web_app/features/hero/domain/repository/hero_repository.dart';

class GetHeroProfile {
  const GetHeroProfile(this._repository);
  final HeroRepository _repository;

  Future<HeroProfileEntity> call() => _repository.getProfile();
}
