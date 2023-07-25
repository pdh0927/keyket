import 'package:json_annotation/json_annotation.dart';

part 'custom_item_model.g.dart';

@JsonSerializable()
class CustomItemModel extends Item {
  final String id;
  final String content;

  CustomItemModel({required this.id, required this.content});

  factory CustomItemModel.fromJson(Map<String, dynamic> json) =>
      _$CustomItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomItemModelToJson(this);
}

abstract class Item {}
