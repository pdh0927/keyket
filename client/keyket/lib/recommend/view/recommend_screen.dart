import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/recommend/component/filter_list.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/const/data.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_line/dotted_line.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  Set<Map<String, String>> selectedSet = Set<Map<String, String>>();

  void onSelected(String type, String value) {
    setState(() {
      selectedSet.add({'type': type, 'value': value});
    });
  }

  void deleteHashTag(String type, String value) {
    setState(() {
      selectedSet.removeWhere(
          (element) => element['type'] == type && element['value'] == value);
    });
  }

  dynamic getDottedLine(int index, bool isFirst) {
    if ((index == 0 && isFirst) ||
        (index == recommendedItems.length - 1) && !isFirst) {
      return Column(
        children: [
          SizedBox(height: !isFirst ? 24 : 0),
          const DottedLine(
            dashLength: 5,
            dashGapLength: 2,
            lineThickness: 1,
            dashColor: PRIMARY_COLOR,
          ),
        ],
      );
    } else {
      return const SizedBox(height: 0);
    }
  }

  bool selectFlag = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '추천',
        actions: const [
          Icon(
            Remix.search_line,
            color: BLACK_COLOR,
          ),
          SizedBox(width: 25)
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            // Flitering
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Region Filter
                FilterList(featureList: const [
                  'Region',
                  'Daegu',
                  'Busan',
                  'Seoul',
                  'Hapchun'
                ], onSelected: onSelected),
                // Who Filter
                FilterList(featureList: const [
                  'Who',
                  'Family',
                  'Couple',
                  'Friends',
                  'Solo'
                ], onSelected: onSelected),
                // Who Theme
                FilterList(featureList: const [
                  'Theme',
                  'Activity',
                  'Healing',
                  'Food',
                  'History'
                ], onSelected: onSelected)
              ],
            ),
            SizedBox(height: selectedSet.isNotEmpty ? 8 : 0),
            // HashTag
            SizedBox(
              width: 100.w - 32,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HashTagItemList(
                  selectedList: selectedSet.toList(),
                  deleteHashTag: deleteHashTag,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Remix.check_line, size: 25),
                    Text('추천 목록 List', style: dropdownTextStyle)
                  ],
                ),
                // List 선택 버튼
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectFlag = true;
                      });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.only(right: 3)),
                    ),
                    icon: const Icon(
                      Remix.checkbox_line,
                      size: 25,
                      color: BLACK_COLOR,
                    ),
                    label: Text('List 선택하기', style: dropdownTextStyle)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recommendedItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDottedLine(index, true),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 55,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          recommendedItems[index]['content'],
                          style: dropdownTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const Divider(
                        color: Color(0xFF616161),
                        thickness: 1,
                        height: 0,
                      ),
                      getDottedLine(index, false)
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
