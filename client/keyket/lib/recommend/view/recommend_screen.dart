import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/recommend/component/filter_list.dart';
import 'package:keyket/recommend/component/hash_tag_item.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:remixicon/remixicon.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  List<String> selectedRegionList = [];
  List<String> selectedWhoList = [];
  List<String> selectedThemeList = [];
  Set<HashTagItem> hashTagItemSet = Set<HashTagItem>();

  void onRegionSelected(String value) {
    setState(() {
      selectedRegionList.add(value);
      hashTagItemSet.add(HashTagItem(content: value));
    });
  }

  void onWhoSelected(String value) {
    setState(() {
      selectedWhoList.add(value);
      hashTagItemSet.add(HashTagItem(content: value));
    });
  }

  void onThemeSelected(String value) {
    setState(() {
      selectedThemeList.add(value);
      hashTagItemSet.add(HashTagItem(content: value));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterList(featureList: const [
                    'Region',
                    'Daegu',
                    'Busan',
                    'Seoul',
                    'Hapchun'
                  ], onSelected: onRegionSelected),
                  FilterList(featureList: const [
                    'Who',
                    'Family',
                    'Couple',
                    'Friends',
                    'Solo'
                  ], onSelected: onWhoSelected),
                  FilterList(featureList: const [
                    'Theme',
                    'Activity',
                    'Healing',
                    'Food',
                    'History'
                  ], onSelected: onThemeSelected)
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (int i = 0; i < hashTagItemSet.toList().length; i++)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: hashTagItemSet.toList()[i],
                    ),
                ]),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Remix.check_line, size: 25),
                      Text('추천 목록 List', style: dropdownTextStyle)
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
