import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:keyket/common/component/custom_input_dialog.dart';
import 'package:keyket/common/component/custom_underline_button.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/component/list_select_button.dart';
import 'package:keyket/common/component/select_box.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/const/data.dart';

import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_line/dotted_line.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  bool selectFlag = false;
  List<int> selectedRecommendIndexList = [];

  @override
  void initState() {
    selectedRecommendIndexList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recommendedItems = ref.watch(recommendItemListProvider);

    return DefaultLayout(
        title: '추천',
        actions: [
          InkWell(
            onTap: () {},
            child: const SizedBox(
              height: 10,
              child: Icon(Remix.search_line, color: BLACK_COLOR, size: 25),
            ),
          ),
          const SizedBox(width: 25)
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            // Flitering
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SelectBox(),
            ),
            SizedBox(
                height: (ref.watch(selectedRegionFilterProvider) != null ||
                        ref.watch(selectedThemeFilterListProvider).isNotEmpty)
                    ? 8
                    : 0),
            // HashTag
            SizedBox(
              width: 100.w - 32,
              child: const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HashTagItemList(),
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
                      ListSelectButton(onTap: () {
                        showBottomSheet();
                      }),
                    ],
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // 선택 해제 버튼
                    CustomUnderlineButton(
                        onPressed: () {
                          setState(() {
                            selectFlag = !selectFlag;
                            selectedRecommendIndexList = [];
                          });
                        },
                        icon: Remix.close_line,
                        text: '선택 해제'),

                    const SizedBox(width: 20),
                    // 버킷 저장 버튼
                    CustomUnderlineButton(
                        onPressed: () {}, icon: Remix.add_line, text: '버킷 저장'),
                  ]),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                // 추천 리스트
                itemCount: recommendedItems.length,
                itemBuilder: (context, index) {
                  bool isContain = selectedRecommendIndexList.contains(index);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDottedLine(
                          index, true, recommendedItems.length), // 구분 점선
                      ListItem(
                          // 추천 아이템
                          selectFlag: selectFlag,
                          isContain: isContain,
                          isRecommendItem: true,
                          onPressed: () {
                            setState(() {
                              if (isContain) {
                                selectedRecommendIndexList.remove(index);
                              } else {
                                selectedRecommendIndexList.add(index);
                              }
                            });
                          },
                          item: recommendedItems[index]),
                      getDottedLine(
                          index, false, recommendedItems.length) // 구분 점선
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }

  dynamic getDottedLine(int index, bool isFirst, int totalLength) {
    if ((index == 0 && isFirst) || (index == totalLength - 1) && !isFirst) {
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
                        return _AddNewBucketItem(onTap: () async {
                          Navigator.pop(context);
                          await showCustomInputDialog(context, '새로운 버킷 만들기');
                          setState(() {
                            selectFlag = !selectFlag;
                          });
                        });
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

class _AddNewBucketItem extends StatelessWidget {
  const _AddNewBucketItem({super.key, required this.onTap});
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
