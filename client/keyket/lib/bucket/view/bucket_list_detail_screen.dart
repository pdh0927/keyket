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
  List<ItemModel> bucketListItemList = [];
  List<String> newCustomItemList = [];
  List<String> newCustomItemCompletedList = [];
  bool addFlag = false;
  bool addCustomItemFlag = false;
  bool isChanged = false;

  @override
  void initState() {
    modifiedBucketListModel = ref
        .read(myBucketListListProvider.notifier)
        .getBucketListModel(widget.bucketListId);
    getItems(widget.bucketListId, modifiedBucketListModel.customItemList,
        modifiedBucketListModel.recommendItemList);
    super.initState();
  }

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
                itemCount: bucketListItemList.length + 1,
                itemBuilder: (context, index) {
                  if (index == bucketListItemList.length) {
                    if (addFlag && !addCustomItemFlag) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 직접 추가 버튼
                            CustomUnderlineButton(
                                onPressed: () {
                                  setState(() {
                                    addCustomItemFlag = !addCustomItemFlag;
                                  });
                                },
                                icon: Remix.check_line,
                                text: '직접 추가'),

                            const SizedBox(width: 20),
                            // 추천 list 버튼
                            CustomUnderlineButton(
                                onPressed: () {
                                  showBottomSheet();
                                },
                                icon: Remix.search_line,
                                text: '추천 List 보기'),
                          ]);
                    } else if (addFlag && addCustomItemFlag) {
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
                            setState(() {
                              addFlag = !addFlag;
                            });
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
                    final item = bucketListItemList[index];
                    final bool isContain = isComplete(item);
                    return ListItem(
                      // 추천 아이템
                      selectFlag: true,
                      isContain: isContain,
                      isRecommendItem: false,
                      removeItem: removeItem,
                      onPressed: () {
                        if (isContain) {
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

  // 완료 목록에 있는지 판별
  bool isComplete(ItemModel item) {
    if (item.runtimeType == RecommendItemModel) {
      return modifiedBucketListModel.completedRecommendItemList
          .contains(item.id);
    } else {
      if (item.id == '') {
        return newCustomItemCompletedList.contains(item.content);
      } else {
        return modifiedBucketListModel.completedCustomItemList
            .contains(item.id);
      }
    }
  }

  // 완료 목록에서 제거
  void removeComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.remove(item.id);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.remove(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.remove(item.id);
        }
      }
    });
    changeFlag();
  }

  // 완료 목록에 추가
  void addComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        modifiedBucketListModel.completedRecommendItemList.add(item.id);
      } else {
        if (item.id == '') {
          newCustomItemCompletedList.add(item.content);
        } else {
          modifiedBucketListModel.completedCustomItemList.add(item.id);
        }
      }
    });
    changeFlag();
  }

  // bucket list 항목에 있는 item들 firestore에서 content 불러와서 ItemModel로 만듦
  void getItems(String id, List<String> customItemList,
      List<String> recommendItemList) async {
    List<ItemModel> items = [];
    final firestore = FirebaseFirestore.instance;
    try {
      // 10개 단위로 나누기
      List<List<String>> recommendItemChunks = [];
      for (int i = 0; i < recommendItemList.length; i += 10) {
        recommendItemChunks.add(recommendItemList.sublist(
            i,
            i + 10 > recommendItemList.length
                ? recommendItemList.length
                : i + 10));
      }

      // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
      for (List<String> chunk in recommendItemChunks) {
        QuerySnapshot querySnapshot = await firestore
            .collection('recommend')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (DocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;

          items.add(RecommendItemModel.fromJson(data));
        }
      }

      // 10개 단위로 나누기
      List<List<String>> customItemChunks = [];
      for (int i = 0; i < customItemList.length; i += 10) {
        customItemChunks.add(customItemList.sublist(i,
            i + 10 > customItemList.length ? customItemList.length : i + 10));
      }

      // 각 10개 단위의 부분 리스트에 대해 쿼리를 실행
      for (List<String> chunk in customItemChunks) {
        QuerySnapshot querySnapshot = await firestore
            .collection('custom')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (DocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          items.add(CustomItemModel.fromJson(data));
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      bucketListItemList = items;
    });
  }

  // 새로 추가된 cusotom item
  void addNewCustomItem(String content) {
    setState(() {
      if (content != '') {
        bucketListItemList.add(CustomItemModel(content: content, id: ''));
      }
      addCustomItemFlag = !addCustomItemFlag;
      newCustomItemList.add(content);
    });
    changeFlag();
  }

  // 새로 추가된 recommend item
  void addRecommendItem(RecommendItemModel item) {
    if (!modifiedBucketListModel.recommendItemList.contains(item.id)) {
      modifiedBucketListModel.recommendItemList.add(item.id);
      setState(() {
        bucketListItemList.add(RecommendItemModel(
            id: item.id,
            region: item.region,
            theme: item.theme,
            content: item.content));
      });
    }
    changeFlag();
  }

  // item 제거
  void removeItem(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        // recommend item이면 다 id로 저장돼있으니 modifiedBucketListModel의 recommendItemList에서 제거
        modifiedBucketListModel.recommendItemList.remove(item.id);
        modifiedBucketListModel.completedRecommendItemList.remove(item.id);
      } else {
        // custom item이면
        if (item.id == '') {
          // 새로 생성돼서 아직 id가 없는경우
          newCustomItemList.remove(item.content);
          newCustomItemCompletedList.remove(item.content);
        } else {
          // 기존에 있던거라서 id가 있는 경우
          modifiedBucketListModel.customItemList.remove(item.id);
          modifiedBucketListModel.completedCustomItemList.remove(item.id);
        }
      }
      bucketListItemList.remove(item as RecommendItemModel);
    });

    changeFlag();
  }

  void showBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: 90.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _RecommendItemList(
                containedRecommendItemList:
                    modifiedBucketListModel.recommendItemList,
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
        !listEquals(originalBucketListModel.recommendItemList,
            modifiedBucketListModel.recommendItemList);
  }

  Future<void> updateBucketListItems(List<String> newCustomItemList,
      BucketListModel modifiedBucketListModel) async {
    // Firestore에 접근하기 위한 참조를 생성합니다.
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Firestore에 새로운 custom item을 저장하고, 반환된 ID를 리스트에 추가합니다.
      for (String content in newCustomItemList) {
        DocumentReference docRef =
            await firestore.collection('custom').add({'content': content});
        modifiedBucketListModel.customItemList.add(docRef.id);
        if (newCustomItemCompletedList.contains(content)) {
          modifiedBucketListModel.completedCustomItemList.add(docRef.id);
        }
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
            modifiedBucketListModel.id, modifiedBucketListModel);
      }
    } catch (e) {
      print(e);
    }
  }
}

class _RecommendItemList extends ConsumerStatefulWidget {
  final List<String> containedRecommendItemList;
  final Function addRecommendItem;
  final Function removeRecommendItem;

  const _RecommendItemList({
    required this.containedRecommendItemList,
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
                        bool isContain = widget.containedRecommendItemList
                            .contains(recommendItem.id);

                        return ListItem(
                          selectFlag: true,
                          isContain: isContain,
                          isRecommendItem: true,
                          onPressed: () {
                            setState(
                              () {
                                if (isContain) {
                                  widget.removeRecommendItem(recommendItem);
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
