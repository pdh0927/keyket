import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';

class HashTagItem extends ConsumerWidget {
  final RecommendRegion? region;
  final RecommendTheme? theme;

  const HashTagItem({
    super.key,
    this.region,
    this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        height: 35,
        width: 110, // 글자 최대수 생각해서 변경해야함
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: PRIMARY_COLOR,
            )),
        padding: const EdgeInsets.only(left: 12, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '# ${region != null ? recommendRegionKor[region!.index] : recommendThemeKor[theme!.index]}',
              style: const TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Remix.close_circle_line, size: 14),
              padding: EdgeInsets.zero,
              splashRadius: 15,
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              onPressed: () {
                if (region != null) {
                  ref
                      .read(selectedRegionFilterProvider.notifier)
                      .deleteHashTag();
                } else {
                  ref
                      .read(selectedThemeFilterListProvider.notifier)
                      .deleteHashTag(theme!);
                }
              },
            )
          ],
        ));
  }
}
