import 'package:json_annotation/json_annotation.dart';

part 'bucket_list_model.g.dart';

@JsonSerializable()
class BucketListModel {
  final int id;
  final String name;
  final String image;
  final double achievementRate;
  final bool isShared;
  final List<String> users;
  final DateTime createdAt;
  final DateTime updatedAt;

  BucketListModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.achievementRate,
      required this.isShared,
      required this.users,
      required this.createdAt,
      required this.updatedAt});

  factory BucketListModel.fromJson(Map<String, dynamic> json) =>
      _$BucketListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketListModelToJson(this);
}