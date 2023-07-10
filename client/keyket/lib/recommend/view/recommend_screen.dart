import 'package:flutter/material.dart';
import 'package:keyket/common/component/custom_alert_dialog.dart';
import 'package:keyket/common/component/custom_input_dialog.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
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
  List<Map<String, dynamic>> selectedList = [];
  bool selectFlag = false;
  List<int> selectedIndexList = [];

  @override
  void initState() {
    selectedIndexList = [];
    super.initState();
  }

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
            SizedBox(height: selectedList.isNotEmpty ? 8 : 0),
            // HashTag
            SizedBox(
              width: 100.w - 32,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HashTagItemList(
                  selectedList: selectedList,
                  deleteHashTag: deleteHashTag,
                ),
              ),
            ),
            const SizedBox(height: 16),
            selectFlag == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Remix.check_line, size: 25),
                          Text('추천 목록 List', style: dropdownTextStyle)
                        ],
                      ),
                      // List 선택 버튼
                      _ListSelectButton(onTap: () {
                        showBottomSheet();
                      }),
                    ],
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // 선택 해제 버튼
                    _CustonUnderlineButton(
                        onPressed: () {
                          setState(() {
                            selectFlag = !selectFlag;
                            selectedIndexList = [];
                          });
                        },
                        icon: Remix.close_line,
                        text: '선택 해제'),

                    const SizedBox(width: 20),
                    // 버킷 저장 버튼
                    _CustonUnderlineButton(
                        onPressed: () {}, icon: Remix.add_line, text: '버킷 저장'),
                  ]),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                // 추천 리스트
                itemCount: recommendedItems.length,
                itemBuilder: (context, index) {
                  bool isContain = selectedIndexList.contains(index);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDottedLine(index, true), // 구분 점선
                      _RecommendItem(
                          // 추천 아이템
                          selectFlag: selectFlag,
                          isContain: isContain,
                          onPressed: () {
                            setState(() {
                              if (isContain) {
                                selectedIndexList.remove(index);
                              } else {
                                selectedIndexList.add(index);
                              }
                            });
                          },
                          content: recommendedItems[index]['content']),
                      const Divider(
                        // 구분선
                        color: Color(0xFF616161),
                        thickness: 1,
                        height: 0,
                      ),
                      getDottedLine(index, false) // 구분 점선
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }

  void onSelected(String type, String value) {
    if (selectedList.length >= 6) {
      showCustomAlertDialog(context, '해쉬태그는 최대\n6개까지만 가능합니다.');
    } else {
      bool isDuplicate = selectedList // 항목이 중복으로 들어있는지 체크
          .any((item) => item['type'] == type && item['value'] == value);

      if (!isDuplicate) {
        setState(() {
          if (!selectedList.contains({'type': type, 'value': value})) {
            selectedList.add({'type': type, 'value': value});
          }
        });
      }
    }
  }

  void deleteHashTag(String type, String value) {
    setState(() {
      selectedList.removeWhere(
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

  void showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 80.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              Container(
                  width: 40.w,
                  height: 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF616161))),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: bucketList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 처음 요소를 새로운 버킷 만들기로
                        return const _AddNewBucketItem();
                      } else {
                        return _OrdinaryBucketItem(
                            bucketName: bucketList[index - 1]['name'],
                            bucketImage: bucketList[index - 1]['image'],
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectFlag = !selectFlag;
                              });
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ListSelectButton extends StatelessWidget {
  const _ListSelectButton({super.key, required this.onTap});
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

class _CustonUnderlineButton extends StatelessWidget {
  const _CustonUnderlineButton(
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

class _AddNewBucketItem extends StatelessWidget {
  const _AddNewBucketItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showCustomInputDialog(context);
          },
          child: Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: const Icon(
                        Icons.add_box,
                        size: 66,
                        color: Color(0xFFd9d9d9),
                      )),
                  const SizedBox(width: 24),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    child: Text(
                      '새로운 버킷 만들기',
                      style: bucketTextStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFd9d9d9),
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}

class _OrdinaryBucketItem extends StatelessWidget {
  const _OrdinaryBucketItem(
      {super.key,
      required this.bucketName,
      required this.bucketImage,
      required this.onTap});

  final String bucketName;
  final String? bucketImage;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: bucketImage != null
                          ? Image.asset(bucketImage!, width: 60)
                          : Image.asset('asset/img/default_bucket.png',
                              width: 60)),
                  const SizedBox(width: 24),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    child: Text(
                      bucketName,
                      style: bucketTextStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFd9d9d9),
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}

class _RecommendItem extends StatelessWidget {
  const _RecommendItem(
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
            ? IconButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                splashRadius: 15,
                icon: isContain
                    ? const Icon(Icons.check_box_rounded, color: PRIMARY_COLOR)
                    : const Icon(Icons.check_box_outline_blank_rounded,
                        color: PRIMARY_COLOR))
            : const SizedBox(height: 0),
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
      ],
    );
  }
}
