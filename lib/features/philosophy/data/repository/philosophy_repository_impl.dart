import 'package:my_portfolio_web_app/features/philosophy/domain/entities/philosophy_entity.dart';
import 'package:my_portfolio_web_app/features/philosophy/domain/repository/philosophy_repository.dart';
import 'package:my_portfolio_web_app/features/philosophy/data/datasource/philosophy_remote_datasource.dart';

class PhilosophyRepositoryImpl implements PhilosophyRepository {
  const PhilosophyRepositoryImpl(this._datasource);
  final PhilosophyRemoteDatasource _datasource;

  @override
  Future<PhilosophyEntity> getPhilosophy() => _datasource.fetchPhilosophy();
}
