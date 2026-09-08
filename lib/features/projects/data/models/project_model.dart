import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio_web_app/features/projects/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.domainId,
    required super.title,
    required super.shortSummary,
    required super.thumbnailUrl,
    required super.techStack,
    required super.repositoryUrl,
    required super.demoUrl,
    required super.caseStudyMarkdown,
  });

  factory ProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ProjectModel(
      id: doc.id,
      domainId: data['domain_id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      shortSummary: data['short_summary'] as String? ?? '',
      thumbnailUrl: data['thumbnail_url'] as String? ?? '',
      techStack: List<String>.from(data['tech_stack'] as List? ?? const []),
      repositoryUrl: data['repository_url'] as String? ?? '',
      demoUrl: data['demo_url'] as String? ?? '',
      caseStudyMarkdown: data['case_study_markdown'] as String? ?? '',
    );
  }
}
