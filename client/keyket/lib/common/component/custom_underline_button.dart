import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';

class CustomUnderlineButton extends StatelessWidget {
  const CustomUnderlineButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  final IconData icon;
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: BLACK_COLOR,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(text, style: dropdownTextStyle)
          ],
        ),
      ),
    );
  }
}
