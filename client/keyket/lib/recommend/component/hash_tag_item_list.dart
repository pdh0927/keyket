import 'package:flutter/material.dart';
import 'package:keyket/recommend/component/hash_tag_item.dart';

class HashTagItemList extends StatelessWidget {
  final List<Map<String, String>> selectedList;
  final void Function(String, String) deleteHashTag;

  const HashTagItemList({
    required this.selectedList,
    required this.deleteHashTag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: selectedList.map((selectedItem) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: HashTagItem(
            type: selectedItem['type']!,
            value: selectedItem['value']!,
            deleteHashTag: deleteHashTag,
          ),
        );
      }).toList(),
    );
  }
}
