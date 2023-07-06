import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';

class HashTagItem extends StatelessWidget {
  final String content;

  const HashTagItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
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
              '# $content',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Remix.close_circle_line, size: 14),
              padding: EdgeInsets.zero,
              splashRadius: 15,
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              onPressed: () {},
            )
          ],
        ));
  }
}
