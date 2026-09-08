import 'package:my_portfolio_web_app/features/domains/domain/repository/domains_repository.dart';
import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';

import 'package:my_portfolio_web_app/features/domains/data/datasource/domains_remote_datasource.dart';

class DomainsRepositoryImpl implements DomainsRepository {
  const DomainsRepositoryImpl(this._datasource);
  final DomainsRemoteDatasource _datasource;

  @override
  Future<List<DomainEntity>> getDomains() => _datasource.fetchDomains();
}
