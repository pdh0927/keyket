import 'package:json_annotation/json_annotation.dart';

part 'bucket_model.g.dart';

@JsonSerializable()
class BucketModel {
  final int id;
  final String name;
  final String image;
  final double achievementRate;
  final bool isShared;
  final List<String> users;
  final DateTime createdAt;
  final DateTime updatedAt;

  BucketModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.achievementRate,
      required this.isShared,
      required this.users,
      required this.createdAt,
      required this.updatedAt});

  factory BucketModel.fromJson(Map<String, dynamic> json) =>
      _$BucketModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketModelToJson(this);
}
