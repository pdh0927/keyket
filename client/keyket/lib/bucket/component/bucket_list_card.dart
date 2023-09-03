import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/view/bucket_list_detail_screen.dart';
import 'package:keyket/common/const/colors.dart';

import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';

class BucketListCard extends ConsumerWidget {
  final String id;
  final String name;
  final Image image;
  final String host;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> completedCustomItemList;
  final List<String> completedRecommendItemList;
  final List<String> uncompletedcustomItemList;
  final List<String> uncompletedrecommendItemList;
  final bool isShared;

  const BucketListCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.host,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
    required this.completedCustomItemList,
    required this.completedRecommendItemList,
    required this.uncompletedcustomItemList,
    required this.uncompletedrecommendItemList,
  });

  factory BucketListCard.fromModel({required BucketListModel model}) {
    return BucketListCard(
      id: model.id,
      name: model.name,
      image: model.image == ''
          ? Image.asset(
              width: 100,
              height: 100,
              "asset/img/default_bucket.png",
              fit: BoxFit.cover)
          : Image.network(
              width: 100, height: 100, model.image, fit: BoxFit.cover),
      host: model.host,
      isShared: model.isShared,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      completedCustomItemList: model.completedCustomItemList,
      completedRecommendItemList: model.completedRecommendItemList,
      uncompletedcustomItemList: model.uncompletedCustomItemList,
      uncompletedrecommendItemList: model.uncompletedRecommendItemList,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BucketListDetailScreen(
                      bucketListId: id,
                      isShared: isShared,
                    )));
          },
          child: IntrinsicHeight(
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(5.0), child: image),
              const SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Remix.arrow_right_s_line),
                      Text(
                        name,
                        style: popupMenuTextStlye,
                      )
                    ],
                  ),
                  CustomProgressBar(
                    achievementRate: getAchievementRate(),
                    height: 17,
                    width: 160,
                  ),
                  Text(
                    '최근 수정 : ${updatedAt.year.toString().substring(2)}.${updatedAt.month.toString().padLeft(2, '0')}.${updatedAt.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        fontFamily: 'SCDream',
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  )
                ],
              )
            ]),
          ),
        ),
        Positioned(
          top: 5,
          left: image.width! - 25,
          child: InkWell(
            onTap: () {
              ref.read(myInformationProvider.notifier).setFixedBucket(
                  ref.watch(myInformationProvider)!.fixedBucket == id
                      ? ''
                      : id);
            },
            child: Icon(Icons.push_pin,
                size: 25,
                color: ref.watch(myInformationProvider)!.fixedBucket == id
                    ? PRIMARY_COLOR
                    : Colors.white), // 여기에 원하는 아이콘을 설정하세요.
          ),
        ),
      ],
    );
  }

  double getAchievementRate() {
    int complementedCount =
        completedCustomItemList.length + completedRecommendItemList.length;
    int uncomplementedCount =
        uncompletedcustomItemList.length + uncompletedrecommendItemList.length;

    return (complementedCount) / (uncomplementedCount + complementedCount);
  }
}
