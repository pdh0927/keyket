import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_add_text_field.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/custom_underline_button.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/component/select_box.dart';
import 'package:keyket/common/const/colors.dart';
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
  List<CustomItemModel> updatedCustomBucketListItemList = [];
  List<String> newCustomItemList = [];
  List<String> newCustomItemCompletedList = [];
  List<String> deleteList = [];
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
                      return CustomAddTextField(
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
                      modifyItem: modifyItem,
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

  void modifyItem(String modifiedContent, Type type, bool isCompleted,
      String itemId, String beforeContent) {
    List<ItemModel> list;
    if (isCompleted) {
      list = completedBucketListItemList;
    } else {
      list = uncompletedBucketListItemList;
    }

    int index = list.indexWhere(
        (item) => item.content == beforeContent); // list에 변경 Item할 index 알아냄
    if (index != -1) // 동일한 ID를 가진 항목이 존재하면
    {
      if (type == RecommendItemModel) {
        if (isCompleted) {
          setState(() {
            modifiedBucketListModel.completedRecommendItemList.remove(itemId);
          });

          newCustomItemCompletedList.add(modifiedContent);
        } else {
          setState(() {
            modifiedBucketListModel.recommendItemList.remove(itemId);
          });

          newCustomItemList.add(modifiedContent);
        }

        setState(() {
          list[index] = (CustomItemModel(id: '', content: modifiedContent));
        });
      } else {
        CustomItemModel modifiedItem = list[index] as CustomItemModel;

        if (modifiedItem.id != '') {
          modifiedItem =
              modifiedItem.copyWith(content: modifiedContent); // 내용 변경
          setState(() {
            list[index] = modifiedItem;
          });

          index = updatedCustomBucketListItemList.indexWhere((item) =>
              item.id == modifiedItem.id); // updated list에서 업데이트 된적있는지 확인
          if (index != -1) // 업데이트된적 있다면 변경
          {
            updatedCustomBucketListItemList[index] = modifiedItem;
          } else // 업데이트된적 없다면 추가
          {
            updatedCustomBucketListItemList.add(modifiedItem);
          }
        } else {
          index = list.indexWhere(
              (item) => item.id == itemId); // list에 변경 Item할 index 알아냄
          setState(() {
            list[index] = (CustomItemModel(id: '', content: modifiedContent));
          });
          if (isCompleted) {
            index = newCustomItemCompletedList.indexWhere((content) =>
                content ==
                beforeContent); // newCustomItemCompletedList에서 변경 전 content index 검색

            newCustomItemCompletedList[index] = modifiedContent;
          } else {
            index = newCustomItemList.indexWhere((content) =>
                content ==
                beforeContent); // newCustomItemList에서 변경 전 content index 검색

            newCustomItemList[index] = modifiedContent;
          }
        }
      }

      setState(() {
        isChanged = true;
      });
    }
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
    print(modifiedBucketListModel.completedCustomItemList);

    print(modifiedBucketListModel.customItemList);
    print('----------------------------');
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
    print(modifiedBucketListModel.completedCustomItemList);

    print(modifiedBucketListModel.customItemList);
    print('----------------------------');
    changeFlag();
  }

  // Future<void> getItems(
  //   String id,
  //   List<String> customItemList,
  //   List<String> recommendItemList,
  //   List<String> completedCustomItemList,
  //   List<String> completedRecommendItemList,
  // ) async {
  //   List<ItemModel> uncompletedItems = [];
  //   List<ItemModel> completedItems = [];
  //   final firestore = FirebaseFirestore.instance;

  //   try {
  //     // Combine custom and completed custom item lists, preserving the order
  //     List<String> customItemsList = [
  //       ...customItemList,
  //       ...completedCustomItemList
  //     ];

  //     // Combine recommend and completed recommend item lists, preserving the order
  //     List<String> recommendItemsList = [
  //       ...recommendItemList,
  //       ...completedRecommendItemList
  //     ];

  //     // Fetch items from the custom and recommend collections
  //     var customItems = await getChunkedItems(
  //       firestore: firestore,
  //       collectionName: 'custom',
  //       itemList: customItemsList,
  //     );

  //     var recommendItems = await getChunkedItems(
  //       firestore: firestore,
  //       collectionName: 'recommend',
  //       itemList: recommendItemsList,
  //     );

  //     // Divide the fetched items into uncompleted and completed items
  //     uncompletedItems = [
  //       ...customItems.sublist(0, customItemList.length),
  //       ...recommendItems.sublist(0, recommendItemList.length),
  //     ];

  //     completedItems = [
  //       ...customItems.sublist(customItemList.length),
  //       ...recommendItems.sublist(recommendItemList.length),
  //     ];
  //   } catch (e) {
  //     print(e);
  //   }

  //   setState(() {
  //     uncompletedBucketListItemList = uncompletedItems;
  //     completedBucketListItemList = completedItems;
  //   });
  // }

  // Future<List<ItemModel>> getChunkedItems({
  //   required FirebaseFirestore firestore,
  //   required String collectionName,
  //   required List<String> itemList,
  // }) async {
  //   List<ItemModel> items = [];
  //   // 10개 단위로 나누기
  //   List<List<String>> itemChunks = [];
  //   for (int i = 0; i < itemList.length; i += 10) {
  //     itemChunks.add(itemList.sublist(
  //         i, i + 10 > itemList.length ? itemList.length : i + 10));
  //   }

  //   // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
  //   for (List<String> chunk in itemChunks) {
  //     QuerySnapshot querySnapshot = await firestore
  //         .collection(collectionName)
  //         .where(FieldPath.documentId, whereIn: chunk)
  //         .get();
  //     for (DocumentSnapshot doc in querySnapshot.docs) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       data['id'] = doc.id;

  //       if (collectionName == 'recommend') {
  //         items.add(RecommendItemModel.fromJson(data));
  //       } else if (collectionName == 'custom') {
  //         items.add(CustomItemModel.fromJson(data));
  //       }
  //     }
  //   }

  //   return items;
  // }

  // FireStore에서 item의 content 가져와서 넣기
  Future<void> getItems(
      String id,
      List<String> customItemList,
      List<String> recommendItemList,
      List<String> completedCustomItemList,
      List<String> completedRecommendItemList) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // custom, recommend 별로 리스트 결합(한번에 firestore 접근해서 접근 최소화 하기 위해)
    List<String> customItemsList =
        _combineLists(customItemList, completedCustomItemList);
    List<String> recommendItemsList =
        _combineLists(recommendItemList, completedRecommendItemList);

    // Firestore에서 해당하는 item 불러오기
    final List<ItemModel> customItems =
        await _fetchItems(firestore, 'custom', customItemsList);
    final List<ItemModel> recommendItems =
        await _fetchItems(firestore, 'recommend', recommendItemsList);

    // 아까 결합한 index 따라 complete, uncomplete item 분리하여 list에 넣음
    final List<ItemModel> uncompletedItems =
        _getSublist(customItems, 0, customItemList.length) +
            _getSublist(recommendItems, 0, recommendItemList.length);
    final List<ItemModel> completedItems = _getSublist(
            customItems, customItemList.length, customItemsList.length) +
        _getSublist(recommendItems, recommendItemList.length,
            recommendItemsList.length);

    // 상태 업데이트
    setState(() {
      uncompletedBucketListItemList = uncompletedItems;
      completedBucketListItemList = completedItems;
    });
  }

  // 두 List 결합
  List<String> _combineLists(List<String> list1, List<String> list2) {
    return [...list1, ...list2];
  }

  // FireStore에 접근해서 item 가져오기
  Future<List<ItemModel>> _fetchItems(FirebaseFirestore firestore,
      String collectionName, List<String> itemList) async {
    List<ItemModel> items = [];

    // FireStore에서는 한번에 10개씩 데이터를 가져올 수 있으므로 10개씩 분리하여 가져오기
    for (List<String> chunk in _chunkedList(itemList, 10)) {
      var querySnapshot = await firestore
          .collection(collectionName)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id; // 모델에 넣기 위해 id도 map에 넣어주기

        // item 종류에 따라서 알맞은 모델 변환해서 넣기
        items.add(collectionName == 'recommend'
            ? RecommendItemModel.fromJson(data)
            : CustomItemModel.fromJson(data));
      }
    }

    return items;
  }

  // 리스트를 청크로 분리
  List<List<String>> _chunkedList(List<String> list, int chunkSize) {
    List<List<String>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, min(i + chunkSize, list.length)));
    }
    return chunks;
  }

  // 리스트를 sublist로 변환
  List<ItemModel> _getSublist(List<ItemModel> list, int start, int end) {
    return list.sublist(start, end);
  }

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
        if (item.id == '') // 새로 생성돼서 아직 id가 없는경우
        {
          if (isCompleted) {
            completedBucketListItemList.remove(item);
            newCustomItemCompletedList.remove(item.content);
          } else {
            uncompletedBucketListItemList.remove(item);
            newCustomItemList.remove(item.content);
          }
        } else // 기존에 있던거라서 id가 있는 경우
        {
          if (isCompleted) {
            completedBucketListItemList.remove(item);
            modifiedBucketListModel.completedCustomItemList.remove(item.id);
          } else {
            uncompletedBucketListItemList.remove(item);
            modifiedBucketListModel.customItemList.remove(item.id);
          }
          deleteList.add(item.id);
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
      if (newCustomItemList.isNotEmpty ||
          newCustomItemCompletedList.isNotEmpty) {
        WriteBatch batch = firestore.batch();

        for (String content in List.from(newCustomItemList)) {
          DocumentReference docRef = firestore.collection('custom').doc();
          batch.set(docRef, {'content': content});
          setState(() {
            modifiedBucketListModel.customItemList.add(docRef.id);
            newCustomItemList.remove(content);

            for (int i = 0; i < uncompletedBucketListItemList.length; i++) {
              ItemModel item = uncompletedBucketListItemList[i];
              if (item is CustomItemModel && item.content == content) {
                setState(() {
                  uncompletedBucketListItemList[i] =
                      item.copyWith(id: docRef.id);
                });
                break;
              }
            }
          });
        }

        for (String content in List.from(newCustomItemCompletedList)) {
          DocumentReference docRef = firestore.collection('custom').doc();
          batch.set(docRef, {'content': content});
          setState(() {
            modifiedBucketListModel.completedCustomItemList.add(docRef.id);
            newCustomItemCompletedList.remove(content);
          });
          for (int i = 0; i < completedBucketListItemList.length; i++) {
            ItemModel item = completedBucketListItemList[i];
            if (item is CustomItemModel && item.content == content) {
              setState(() {
                completedBucketListItemList[i] = item.copyWith(id: docRef.id);
              });
              break;
            }
          }
        }

        await batch.commit();
      }

      // 완료, 미완료 변경
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

      // custom 항목 수정
      if (updatedCustomBucketListItemList.isNotEmpty) {
        WriteBatch batch = firestore.batch();
        for (CustomItemModel updatedItem in updatedCustomBucketListItemList) {
          DocumentReference docRef =
              firestore.collection('custom').doc(updatedItem.id);
          batch.update(docRef, {'content': updatedItem.content});

          setState(() {
            updatedCustomBucketListItemList.remove(updatedItem);
          });
        }

        await batch.commit();
      }

      if (deleteList.isNotEmpty) {
        WriteBatch batch = firestore.batch();
        for (String id in deleteList) {
          // Get a reference to the document
          DocumentReference docRef = firestore.collection('custom').doc(id);

          // Add a delete operation to the batch
          batch.delete(docRef);
        } // Commit the batch
        await batch
            .commit()
            .then((value) => print('Deleted successfully'))
            .catchError((error) => print('Failed to delete: $error'));
        deleteList = [];
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
          Expanded(
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
        ]);
  }
}
