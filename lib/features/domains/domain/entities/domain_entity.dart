class DomainEntity {
  const DomainEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.carouselImageUrl,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String description;
  final String carouselImageUrl;
  final int sortOrder;
}
