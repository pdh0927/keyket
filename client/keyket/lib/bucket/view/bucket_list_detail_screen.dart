import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';

import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/custom_underline_button.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/component/select_box.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';

class BucketListDetailScreen extends ConsumerStatefulWidget {
  final String bucketListId;

  const BucketListDetailScreen({
    super.key,
    required this.bucketListId,
  });

  @override
  ConsumerState<BucketListDetailScreen> createState() =>
      _BucketListDetailScreenState();
}

class _BucketListDetailScreenState
    extends ConsumerState<BucketListDetailScreen> {
  late BucketListModel modifiedBucketListModel;
  List<ItemModel> uncompletedBucketListItemList = [];
  List<ItemModel> completedBucketListItemList = [];
  List<String> newCustomItemList = [];
  List<String> newCustomItemCompletedList = [];
  bool addCustomItemFlag = false;
  bool isChanged = false;

  @override
  void initState() {
    modifiedBucketListModel = ref
        .read(myBucketListListProvider.notifier)
        .getBucketListModel(widget.bucketListId);
    getItems(
        widget.bucketListId,
        modifiedBucketListModel.customItemList,
        modifiedBucketListModel.recommendItemList,
        modifiedBucketListModel.completedCustomItemList,
        modifiedBucketListModel.completedRecommendItemList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h / 6), // here the desired height
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Remix.arrow_left_s_line,
              color: Color(0xFF616161),
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context); // 이 부분에서 뒤로가기 기능을 구현합니다.
            },
          ),
          backgroundColor: const Color(0xFFC4E4FA),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Color(0xFF616161),
              ),
              onPressed: () {
                // Handle menu button
              },
            ),
          ],
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.h / 20),
              Text(
                modifiedBucketListModel.name,
                style: const TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 100.h / 28),
              CustomProgressBar(
                  achievementRate: getAchievementRate(), height: 17, width: 180)
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            isChanged
                ? Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 60,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () async {
                          await updateBucketListItems(
                              newCustomItemList, modifiedBucketListModel);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD9D9D9), // 버튼의 배경색을 회색으로 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // 버튼의 모서리를 둥글게 설정
                          ),
                          elevation: 0, // 버튼의 그림자를 제거
                          padding: const EdgeInsets.all(0),
                        ),
                        child: const Text(
                          '저장',
                          style: TextStyle(color: PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 0),
            Expanded(
              child: ListView.builder(
                itemCount: completedBucketListItemList.length +
                    uncompletedBucketListItemList.length +
                    1,
                itemBuilder: (context, index) {
                  if (index ==
                      completedBucketListItemList.length +
                          uncompletedBucketListItemList.length) {
                    if (addCustomItemFlag) {
                      return _CustomAddTextField(
                        onPressed: addNewCustomItem,
                      );
                    } else {
                      // item 생성 버튼
                      return Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            showAddButtonBottomSheet();
                          },
                          icon: const Icon(
                            Remix.add_line,
                            color: PRIMARY_COLOR,
                            size: 35,
                          ),
                        ),
                      );
                    }
                  } else {
                    ItemModel item;
                    if (index < uncompletedBucketListItemList.length) {
                      item = uncompletedBucketListItemList[index];
                    } else {
                      item = completedBucketListItemList[
                          index - uncompletedBucketListItemList.length];
                    }

                    final bool isCompleted =
                        index >= uncompletedBucketListItemList.length;
                    return ListItem(
                      // 추천 아이템
                      selectFlag: true,
                      isContain: isCompleted,
                      isRecommendItem: false,
                      removeItem: removeItem,
                      onPressed: () {
                        if (isCompleted) {
                          removeComplete(item);
                        } else {
                          addComplete(item);
                        }
                      },
                      item: item,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // 완료 목록에서 제거
  void removeComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.remove(item.id);
        modifiedBucketListModel.recommendItemList.add(item.id);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.remove(item.content);
          newCustomItemList.add(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.remove(item.id);
          modifiedBucketListModel.customItemList.add(item.id);
        }
      }
      completedBucketListItemList.remove(item);
      uncompletedBucketListItemList.add(item);
    });
    changeFlag();
  }

  // 완료 목록에 추가
  void addComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.add(item.id);
        modifiedBucketListModel.recommendItemList.remove(item.id);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.add(item.content);
          newCustomItemList.remove(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.add(item.id);
          modifiedBucketListModel.customItemList.remove(item.id);
        }
      }
      completedBucketListItemList.add(item);
      uncompletedBucketListItemList.remove(item);
    });
    changeFlag();
  }

  Future<void> getItems(
      String id,
      List<String> customItemList,
      List<String> recommendItemList,
      List<String> completedCustomItemList,
      List<String> completedRecommendItemList) async {
    List<ItemModel> uncompletedItems = [];
    List<ItemModel> completedItems = [];
    final firestore = FirebaseFirestore.instance;

    try {
      // Combine custom and completed custom item lists, preserving the order
      List<String> customItemsList = [
        ...customItemList,
        ...completedCustomItemList
      ];

      // Combine recommend and completed recommend item lists, preserving the order
      List<String> recommendItemsList = [
        ...recommendItemList,
        ...completedRecommendItemList
      ];

      // Fetch items from the custom and recommend collections
      var customItems = await getChunkedItems(
          firestore: firestore,
          collectionName: 'custom',
          itemList: customItemsList);

      var recommendItems = await getChunkedItems(
          firestore: firestore,
          collectionName: 'recommend',
          itemList: recommendItemsList);

      // Divide the fetched items into uncompleted and completed items
      uncompletedItems = [
        ...customItems.sublist(0, customItemList.length),
        ...recommendItems.sublist(0, recommendItemList.length),
      ];
      completedItems = [
        ...customItems.sublist(customItemList.length),
        ...recommendItems.sublist(recommendItemList.length),
      ];
    } catch (e) {
      print(e);
    }

    setState(() {
      uncompletedBucketListItemList = uncompletedItems;
      completedBucketListItemList = completedItems;
    });
  }

  Future<List<ItemModel>> getChunkedItems({
    required FirebaseFirestore firestore,
    required String collectionName,
    required List<String> itemList,
  }) async {
    List<ItemModel> items = [];
    // 10개 단위로 나누기
    List<List<String>> itemChunks = [];
    for (int i = 0; i < itemList.length; i += 10) {
      itemChunks.add(itemList.sublist(
          i, i + 10 > itemList.length ? itemList.length : i + 10));
    }

    // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
    for (List<String> chunk in itemChunks) {
      QuerySnapshot querySnapshot = await firestore
          .collection(collectionName)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        if (collectionName == 'recommend') {
          items.add(RecommendItemModel.fromJson(data));
        } else if (collectionName == 'custom') {
          items.add(CustomItemModel.fromJson(data));
        }
      }
    }

    return items;
  }

  // // bucket list 항목에 있는 item들 firestore에서 content 불러와서 ItemModel로 만듦
  // void getItems(
  //     String id,
  //     List<String> customItemList,
  //     List<String> recommendItemList,
  //     List<String> completedCustomItemList,
  //     List<String> completedRecommendItemList) async {
  //   List<ItemModel> items = [];
  //   final firestore = FirebaseFirestore.instance;
  //   try {
  //     // 10개 단위로 나누기
  //     List<List<String>> recommendItemChunks = [];
  //     for (int i = 0; i < recommendItemList.length; i += 10) {
  //       recommendItemChunks.add(recommendItemList.sublist(
  //           i,
  //           i + 10 > recommendItemList.length
  //               ? recommendItemList.length
  //               : i + 10));
  //     }

  //     // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
  //     for (List<String> chunk in recommendItemChunks) {
  //       QuerySnapshot querySnapshot = await firestore
  //           .collection('recommend')
  //           .where(FieldPath.documentId, whereIn: chunk)
  //           .get();
  //       for (DocumentSnapshot doc in querySnapshot.docs) {
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         data['id'] = doc.id;

  //         items.add(RecommendItemModel.fromJson(data));
  //       }
  //     }

  //     // 10개 단위로 나누기
  //     List<List<String>> customItemChunks = [];
  //     for (int i = 0; i < customItemList.length; i += 10) {
  //       customItemChunks.add(customItemList.sublist(i,
  //           i + 10 > customItemList.length ? customItemList.length : i + 10));
  //     }

  //     // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
  //     for (List<String> chunk in customItemChunks) {
  //       QuerySnapshot querySnapshot = await firestore
  //           .collection('custom')
  //           .where(FieldPath.documentId, whereIn: chunk)
  //           .get();
  //       for (DocumentSnapshot doc in querySnapshot.docs) {
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         data['id'] = doc.id;
  //         items.add(CustomItemModel.fromJson(data));
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   setState(() {
  //     bucketListItemList = items;
  //   });
  // }

  double getAchievementRate() {
    int completedCount =
        modifiedBucketListModel.completedCustomItemList.length +
            modifiedBucketListModel.completedRecommendItemList.length +
            newCustomItemCompletedList.length;
    int uncompletedCount = modifiedBucketListModel.customItemList.length +
        modifiedBucketListModel.recommendItemList.length +
        newCustomItemList.length;

    return (completedCount) / (completedCount + uncompletedCount);
  }

  // 새로 추가된 cusotom item
  void addNewCustomItem(String content) {
    setState(() {
      if (content != '') {
        uncompletedBucketListItemList
            .add(CustomItemModel(content: content, id: ''));
        newCustomItemList.add(content);
      }
      addCustomItemFlag = !addCustomItemFlag;
    });
    changeFlag();
  }

  // 새로 추가된 recommend item
  void addRecommendItem(RecommendItemModel item) {
    if (!modifiedBucketListModel.recommendItemList.contains(item.id) &&
        !modifiedBucketListModel.completedRecommendItemList.contains(item.id)) {
      setState(() {
        modifiedBucketListModel.recommendItemList.add(item.id);
        uncompletedBucketListItemList.add(RecommendItemModel(
            id: item.id,
            region: item.region,
            theme: item.theme,
            content: item.content));
      });
    }
    changeFlag();
  }

  // item 제거
  void removeItem(ItemModel item, bool isCompleted) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        // recommend item이면 다 id로 저장돼있으니 modifiedBucketListModel의 recommendItemList에서 제거
        if (isCompleted) {
          completedBucketListItemList.remove(item);
          modifiedBucketListModel.completedRecommendItemList.remove(item.id);
        } else {
          uncompletedBucketListItemList.remove(item);
          modifiedBucketListModel.recommendItemList.remove(item.id);
        }
      } else {
        // custom item이면
        if (item.id == '') {
          // 새로 생성돼서 아직 id가 없는경우
          if (isCompleted) {
            completedBucketListItemList.remove(item);
            newCustomItemCompletedList.remove(item.content);
          } else {
            uncompletedBucketListItemList.remove(item);
            newCustomItemList.remove(item.content);
          }
        } else {
          // 기존에 있던거라서 id가 있는 경우
          if (isCompleted) {
            completedBucketListItemList.remove(item);
            modifiedBucketListModel.completedCustomItemList.remove(item.id);
          } else {
            uncompletedBucketListItemList.remove(item);
            modifiedBucketListModel.customItemList.remove(item.id);
          }
        }
      }
    });

    changeFlag();
  }

  void showAddButtonBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: 30.h,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 40.w,
                      height: 8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF616161))),
                ),
                SizedBox(height: 10.h),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // 직접 추가 버튼
                  CustomUnderlineButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          addCustomItemFlag = !addCustomItemFlag;
                        });
                      },
                      icon: Remix.check_line,
                      text: '직접 추가'),

                  const SizedBox(width: 50),
                  // 추천 list 버튼
                  CustomUnderlineButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showRecommendListBottomSheet();
                      },
                      icon: Remix.search_line,
                      text: '추천 List 보기'),
                ]),
              ],
            ));
      },
    );
  }

  void showRecommendListBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: 90.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _RecommendItemList(
                uncomplementedRecommendItemList:
                    modifiedBucketListModel.recommendItemList,
                complementedRecommendItemList:
                    modifiedBucketListModel.completedRecommendItemList,
                addRecommendItem: addRecommendItem,
                removeRecommendItem: removeItem,
              ),
            ));
      },
    );
  }

  // 저장버튼 노출을 위해서 변경 사항이 있다면 isChanged true
  void changeFlag() {
    setState(() {
      isChanged = isChange();
    });
  }

  // 변경된 필드가 있는지 확인
  bool isChange() {
    BucketListModel originalBucketListModel = ref
        .read(myBucketListListProvider.notifier)
        .getBucketListModel(widget.bucketListId);
    return !listEquals(originalBucketListModel.completedCustomItemList,
            modifiedBucketListModel.completedCustomItemList) ||
        !listEquals(originalBucketListModel.completedRecommendItemList,
            modifiedBucketListModel.completedRecommendItemList) ||
        newCustomItemList.isNotEmpty ||
        newCustomItemCompletedList.isNotEmpty ||
        !listEquals(originalBucketListModel.customItemList,
            modifiedBucketListModel.customItemList) ||
        !listEquals(originalBucketListModel.recommendItemList,
            modifiedBucketListModel.recommendItemList);
  }

  Future<void> updateBucketListItems(List<String> newCustomItemList,
      BucketListModel modifiedBucketListModel) async {
    // Firestore에 접근하기 위한 참조를 생성
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Firestore에 새로운 custom item을 저장하고, 반환된 ID를 리스트에 추가
      for (String content in List.from(newCustomItemList)) {
        DocumentReference docRef =
            await firestore.collection('custom').add({'content': content});
        setState(() {
          modifiedBucketListModel.customItemList.add(docRef.id);
          newCustomItemList.remove(content);
        });
      }
      for (String content in List.from(newCustomItemCompletedList)) {
        DocumentReference docRef =
            await firestore.collection('custom').add({'content': content});
        setState(() {
          modifiedBucketListModel.completedCustomItemList.add(docRef.id);
          newCustomItemCompletedList.remove(content);
        });
      }

      BucketListModel originalBucketListModel = ref
          .read(myBucketListListProvider.notifier)
          .getBucketListModel(widget.bucketListId);
      Map<String, dynamic> updates = {};

      // Check each list and add to updates if there are changes
      if (!listEquals(originalBucketListModel.completedCustomItemList,
          modifiedBucketListModel.completedCustomItemList)) {
        updates['completedCustomItemList'] =
            modifiedBucketListModel.completedCustomItemList;
      }

      if (!listEquals(originalBucketListModel.completedRecommendItemList,
          modifiedBucketListModel.completedRecommendItemList)) {
        updates['completedRecommendItemList'] =
            modifiedBucketListModel.completedRecommendItemList;
      }

      if (!listEquals(originalBucketListModel.customItemList,
          modifiedBucketListModel.customItemList)) {
        updates['customItemList'] = modifiedBucketListModel.customItemList;
      }

      if (!listEquals(originalBucketListModel.recommendItemList,
          modifiedBucketListModel.recommendItemList)) {
        updates['recommendItemList'] =
            modifiedBucketListModel.recommendItemList;
      }

      setState(() {
        isChanged = false;
      });

      // 변경 됐다면 업데이트
      if (updates.isNotEmpty) {
        updates['updatedAt'] = DateTime.now(); // 현재 시간을 설정
        modifiedBucketListModel =
            modifiedBucketListModel.copyWith(updatedAt: updates['updatedAt']);
        await firestore
            .collection('bucket_list')
            .doc(modifiedBucketListModel.id)
            .update(updates);

        ref.read(myBucketListListProvider.notifier).changeBucketListModel(
            widget.bucketListId, modifiedBucketListModel);
      }
    } catch (e) {
      print(e);
    }
  }
}

