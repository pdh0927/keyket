import 'package:flutter/material.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/view/bucket_list_detail_screen.dart';
import 'package:remixicon/remixicon.dart';

class BucketListCard extends StatelessWidget {
  const BucketListCard(
      {super.key,
      required this.name,
      required this.image,
      required this.achievementRate,
      required this.createdAt,
      required this.updatedAt});

  final String name;
  final Widget image;
  final double achievementRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BucketListCard.fromModel({required BucketListModel model}) {
    return BucketListCard(
      image: model.image == ''
          ? Image.asset(
              width: 100,
              height: 100,
              "asset/img/default_bucket.png",
              fit: BoxFit.cover)
          : Image.asset(
              width: 100, height: 100, model.image, fit: BoxFit.cover),
      name: model.name,
      achievementRate: model.achievementRate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BucketListDetailScreen()));
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
                achievementRate: achievementRate,
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
}
