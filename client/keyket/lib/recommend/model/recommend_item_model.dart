import 'package:json_annotation/json_annotation.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';

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

enum RecommendTheme { healing, activity, festival, date, hist, food }

List<String> recommendRegionKor = [
  '서울',
  '부산',
  '대구',
  '광주',
  '인천',
  '대전',
  '울산',
  '경기',
  '강원',
  '충북',
  '충남',
  '전북',
  '전남',
  '경북',
  '경남',
  '제주'
];

List<String> recommendThemeKor = ['힐링', '엑티비티', '축제', '데이트', '역사/문화', '먹거리'];

@JsonSerializable()
class RecommendItemModel extends Item {
  final String id;
  final RecommendRegion region;
  final List<RecommendTheme> theme;
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
