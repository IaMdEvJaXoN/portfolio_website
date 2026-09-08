import 'package:my_portfolio_web_app/features/philosophy/domain/entities/philosophy_entity.dart';

abstract class PhilosophyRepository {
  Future<PhilosophyEntity> getPhilosophy();
}
