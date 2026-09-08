class HeroProfileEntity {
  const HeroProfileEntity({
    required this.name,
    required this.title,
    required this.mantra,
    required this.avatarUrl,
    required this.email,
    required this.linkedinUrl,
    required this.whatsappUrl,
  });

  final String name;
  final String title;
  final String mantra;
  final String avatarUrl; // empty string => UI falls back to a placeholder
  final String email;
  final String linkedinUrl;
  final String whatsappUrl;
}
