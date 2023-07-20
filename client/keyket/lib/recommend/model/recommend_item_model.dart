import 'package:json_annotation/json_annotation.dart';

part 'recommend_item_model.g.dart';

enum RecommendRegion {
  seoul,
  busan,
  daegu,
  gwanju,
  incheon,
  daejeon,
  ulsan,
  gyeonggi,
  gangwon,
  chungbuk,
  chungnam,
  jeonbuk,
  jeonnam,
  gyeongbuk,
  gyeongnam,
  jeju
}

enum RecommendTheme { healing, activity, festival, date, historyAndCulture }

@JsonSerializable()
class RecommendItemModel {
  final String id;
  final RecommendRegion region;
  final RecommendTheme theme;
  final String content;

  RecommendItemModel({
    required this.id,
    required this.region,
    required this.theme,
    required this.content,
  });

  factory RecommendItemModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendItemModelToJson(this);
}
