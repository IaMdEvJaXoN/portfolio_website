import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';
import 'package:my_portfolio_web_app/features/hero/domain/repository/hero_repository.dart';
import 'package:my_portfolio_web_app/features/hero/data/datasource/hero_remote_datasource.dart';

class HeroRepositoryImpl implements HeroRepository {
  const HeroRepositoryImpl(this._datasource);
  final HeroRemoteDatasource _datasource;

  @override
  Future<HeroProfileEntity> getProfile() => _datasource.fetchProfile();
}
