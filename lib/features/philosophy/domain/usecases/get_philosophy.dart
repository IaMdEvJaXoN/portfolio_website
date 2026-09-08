import 'package:my_portfolio_web_app/features/philosophy/domain/entities/philosophy_entity.dart';
import 'package:my_portfolio_web_app/features/philosophy/domain/repository/philosophy_repository.dart';

class GetPhilosophy {
  const GetPhilosophy(this._repository);
  final PhilosophyRepository _repository;

  Future<PhilosophyEntity> call() => _repository.getPhilosophy();
}
