import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/projects/data/models/project_model.dart';

class ProjectsRemoteDatasource {
  const ProjectsRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  Future<List<ProjectModel>> fetchByDomain(String domainId) async {
    final snapshot = await _firestore
        .collection('projects')
        .where('domain_id', isEqualTo: domainId)
        .get();
    return snapshot.docs.map(ProjectModel.fromFirestore).toList();
  }

  Future<ProjectModel?> fetchById(String projectId) async {
    final doc = await _firestore.collection('projects').doc(projectId).get();
    if (!doc.exists) return null;
    return ProjectModel.fromFirestore(doc);
  }
}
