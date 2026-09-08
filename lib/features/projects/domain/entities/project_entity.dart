class ProjectEntity {
  const ProjectEntity({
    required this.id,
    required this.domainId,
    required this.title,
    required this.shortSummary,
    required this.thumbnailUrl,
    required this.techStack,
    required this.repositoryUrl,
    required this.demoUrl,
    required this.caseStudyMarkdown,
  });

  final String id;
  final String domainId;
  final String title;
  final String shortSummary;
  final String thumbnailUrl;
  final List<String> techStack;
  final String repositoryUrl;
  final String demoUrl; // empty string => UI omits the button entirely
  final String caseStudyMarkdown;
}
