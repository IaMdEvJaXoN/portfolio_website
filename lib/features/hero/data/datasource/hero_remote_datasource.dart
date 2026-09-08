import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hero_profile_model.dart';

class HeroRemoteDatasource {
  const HeroRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  /// Single doc .get() — one read total for the entire Hero tab,
  /// no listener kept open.
  Future<HeroProfileModel> fetchProfile() async {
    final doc = await _firestore.collection('profile').doc('main').get();
    return HeroProfileModel.fromFirestore(doc);
  }
}
