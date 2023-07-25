import 'package:json_annotation/json_annotation.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';

part 'bucket_list_detail_model.g.dart';

@JsonSerializable()
class BucketListDetailModel extends BucketListModel {
  final List<String> completedCustomItemList;
  final List<String> completedrecommendItemList;
  final List<Map<String, dynamic>> customItemList;
  final List<RecommendItemModel> recommendItemList;

  BucketListDetailModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.achievementRate,
      required super.isShared,
      required super.users,
      required super.createdAt,
      required super.updatedAt,
      required this.completedCustomItemList,
      required this.completedrecommendItemList,
      required this.customItemList,
      required this.recommendItemList});

  factory BucketListDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BucketListDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BucketListDetailModelToJson(this);
}
