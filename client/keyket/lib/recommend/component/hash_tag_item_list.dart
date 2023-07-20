import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/recommend/component/hash_tag_item.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

class HashTagItemList extends ConsumerWidget {
  const HashTagItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilterList = ref.watch(selectedFilterListProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: selectedFilterList.map((selectedItem) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: HashTagItem(
            type: selectedItem['type']!,
            value: selectedItem['value']!,
          ),
        );
      }).toList(),
    );
  }
}
