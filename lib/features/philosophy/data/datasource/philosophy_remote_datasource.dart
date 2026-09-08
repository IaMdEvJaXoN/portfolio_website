import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/philosophy/data/models/philosophy_model.dart';

class PhilosophyRemoteDatasource {
  const PhilosophyRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  Future<PhilosophyModel> fetchPhilosophy() async {
    final doc = await _firestore.collection('philosophy').doc('main').get();
    return PhilosophyModel.fromFirestore(doc);
  }
}
