import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';

part 'recommend_item_model.g.dart';

enum RecommendRegion {
  seoul,
  busan,
  daegu,
  pohang,
  gyeongju,
  jeju,
}

enum RecommendTheme { healing, activity, festival, date, hist, food }

List<String> recommendRegionKor = ['서울', '부산', '대구', '포항', '경주', '제주'];

List<String> recommendThemeKor = ['힐링', '엑티비티', '축제', '데이트', '역사/문화', '먹거리'];

@JsonSerializable()
class RecommendItemModel extends ItemModel {
  final RecommendRegion region;
  final List<RecommendTheme> theme;

  RecommendItemModel({
    required super.id,
    required this.region,
    required this.theme,
    required super.content,
  });

  factory RecommendItemModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendItemModelToJson(this);

  RecommendItemModel deepCopy() {
    return RecommendItemModel(
      id: id,
      region: region,
      theme: [...theme],
      content: content,
    );
  }

  @override
  String toString() {
    return 'RecommendItemModel: {id: $id, region: $region, theme: $theme, content: $content}';
  }

  // remove method에서 class객체 삭제를 위해 구현
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecommendItemModel &&
        other.id == id &&
        other.region == region &&
        listEquals(other.theme, theme) &&
        other.content == content;
  }

  @override
  int get hashCode =>
      id.hashCode ^ region.hashCode ^ theme.hashCode ^ content.hashCode;
}

class RecommendItems {
  List<RecommendItemModel> completeItems;
  List<RecommendItemModel> uncompleteItems;

  RecommendItems deepCopy() {
    return RecommendItems(
      completeItems: completeItems.map((item) => item.deepCopy()).toList(),
      uncompleteItems: uncompleteItems.map((item) => item.deepCopy()).toList(),
    );
  }

  RecommendItems(
      {this.completeItems = const [], this.uncompleteItems = const []});
}
