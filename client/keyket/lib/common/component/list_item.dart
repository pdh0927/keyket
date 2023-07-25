import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {super.key,
      required this.selectFlag,
      required this.isContain,
      required this.onPressed,
      required this.content});
  final bool selectFlag;
  final bool isContain;
  final Function() onPressed;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        selectFlag == true
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                    onPressed: onPressed,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(maxHeight: 26, maxWidth: 26),
                    splashRadius: 15,
                    icon: isContain
                        ? const Icon(Icons.check_box_rounded,
                            color: PRIMARY_COLOR)
                        : const Icon(Icons.check_box_outline_blank_rounded,
                            color: PRIMARY_COLOR)),
              )
            : const SizedBox(height: 0),
        Expanded(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 55,
                padding: EdgeInsets.only(left: selectFlag == true ? 0 : 10),
                child: Text(
                  content,
                  style: dropdownTextStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              const Divider(
                // 구분선
                color: Color(0xFF616161),
                thickness: 1,
                height: 0,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 9,
        )
      ],
    );
  }
}
