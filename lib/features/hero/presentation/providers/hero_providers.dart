import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/core/network/firestore_provider.dart';
import 'package:my_portfolio_web_app/features/hero/data/datasource/hero_remote_datasource.dart';
import 'package:my_portfolio_web_app/features/hero/data/repository/hero_repository_impl.dart';
import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';
import 'package:my_portfolio_web_app/features/hero/domain/usecases/get_hero_profile.dart';

final _heroDatasourceProvider = Provider((ref) {
  return HeroRemoteDatasource(ref.watch(firestoreProvider));
});

final _heroRepositoryProvider = Provider((ref) {
  return HeroRepositoryImpl(ref.watch(_heroDatasourceProvider));
});

final _getHeroProfileProvider = Provider((ref) {
  return GetHeroProfile(ref.watch(_heroRepositoryProvider));
});

/// Cached for the provider's lifetime — StatefulShellRoute keeps the
/// Hero branch alive, so switching tabs and back never refetches.
final heroProfileProvider = FutureProvider<HeroProfileEntity>((ref) {
  return ref.watch(_getHeroProfileProvider).call();
});
