import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/features/domains/domain/entities/domain_entity.dart';
import 'package:my_portfolio_web_app/features/domains/domain/usecases/get_domains.dart';
import 'package:my_portfolio_web_app/core/network/firestore_provider.dart';
import 'package:my_portfolio_web_app/features/domains/data/datasource/domains_remote_datasource.dart';
import 'package:my_portfolio_web_app/features/domains/data/repository/domains_repository_impl.dart';

final _domainsDatasourceProvider = Provider((ref) {
  return DomainsRemoteDatasource(ref.watch(firestoreProvider));
});

final _domainsRepositoryProvider = Provider((ref) {
  return DomainsRepositoryImpl(ref.watch(_domainsDatasourceProvider));
});

final _getDomainsProvider = Provider((ref) {
  return GetDomains(ref.watch(_domainsRepositoryProvider));
});

//FutureProvider caches the result for the provider's lifetime —
//navigating away and back to the Projects tab (kept alive by
//StatefulShellRoute.indexedStack) does NOT refire the query.
final domainsListProvider = FutureProvider<List<DomainEntity>>((ref) {
  return ref.watch(_getDomainsProvider).call();
});
