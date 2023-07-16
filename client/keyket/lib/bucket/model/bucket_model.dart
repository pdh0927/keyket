class BucketModel {
  final int id;
  final String name;
  final String image;
  final double achievement_rate;
  final DateTime created_at;
  final DateTime updated_at;

  BucketModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.achievement_rate,
      required this.created_at,
      required this.updated_at});
}