class _RecommendItemList extends ConsumerStatefulWidget {
  final List<String> uncomplementedRecommendItemList;
  final List<String> complementedRecommendItemList;
  final Function addRecommendItem;
  final Function removeRecommendItem;

  const _RecommendItemList({
    required this.uncomplementedRecommendItemList,
    required this.complementedRecommendItemList,
    required this.addRecommendItem,
    required this.removeRecommendItem,
  });

  @override
  _RecommendItemListState createState() => _RecommendItemListState();
}

class _RecommendItemListState extends ConsumerState<_RecommendItemList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RecommendItemModel> recommendItemList =
        ref.watch(recommendItemListProvider);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 40.w,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFF616161))),
          ),
          const SizedBox(height: 20),
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
          recommendItemList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: recommendItemList.length,
                      itemBuilder: (context, index) {
                        final RecommendItemModel recommendItem =
                            recommendItemList[index];
                        bool containedComplement = widget
                            .complementedRecommendItemList
                            .contains(recommendItem.id);
                        bool uncontainedComplement = widget
                            .uncomplementedRecommendItemList
                            .contains(recommendItem.id);
                        bool isContain =
                            containedComplement || uncontainedComplement;

                        return ListItem(
                          selectFlag: true,
                          isContain: isContain,
                          isRecommendItem: true,
                          onPressed: () {
                            setState(
                              () {
                                if (isContain) {
                                  widget.removeRecommendItem(
                                      recommendItem, containedComplement);
                                } else {
                                  widget.addRecommendItem(recommendItem);
                                }
                              },
                            );
                          },
                          item: recommendItem,
                        );
                      }))
              : const CircularProgressIndicator(),
        ]);
  }
}

class _CustomAddTextField extends StatefulWidget {
  const _CustomAddTextField({
    required this.onPressed,
  });

  final Function(String) onPressed;

  @override
  _CustomAddTextFieldState createState() => _CustomAddTextFieldState();
}

class _CustomAddTextFieldState extends State<_CustomAddTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 16.0),
          child: DottedBorder(
            color: const Color(0xFF616161),
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(3),
            child: const SizedBox(
              width: 16,
              height: 16,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 55,
                padding: const EdgeInsets.only(left: 0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: dropdownTextStyle,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) {
                    widget.onPressed(text);
                    _controller.clear();
                  },
                ),
              ),
              const Divider(
                color: Color(0xFF616161),
                thickness: 1,
                height: 0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 9,
        ),
      ],
    );
  }
}
