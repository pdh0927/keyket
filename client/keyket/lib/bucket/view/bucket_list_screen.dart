import 'package:flutter/material.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';

class BucketListScreen extends StatefulWidget {
  const BucketListScreen({super.key});

  @override
  State<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  bool flag = true; // true면 나, false면 공유

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '버킷',
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ToggleMenuButton(
                    title: '나',
                    onTap: () {
                      setState(() {
                        flag = true;
                      });
                    },
                    flag: flag),
                _ToggleMenuButton(
                    title: '공유',
                    onTap: () {
                      setState(() {
                        flag = false;
                      });
                    },
                    flag: !flag)
              ],
            )
          ],
        ));
  }
}

class _ToggleMenuButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool flag;

  const _ToggleMenuButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 105,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: flag
                  ? PRIMARY_COLOR
                  : const Color(0xFF1A1A1A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(5)),
          child: Text(title, style: toggleButtonTextStlye)),
    );
  }
}
