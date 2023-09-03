import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:remixicon/remixicon.dart';

class ListSelectButton extends StatelessWidget {
  const ListSelectButton({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Remix.checkbox_line,
            size: 25,
            color: BLACK_COLOR,
          ),
          const SizedBox(width: 5),
          Text('List 선택하기', style: dropdownTextStyle),
        ],
      ),
    );
  }
}
