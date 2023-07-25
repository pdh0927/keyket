import 'package:json_annotation/json_annotation.dart';

part 'bucket_list_model.g.dart';

@JsonSerializable()
class BucketListModel {
  final String id;
  final String name;
  final String image;
  final double achievementRate;
  final bool isShared;
  final List<String> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> completedCustomItemList;
  final List<String> completedRecommendItemList;
  final List<String> customItemList;
  final List<String> recommendItemList;

  BucketListModel({
    required this.id,
    required this.name,
    required this.image,
    required this.achievementRate,
    required this.isShared,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.completedCustomItemList,
    required this.completedRecommendItemList,
    required this.customItemList,
    required this.recommendItemList,
  });

  factory BucketListModel.fromJson(Map<String, dynamic> json) =>
      _$BucketListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketListModelToJson(this);
}
