import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:remixicon/remixicon.dart';

class BucketListDetailScreen extends ConsumerWidget {
  final String bucketListId;
  final List<String> customItemList;
  final List<String> recommendItemList;

  const BucketListDetailScreen(
      {super.key,
      required this.bucketListId,
      required this.customItemList,
      required this.recommendItemList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .read(bucketListItemListProvider.notifier)
        .getItems(bucketListId, customItemList, recommendItemList);
    final bucketListItemList =
        ref.watch(bucketListItemListProvider)[bucketListId];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height / 7), // here the desired height
        child: AppBar(
          backgroundColor: const Color(0xFFC4E4FA),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Handle menu button
              },
            ),
          ],
          flexibleSpace: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'title',
                style: TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomProgressBar(achievementRate: 0.3, height: 17, width: 180)
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: bucketListItemList != null
            ? ListView.builder(
                itemCount: bucketListItemList.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 25);
                  } else if (index == bucketListItemList.length + 1) {
                    // custom item 생성 버튼
                    return Container(
                      height: 80,
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Remix.add_line,
                          color: PRIMARY_COLOR,
                          size: 35,
                        ),
                      ),
                    );
                  } else {
                    final item = bucketListItemList[index - 1];
                    final type = item.runtimeType == RecommendItemModel
                        ? 'recommend'
                        : 'custom';
                    final bool isContain = ref
                        .read(myBucketListListProvider.notifier)
                        .isComplete(type, bucketListId, item.id);
                    return ListItem(
                      // 추천 아이템
                      selectFlag: true,
                      isContain: isContain,
                      onPressed: () {
                        if (isContain) {
                          ref
                              .read(myBucketListListProvider.notifier)
                              .removeComplete(type, bucketListId, item.id);
                        } else {
                          ref
                              .read(myBucketListListProvider.notifier)
                              .addComplete(type, bucketListId, item.id);
                        }
                      },
                      content: bucketListItemList[index - 1].content,
                    );
                  }
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
