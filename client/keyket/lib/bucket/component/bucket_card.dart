import 'package:flutter/material.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_model.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';

class BucketCard extends StatelessWidget {
  const BucketCard(
      {super.key,
      required this.name,
      required this.image,
      required this.achievement_rate,
      required this.created_at,
      required this.updated_at});

  final String name;
  final Widget image;
  final double achievement_rate;
  final DateTime created_at;
  final DateTime updated_at;

  factory BucketCard.fromModel({required BucketModel model}) {
    return BucketCard(
      image:
          Image.asset(width: 100, height: 100, model.image, fit: BoxFit.cover),
      name: model.name,
      achievement_rate: model.achievement_rate,
      created_at: model.created_at,
      updated_at: model.updated_at,
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
            _CustomProgressBar(achievement_rate: achievement_rate),
            Text(
              '최근 수정 : ${updated_at.year.toString().substring(2)}.${updated_at.month.toString().padLeft(2, '0')}.${updated_at.day.toString().padLeft(2, '0')}',
            )
          ],
        )
      ]),
    );
  }
}

class _CustomProgressBar extends StatelessWidget {
  final double achievement_rate;
  const _CustomProgressBar({super.key, required this.achievement_rate});

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
            value: achievement_rate,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(achievement_rate * 100).roundToDouble().toStringAsFixed(0)}%')
      ],
    );
  }
}
