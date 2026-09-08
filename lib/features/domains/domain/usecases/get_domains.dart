import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';
import 'package:my_portfolio_web_app/features/domains/domain/repository/domains_repository.dart';

class GetDomains {
  const GetDomains(this._repository);
  final DomainsRepository _repository;

  Future<List<DomainEntity>> call() => _repository.getDomains();
}
