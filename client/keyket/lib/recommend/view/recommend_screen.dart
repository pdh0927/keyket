import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/recommend/component/filter_list.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';

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
          child: Column(
            children: [
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
                children: [
                  Row(
                    children: [
                      const Icon(Remix.check_line, size: 25),
                      Text('추천 목록 List', style: dropdownTextStyle)
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
