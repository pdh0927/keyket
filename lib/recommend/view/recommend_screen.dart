import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/show_help_image_dialog.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/custom_input_dialog.dart';
import 'package:keyket/common/component/custom_underline_button.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/component/list_select_button.dart';
import 'package:keyket/common/component/select_box.dart';

import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  bool selectFlag = false;
  bool createFlag = false;
  List<String> selectedRecommendIds = [];
  String? bucketName;
  String? bucketListId;
  bool? bucketListIsShared;
  final ScrollController _scrollController = ScrollController();
  bool isLastPage = false;

  @override
  void initState() {
    selectedRecommendIds = [];
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        // 스크롤의 끝에 도달
        setState(() {
          isLastPage =
              ref.read(recommendItemListProvider.notifier).fetchMoreData();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendedItems = ref.watch(recommendItemListProvider);

    List<BucketListModel> bucketList =
        ref.watch(myBucketListListProvider)!.values.toList() +
            ref.watch(sharedBucketListListProvider)!.values.toList();

    return DefaultLayout(
        title: '추천',
        actions: [
          InkWell(
            onTap: () {
              showHelpImageDialog(context, 'recommend_help');
            },
            child: const SizedBox(
              height: 10,
              child: Icon(Remix.error_warning_line,
                  color: PRIMARY_COLOR, size: 25),
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
                        showBottomSheet(bucketList);
                      }),
                    ],
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // 선택 해제 버튼
                    CustomUnderlineButton(
                        onPressed: () {
                          setState(() {
                            selectFlag = !selectFlag;
                            selectedRecommendIds = [];
                            bucketName = null;
                          });
                        },
                        icon: Remix.close_line,
                        text: '선택 해제'),

                    const SizedBox(width: 20),
                    // 버킷 저장 버튼
                    CustomUnderlineButton(
                      icon: Remix.add_line,
                      text: '버킷 저장',
                      onPressed: () {
                        if (createFlag) {
                          if (bucketName != null) {
                            Map<String, dynamic> newBucketData = {
                              'name': bucketName,
                              'image': '',
                              'isShared': false,
                              'users': [ref.read(myInformationProvider)!.id],
                              'host': ref.read(myInformationProvider)!.id,
                              'completedCustomItemList': [],
                              'completedRecommendItemList': [],
                              'uncompletedCustomItemList': [],
                              'uncompletedRecommendItemList':
                                  selectedRecommendIds,
                              'createdAt': DateTime.now(),
                              'updatedAt': DateTime.now(),
                            };

                            ref
                                .read(myBucketListListProvider.notifier)
                                .addNewBucket(newBucketData);
                          }
                        } else {
                          if (bucketListId != null) {
                            ref
                                .read(bucketListIsShared!
                                    ? sharedBucketListListProvider.notifier
                                    : myBucketListListProvider.notifier)
                                .updateRecommendItems(
                                    bucketListId!, selectedRecommendIds);
                          }
                        }
                        setState(() {
                          selectFlag = !selectFlag;
                          selectedRecommendIds = [];
                        });
                      },
                    ),
                  ]),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder // 추천 리스트
                  (
                controller: _scrollController,
                itemCount: recommendedItems.length + 1,
                itemBuilder: (context, index) {
                  if (index < recommendedItems.length) {
                    RecommendItemModel item = recommendedItems[index];
                    bool isContain = selectedRecommendIds.contains(item.id);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // getDottedLine(
                        //     index, true, recommendedItems.length), // 구분 점선
                        ListItem(
                            // 추천 아이템
                            isNeedSelectButton: selectFlag,
                            isContain: isContain,
                            isRecommendItem: true,
                            isNeedMoreButton: false,
                            onPressed: () {
                              setState(() {
                                if (isContain) {
                                  selectedRecommendIds.remove(item.id);
                                } else {
                                  selectedRecommendIds.add(item.id);
                                }
                              });
                            },
                            item: item),
                        // (isLastPage || recommendedItems.length < 10)
                        //     ? getDottedLine(
                        //         index, false, recommendedItems.length) // 구분 점선
                        //     : const SizedBox(height: 0, width: 0)
                      ],
                    );
                  } else {
                    return (isLastPage || recommendedItems.length < 10)
                        ? const SizedBox(height: 0)
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: 25.0,
                              height: 45.0,
                              child: const CircularProgressIndicator(),
                            ),
                          );
                  }
                },
              ),
            ),
          ]),
        ));
  }

  // dynamic getDottedLine(int index, bool isFirst, int totalLength) {
  //   if ((index == 0 && isFirst) || (index == totalLength - 1) && !isFirst) {
  //     return Column(
  //       children: [
  //         SizedBox(height: !isFirst ? 24 : 0),
  //         const DottedLine(
  //           dashLength: 5,
  //           dashGapLength: 2,
  //           lineThickness: 1,
  //           dashColor: PRIMARY_COLOR,
  //         ),
  //       ],
  //     );
  //   } else {
  //     return const SizedBox(height: 0);
  //   }
  // }

  List<String> getSelectedRecommendIds(
      List<RecommendItemModel> recommendedItems,
      List<int> selectedRecommendIndexList) {
    List<String> selectedIds = [];

    for (int index in selectedRecommendIndexList) {
      if (index >= 0 && index < recommendedItems.length) {
        selectedIds.add(recommendedItems[index].id);
      }
    }

    return selectedIds;
  }

  void showBottomSheet(List<BucketListModel> bucketListList) {
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
                    itemCount: bucketListList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 처음 요소를 새로운 버킷 만들기로
                        return _AddNewBucketItem(onTap: () async {
                          Navigator.pop(context);
                          String? tmpName = await showCustomInputDialog(
                              context, '새로운 버킷 만들기');
                          if (tmpName != null) {
                            setState(() {
                              bucketName = tmpName;
                              selectFlag = !selectFlag;
                              createFlag = true;
                            });
                          }
                        });
                      } else {
                        BucketListModel bucketList = bucketListList[index - 1];
                        return _OrdinaryBucketItem(
                            bucketName: bucketList.name,
                            bucketImage: bucketList.image,
                            onTap: () {
                              setState(() {
                                selectedRecommendIds = List.from(
                                    bucketList.uncompletedRecommendItemList +
                                        bucketList.completedRecommendItemList);
                              });

                              Navigator.pop(context);

                              setState(() {
                                selectFlag = !selectFlag;
                                createFlag = false;
                                bucketListId = bucketList.id;
                                bucketListIsShared = bucketList.isShared;
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
                      child: bucketImage != ''
                          ? CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: bucketImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!, // 어두운 색
                                highlightColor: Colors.grey[100]!, // 밝은 색
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.asset('asset/img/logo.png', width: 60)),
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
