import 'package:json_annotation/json_annotation.dart';

part 'custom_item_model.g.dart';

@JsonSerializable()
class CustomItemModel extends ItemModel {
  CustomItemModel({required super.id, required super.content});

  factory CustomItemModel.fromJson(Map<String, dynamic> json) =>
      _$CustomItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomItemModelToJson(this);

  CustomItemModel copyWith({
    String? id,
    String? content,
  }) {
    return CustomItemModel(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  @override
  String toString() {
    return 'CustomItemModel: {id: $id, content: $content}';
  }

  CustomItemModel deepCopy() {
    return CustomItemModel(
      id: id,
      content: content,
    );
  }
}

class CustomItems {
  final List<CustomItemModel> completeItems;
  final List<CustomItemModel> uncompleteItems;

  CustomItems deepCopy() {
    return CustomItems(
      completeItems: completeItems.map((item) => item.deepCopy()).toList(),
      uncompleteItems: uncompleteItems.map((item) => item.deepCopy()).toList(),
    );
  }

  CustomItems({required this.completeItems, required this.uncompleteItems});
}

abstract class ItemModel {
  final String id;
  final String content;

  ItemModel({required this.id, required this.content});
}
