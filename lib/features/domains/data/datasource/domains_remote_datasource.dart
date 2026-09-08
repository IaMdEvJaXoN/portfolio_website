import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/domains/data/models/domain_model.dart';

class DomainsRemoteDatasource {
  final FirebaseFirestore _firestore;
  const DomainsRemoteDatasource(this._firestore);

  //Single .get() future — no realtime listener, per Spark-plan
  //cost constraint. Domains list changes rarely; a live stream
  //would burn reads for no UX benefit.
  Future<List<DomainModel>> fetchDomains() async {
    final snapshot = await _firestore
        .collection('domains')
        .orderBy('sort_order')
        .get();
    return snapshot.docs.map(DomainModel.fromFirestore).toList();
    //snapshot--list<QuerySnapshot>
  }
}
