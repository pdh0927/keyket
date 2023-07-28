import 'package:json_annotation/json_annotation.dart';

part 'bucket_list_model.g.dart';

@JsonSerializable()
class BucketListModel {
  final String id;
  final String name;
  final String image;
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
    required this.isShared,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.completedCustomItemList,
    required this.completedRecommendItemList,
    required this.customItemList,
    required this.recommendItemList,
  });
  BucketListModel deepCopy() {
    return BucketListModel(
      id: id,
      name: name,
      image: image,
      isShared: isShared,
      users: List.from(users),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(createdAt.millisecondsSinceEpoch),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(updatedAt.millisecondsSinceEpoch),
      completedCustomItemList: List.from(completedCustomItemList),
      completedRecommendItemList: List.from(completedRecommendItemList),
      customItemList: List.from(customItemList),
      recommendItemList: List.from(recommendItemList),
    );
  }

  BucketListModel copyWith({
    String? id,
    String? name,
    String? image,
    double? achievementRate,
    bool? isShared,
    List<String>? users,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? completedCustomItemList,
    List<String>? completedRecommendItemList,
    List<String>? customItemList,
    List<String>? recommendItemList,
  }) {
    return BucketListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isShared: isShared ?? this.isShared,
      users: users != null ? List.from(users) : this.users,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedCustomItemList: completedCustomItemList != null
          ? List.from(completedCustomItemList)
          : this.completedCustomItemList,
      completedRecommendItemList: completedRecommendItemList != null
          ? List.from(completedRecommendItemList)
          : this.completedRecommendItemList,
      customItemList: customItemList != null
          ? List.from(customItemList)
          : this.customItemList,
      recommendItemList: recommendItemList != null
          ? List.from(recommendItemList)
          : this.recommendItemList,
    );
  }

  factory BucketListModel.fromJson(Map<String, dynamic> json) =>
      _$BucketListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketListModelToJson(this);
}
