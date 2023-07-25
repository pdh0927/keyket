import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';

class CustomProgressBar extends StatelessWidget {
  final double achievementRate;
  final double height;
  final double width;

  const CustomProgressBar(
      {super.key,
      required this.achievementRate,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height,
          width: width,
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
        Text('${(achievementRate * 100).roundToDouble().toStringAsFixed(0)}%',
            style: const TextStyle(
                fontFamily: 'SCDream',
                fontSize: 12,
                fontWeight: FontWeight.w400))
      ],
    );
  }
}
