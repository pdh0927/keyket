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
  final List<String> uncompletedCustomItemList;
  final List<String> uncompletedRecommendItemList;
  final List<String> completedCustomItemList;
  final List<String> completedRecommendItemList;

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
    required this.uncompletedCustomItemList,
    required this.uncompletedRecommendItemList,
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
      uncompletedCustomItemList: List.from(uncompletedCustomItemList),
      uncompletedRecommendItemList: List.from(uncompletedRecommendItemList),
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
      uncompletedCustomItemList: customItemList != null
          ? List.from(uncompletedCustomItemList)
          : this.uncompletedCustomItemList,
      uncompletedRecommendItemList: recommendItemList != null
          ? List.from(uncompletedRecommendItemList)
          : this.uncompletedRecommendItemList,
    );
  }

  @override
  String toString() {
    return 'BucketListModel {'
        'id: $id, '
        'name: $name, '
        'image: $image, '
        'isShared: $isShared, '
        'users: $users, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'completedCustomItemList: $completedCustomItemList, '
        'completedRecommendItemList: $completedRecommendItemList, '
        'customItemList: $uncompletedCustomItemList, '
        'recommendItemList: $uncompletedRecommendItemList'
        '}';
  }

  factory BucketListModel.fromJson(Map<String, dynamic> json) =>
      _$BucketListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketListModelToJson(this);
}
