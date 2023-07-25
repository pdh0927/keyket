import 'package:flutter/material.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';

class BucketListDetailScreen extends StatelessWidget {
  const BucketListDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height / 7), // here the desired height
        child: AppBar(
          backgroundColor: const Color(0xFFC4E4FA),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Handle menu button
              },
            ),
          ],
          flexibleSpace: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'title',
                style: TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomProgressBar(achievementRate: 0.3, height: 17, width: 180)
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const SizedBox(height: 25);
            } else if (index == 19) {
              return Container(
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Remix.add_line,
                    color: PRIMARY_COLOR,
                    size: 35,
                  ),
                ),
              );
            } else {
              return ListItem(
                // 추천 아이템
                selectFlag: true,
                isContain: true,
                onPressed: () {
                  // if (isContain) {
                  //   selectedRecommendIndexList.remove(index);
                  // } else {
                  //   selectedRecommendIndexList.add(index);
                  // }
                },
                content: 'item',
              );
            }
          },
        ),
      ),
    );
  }
}
