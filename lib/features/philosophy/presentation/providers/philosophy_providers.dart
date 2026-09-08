import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/core/network/firestore_provider.dart';
import 'package:my_portfolio_web_app/features/philosophy/data/datasource/philosophy_remote_datasource.dart';
import 'package:my_portfolio_web_app/features/philosophy/data/repository/philosophy_repository_impl.dart';
import 'package:my_portfolio_web_app/features/philosophy/domain/entities/philosophy_entity.dart';
import 'package:my_portfolio_web_app/features/philosophy/domain/usecases/get_philosophy.dart';

final _philosophyDatasourceProvider = Provider((ref) {
  return PhilosophyRemoteDatasource(ref.watch(firestoreProvider));
});

final _philosophyRepositoryProvider = Provider((ref) {
  return PhilosophyRepositoryImpl(ref.watch(_philosophyDatasourceProvider));
});

final _getPhilosophyProvider = Provider((ref) {
  return GetPhilosophy(ref.watch(_philosophyRepositoryProvider));
});

final philosophyProvider = FutureProvider<PhilosophyEntity>((ref) {
  return ref.watch(_getPhilosophyProvider).call();
});
