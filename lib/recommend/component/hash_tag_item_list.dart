import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/recommend/component/hash_tag_item.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

class HashTagItemList extends ConsumerWidget {
  const HashTagItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegionFilter = ref.watch(selectedRegionFilterProvider);
    final selectedThemeFilterList = ref.watch(selectedThemeFilterListProvider);

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getChilds(selectedRegionFilter, selectedThemeFilterList));
  }

  List<Container> getChilds(RecommendRegion? selectedRegionFilter,
      List<RecommendTheme> selectedThemeFilterList) {
    List<Container> childs = [];

    if (selectedRegionFilter != null) {
      childs.add(Container(
        margin: const EdgeInsets.only(right: 8),
        child: HashTagItem(
          region: selectedRegionFilter,
          canSelect: true,
        ),
      ));
    }

    for (var theme in selectedThemeFilterList) {
      childs.add(Container(
        margin: const EdgeInsets.only(right: 8),
        child: HashTagItem(
          theme: theme,
          canSelect: true,
        ),
      ));
    }
    return childs;
  }
}
