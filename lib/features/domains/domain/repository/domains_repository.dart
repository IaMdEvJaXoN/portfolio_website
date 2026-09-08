import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';

abstract class DomainsRepository {
  Future<List<DomainEntity>> getDomains();
}
