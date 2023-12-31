import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/view/bucket_list_detail_screen.dart';
import 'package:keyket/common/const/colors.dart';

import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';

class BucketListCard extends ConsumerWidget {
  final String id;
  final String name;
  final Widget image;
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
          ? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: PRIMARY_COLOR),
                image: const DecorationImage(
                  image: AssetImage("asset/img/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: model.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!, // 어두운 색
                  highlightColor: Colors.grey[100]!, // 밝은 색
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
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
              image,
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
          left: 100 - 27,
          child: InkWell(
            onTap: () {
              ref.read(myInformationProvider.notifier).setFixedBucket(
                  ref.watch(myInformationProvider)!.fixedBucket == id
                      ? ''
                      : id);
            },
            child: Icon(
              ref.watch(myInformationProvider)!.fixedBucket == id
                  ? Remix.pushpin_fill
                  : Remix.pushpin_line,
              size: 25,
              color: ref.watch(myInformationProvider)!.fixedBucket == id
                  ? PRIMARY_COLOR
                  : Colors.black,
            ),
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
