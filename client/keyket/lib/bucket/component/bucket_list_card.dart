import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/view/bucket_list_detail_screen.dart';
import 'package:remixicon/remixicon.dart';

class BucketListCard extends ConsumerWidget {
  final String id;
  final String name;
  final Widget image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> completedCustomItemList;
  final List<String> completedRecommendItemList;
  final List<String> customItemList;
  final List<String> recommendItemList;

  const BucketListCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.completedCustomItemList,
    required this.completedRecommendItemList,
    required this.customItemList,
    required this.recommendItemList,
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
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      completedCustomItemList: model.completedCustomItemList,
      completedRecommendItemList: model.completedRecommendItemList,
      customItemList: model.customItemList,
      recommendItemList: model.recommendItemList,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BucketListDetailScreen(
                  bucketListId: id,
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
    );
  }

  double getAchievementRate() {
    int complementedCount =
        completedCustomItemList.length + completedRecommendItemList.length;
    int uncomplementedCount = customItemList.length + recommendItemList.length;

    return (complementedCount) / (uncomplementedCount + complementedCount);
  }
}
