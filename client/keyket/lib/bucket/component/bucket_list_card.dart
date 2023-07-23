import 'package:flutter/material.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/common/const/colors.dart';
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
    return IntrinsicHeight(
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(5.0), child: image),
        const SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Remix.arrow_right_s_line),
                    Text(
                      name,
                      style: popupMenuTextStlye,
                    )
                  ],
                )),
            _CustomProgressBar(achievementRate: achievementRate),
            Text(
              '최근 수정 : ${updatedAt.year.toString().substring(2)}.${updatedAt.month.toString().padLeft(2, '0')}.${updatedAt.day.toString().padLeft(2, '0')}',
            )
          ],
        )
      ]),
    );
  }
}

class _CustomProgressBar extends StatelessWidget {
  final double achievementRate;
  const _CustomProgressBar({super.key, required this.achievementRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 160,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: PRIMARY_COLOR),
          ),
          child: LinearProgressIndicator(
            value: achievementRate,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(achievementRate * 100).roundToDouble().toStringAsFixed(0)}%')
      ],
    );
  }
}
