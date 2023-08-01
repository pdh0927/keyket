import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/custom_add_text_field.dart';
import 'package:keyket/bucket/component/custom_progressbar.dart';
import 'package:keyket/bucket/component/member_card.dart';
import 'package:keyket/bucket/const/tmp_data.dart';
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
  // 버킷리스트의 id
  final String bucketListId;

  // 생성자에서 필요한 매개변수를 받아옵니다.
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
  // 수정될 버킷 리스트 모델
  late BucketListModel modifiedBucketListModel;

  // 화면에 보여질 완료되지 않은 항목 리스트
  List<ItemModel> uncompletedBucketListItemList = [];

  // 화면에 보여질 완료된 항목 리스트
  List<ItemModel> completedBucketListItemList = [];

  // 업데이트 된 custom bucketlist items 리스트
  List<CustomItemModel> updatedCustomBucketListItemList = [];

  // 새로 추가된 custom bucketlist items 리스트
  List<String> newCustomItemList = [];

  // 새로 추가된 완료된 custom bucketlist items 리스트
  List<String> newCustomItemCompletedList = [];

  // 삭제할 아이템 id list
  List<String> deleteList = [];

  // 아이템 추가 플래그
  bool addCustomItemFlag = false;

  // 버킷리스트의 변경 여부
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // 초기 데이터 구성
  }

  // 초기 데이터 구성
  void fetchData() {
    // 현재 저장된 버킷리스트 모델 불러오기
    modifiedBucketListModel =
        ref.read(myBucketListListProvider.notifier).getBucketListModel(
              widget.bucketListId,
            );
    // 현재 저장된 버킷리스트 모델에 저장된 item의 content 불러오기
    getItems(
      widget.bucketListId,
      modifiedBucketListModel.customItemList,
      modifiedBucketListModel.recommendItemList,
      modifiedBucketListModel.completedCustomItemList,
      modifiedBucketListModel.completedRecommendItemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: buildBody(),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 6.h),
              Container(
                height: 31,
                width: 85,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFD9D9D9),
                ),
                child: const Text(
                  '멤버',
                  style: TextStyle(
                      fontFamily: 'SCDream',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: PRIMARY_COLOR),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: tmp_user_list.length <= 5
                    ? tmp_user_list.length * 50.0
                    : 200.0,
                child: SingleChildScrollView(
                  physics: tmp_user_list.length <= 5
                      ? NeverScrollableScrollPhysics()
                      : ScrollPhysics(),
                  child: Column(
                    children: tmp_user_list.map((user) {
                      return MemberCard.fromModel(
                        model: user,
                        isHost: tmp_user_list.indexOf(user) == 0,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(right: 16, left: 10)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Remix.add_line,
                      size: 30,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '초대하기',
                      style: TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: PRIMARY_COLOR),
                    )
                  ],
                ),
                onPressed: () {
                  // '+ 버튼' 클릭 시 수행할 동작을 이 곳에 넣으세요.
                },
              ),
              const Divider(
                thickness: 1,
                height: 15,
                color: Color(0xFF616161),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.only(right: 16, left: 10)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Remix.folder_open_line,
                      size: 30,
                      color: Color(0xFF1A1A1A),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '배경화면 편집',
                      style: TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1A1A1A)),
                    ),
                    Spacer(),
                    Icon(
                      Remix.arrow_down_s_line,
                      size: 30,
                      color: Color(0xFF1A1A1A),
                    ),
                  ],
                ),
                onPressed: () {
                  // '+ 버튼' 클릭 시 수행할 동작을 이 곳에 넣으세요.
                },
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.only(right: 16, left: 10)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Remix.edit_line,
                      size: 30,
                      color: Color(0xFF1A1A1A),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '제목 편집',
                      style: TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1A1A1A)),
                    ),
                    Spacer(),
                    Icon(
                      Remix.arrow_down_s_line,
                      size: 30,
                      color: Color(0xFF1A1A1A),
                    ),
                  ],
                ),
                onPressed: () {
                  // '+ 버튼' 클릭 시 수행할 동작을 이 곳에 넣으세요.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar 구성
  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      // appbar size customize 위해서 사용
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.16),
      child: AppBar(
        leading: buildAppBarLeading(context), // 뒤로가기 버튼을 구성
        backgroundColor: const Color(0xFFC4E4FA),
        actions: <Widget>[
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Color(0xFF616161),
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
        flexibleSpace: buildFlexibleSpace(), // appbar 내용 구성
      ),
    );
  }

  // 뒤로가기 버튼 구성
  IconButton buildAppBarLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Remix.arrow_left_s_line,
        color: Color(0xFF616161),
        size: 40,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  // appbar 내용 구성
  Column buildFlexibleSpace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 빈공간
        // 제목
        Text(
          modifiedBucketListModel.name,
          style: const TextStyle(
            fontFamily: 'SCDream',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.033), // 빈공간
        // 달성도
        CustomProgressBar(
            achievementRate: getAchievementRate(), height: 17, width: 180)
      ],
    );
  }

  // 본문을 구성
  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10), // 빈공간
          buildSaveButton(), // 저장 버튼
          // 버킷리스트 내용 구성
          Expanded(child: buildListView()),
        ],
      ),
    );
  }

  // 저장 버튼을 구성
  Widget buildSaveButton() {
    // 변동사항이 있을 시만 생김
    return isChanged
        ? Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 60,
              height: 30,
              child: ElevatedButton(
                onPressed: () async {
                  // FireStore에 변경사항 저장
                  await updateBucketListItems(
                      newCustomItemList, modifiedBucketListModel);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(color: PRIMARY_COLOR),
                ),
              ),
            ),
          )
        : const SizedBox(height: 0);
  }

  // 버킷리스트 내용 구성
  ListView buildListView() {
    return ListView.builder(
      itemCount: completedBucketListItemList.length +
          uncompletedBucketListItemList.length +
          1,
      itemBuilder: (context, index) {
        if (isLastItem(index)) // 마지막 index 일때
        {
          if (addCustomItemFlag) // custom item 추가 버튼 클릭시
          {
            return CustomAddTextField(onPressed: addNewCustomItem);
          } else // custom item 추가 버튼
          {
            return buildAddItemButton();
          }
        } else // 마지막 index 아닐때 버킷리스트 구성 내용
        {
          return buildListItem(index);
        }
      },
    );
  }

  // 마지막 아이템인지 확인
  bool isLastItem(int index) {
    // index가 완료된 목록, 미완료된 목록 수를 더한것과 같을 때 마지막
    return index ==
        completedBucketListItemList.length +
            uncompletedBucketListItemList.length;
  }

  // 아이템 추가 버튼을
  Container buildAddItemButton() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {
          // 추가 버튼 클릭시 추가 메뉴 띄움
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

  // 리스트의 각 항목을 구성
  ListItem buildListItem(int index) {
    ItemModel item;

    // 먼저 미완료 목록부터 띄움
    if (index < uncompletedBucketListItemList.length) {
      item = uncompletedBucketListItemList[index];
    } else {
      item = completedBucketListItemList[
          index - uncompletedBucketListItemList.length];
    }

    final bool isCompleted = index >= uncompletedBucketListItemList.length;

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

  // item 수정
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

// FireStore에서 item의 content 가져와서 넣기
  Future<void> getItems(
      String id,
      List<String> customItemList,
      List<String> recommendItemList,
      List<String> completedCustomItemList,
      List<String> completedRecommendItemList) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // custom, recommend 별로 리스트 결합(한번에 firestore 접근해서 접근 최소화 하기 위해)
    List<String> tmpCustomItemsList = List.from(customItemList)
      ..addAll(completedCustomItemList);
    List<String> tmpRecommendItemsList = List.from(recommendItemList)
      ..addAll(completedRecommendItemList);

    // Firestore에서 해당하는 item 불러오기
    final List<ItemModel> customItems =
        await _fetchItems(firestore, 'custom', tmpCustomItemsList);
    final List<ItemModel> recommendItems =
        await _fetchItems(firestore, 'recommend', tmpRecommendItemsList);

    // Firestore에서 가져온 customItems id 목록
    Set<String> fetchedCustomItemsIds =
        Set.from(customItems.map((item) => item.id));

    // Firestore에서 존재하지 않으면 customItemList와 completedCustomItemList에서 제거
    int targetRemoveCount = customItemList.length +
        completedCustomItemList.length -
        fetchedCustomItemsIds.length;
    int customItemListRemovedCount = _removeNonExistentItems(
        customItemList, fetchedCustomItemsIds, targetRemoveCount);
    int completedCustomItemListRemovedCount = 0;
    if (customItemListRemovedCount < targetRemoveCount) {
      completedCustomItemListRemovedCount = _removeNonExistentItems(
          completedCustomItemList,
          fetchedCustomItemsIds,
          targetRemoveCount - customItemListRemovedCount);
    }

    Map<String, dynamic> updates = {};

    // custom_item_list가 변경되었으면 updates에 추가
    if (customItemListRemovedCount > 0) {
      updates['customItemList'] = customItemList;
    }

    // completed_custom_item_list가 변경되었으면 updates에 추가
    if (completedCustomItemListRemovedCount > 0) {
      updates['completedCustomItemList'] = completedCustomItemList;
    }

    // updates에 변경 사항이 있으면 Firestore에 한 번의 쓰기 작업으로 업데이트
    if (updates.isNotEmpty) {
      await firestore.collection('bucket_list').doc(id).update(updates);
    }

    // 기존 BucketListModel 찾기
    final existingBucketList = ref
        .read(myBucketListListProvider)
        .firstWhere((bucketList) => bucketList.id == widget.bucketListId);

    // 새로운 itemList로 BucketListModel 업데이트
    final updatedBucketList = existingBucketList.copyWith(
      customItemList: customItemList,
      completedCustomItemList: completedCustomItemList,
    );

    // StateNotifier를 통해 상태 업데이트
    ref
        .read(myBucketListListProvider.notifier)
        .updateBucketList(updatedBucketList);

    // 아까 결합한 index 따라 complete, uncomplete item 분리하여 list에 넣음
    final List<ItemModel> uncompletedItems =
        List.from(customItems.getRange(0, customItemList.length))
          ..addAll(recommendItems.getRange(0, recommendItemList.length));
    final List<ItemModel> completedItems = List.from(
        customItems.getRange(customItemList.length, customItems.length))
      ..addAll(recommendItems.getRange(
          recommendItemList.length, recommendItems.length));

    // 상태 업데이트
    setState(() {
      uncompletedBucketListItemList = uncompletedItems;
      completedBucketListItemList = completedItems;
    });
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

  int _removeNonExistentItems(List<String> itemList,
      Set<String> existingItemsIds, int targetRemoveCount) {
    int removedCount = 0;
    int currentIndex = 0;

    while (currentIndex < itemList.length && removedCount < targetRemoveCount) {
      if (!existingItemsIds.contains(itemList[currentIndex])) {
        itemList.removeAt(currentIndex);
        removedCount++;
      } else {
        currentIndex++;
      }
    }

    return removedCount; // Returns the count of items removed
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
    try {
      // Firestore에 접근하기 위한 참조를 생성
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch(); // 전체 작업을 위한 단일 WriteBatch 생성
      bool hasUpdates = false;

      // 새로운 custom item FireStore에 추가
      if (newCustomItemList.isNotEmpty ||
          newCustomItemCompletedList.isNotEmpty) {
        hasUpdates = true;
        // 완료되지 않은 새로운 아이템 FireStore에 추가
        await _addNewCustomBucketListItems(
          firestore,
          newCustomItemList,
          uncompletedBucketListItemList,
          modifiedBucketListModel.customItemList,
          batch,
        );
        // 완료된 새로운 아이템 FireStore에 추가
        await _addNewCustomBucketListItems(
          firestore,
          newCustomItemCompletedList,
          completedBucketListItemList,
          modifiedBucketListModel.completedCustomItemList,
          batch,
        );
      }

      // custom bucketlist item content 수정
      if (updatedCustomBucketListItemList.isNotEmpty) {
        hasUpdates = true;
        await _updateCustomBucketListItem(
            firestore, updatedCustomBucketListItemList, batch);
      }

      if (deleteList.isNotEmpty) {
        hasUpdates = true;
        await deleteItemsFromFirestore(firestore, deleteList, batch);
        deleteList = []; // 삭제 목록 초기화
      }

      if (hasUpdates) {
        await batch
            .commit()
            .then((value) => print('Batch committed successfully'))
            .catchError((error) => print('Failed to commit batch: $error'));

        modifiedBucketListModel =
            modifiedBucketListModel.copyWith(updatedAt: DateTime.now());
      }

      // bucket list model 업데이트
      await _updateChangedBucketListModel(
        modifiedBucketListModel,
        firestore,
      );

      setState(() {
        isChanged = false; // 저장 버튼 없애기
      });
    } catch (e) {
      print(e);
    }
  }

  // 새로 추가한 bucketlist item firestore에 추가
  Future<void> _addNewCustomBucketListItems(
    FirebaseFirestore firestore,
    List<String> itemList,
    List<ItemModel> bucketListItemList,
    List<String> customItemList,
    WriteBatch batch,
  ) async {
    for (String content in List.from(itemList)) {
      DocumentReference docRef = firestore.collection('custom').doc(); // id 지정
      batch.set(docRef, {'content': content}); // id와 content 매칭해서 저장

      setState(() {
        customItemList.add(docRef.id); // complete, uncomplete 목록에 추가
        itemList.remove(content); // 임시 newList에서 제거
      });

      // 현재 item list에서 id ''였는데 생성한 id로 업데이트
      for (int i = 0; i < bucketListItemList.length; i++) {
        ItemModel item = bucketListItemList[i];
        if (item is CustomItemModel && item.content == content) {
          setState(() {
            bucketListItemList[i] = item.copyWith(id: docRef.id);
          });
          break;
        }
      }
    }
  }

  // 기존의 custom bucketList item 수정
  Future<void> _updateCustomBucketListItem(
    FirebaseFirestore firestore,
    List<CustomItemModel> updatedCustomBucketListItemList,
    WriteBatch batch,
  ) async {
    List<CustomItemModel> updatedItemsCopy =
        List.from(updatedCustomBucketListItemList);
    for (CustomItemModel updatedItem in updatedItemsCopy) {
      DocumentReference docRef =
          firestore.collection('custom').doc(updatedItem.id);
      batch.update(docRef, {'content': updatedItem.content}); // 변경 content로 추가

      setState(() {
        updatedCustomBucketListItemList.remove(updatedItem); // 업데이트 목록에서 제거
      });
    }
  }

  // Firestore에서 items을 삭제
  Future<void> deleteItemsFromFirestore(FirebaseFirestore firestore,
      List<String> deleteList, WriteBatch batch) async {
    for (String id in deleteList) {
      // 문서에 대한 참조 가져오기
      DocumentReference docRef = firestore.collection('custom').doc(id);

      // 배치에 삭제 작업 추가
      batch.delete(docRef);
    }
  }

  // 두 버킷 리스트 모델 간의 변경 사항을 확인하고, 필요한 경우 Firebase에 업데이트
  Future<void> _updateChangedBucketListModel(
    BucketListModel modifiedBucketListModel,
    FirebaseFirestore firestore,
  ) async {
    Map<String, dynamic> updates = {};
    BucketListModel originalBucketListModel = ref
        .read(myBucketListListProvider.notifier)
        .getBucketListModel(widget.bucketListId);

    // 완료된 custom bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.completedCustomItemList,
        modifiedBucketListModel.completedCustomItemList)) {
      updates['completedCustomItemList'] =
          modifiedBucketListModel.completedCustomItemList;
    }

    // 완료된 recommend bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.completedRecommendItemList,
        modifiedBucketListModel.completedRecommendItemList)) {
      updates['completedRecommendItemList'] =
          modifiedBucketListModel.completedRecommendItemList;
    }

    // 완료되지 않은 custom bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.customItemList,
        modifiedBucketListModel.customItemList)) {
      updates['customItemList'] = modifiedBucketListModel.customItemList;
    }

    // 완료되지 않은 recommend bucketlist item 목록 확인
    if (!listEquals(originalBucketListModel.recommendItemList,
        modifiedBucketListModel.recommendItemList)) {
      updates['recommendItemList'] = modifiedBucketListModel.recommendItemList;
    }

    // 다른 변경사항이 있을 시
    if (originalBucketListModel.updatedAt !=
        modifiedBucketListModel.updatedAt) {
      updates['updatedAt'] = DateTime.now();
    }

    // 변경 사항이 있으면 Firebase에 업데이트
    if (updates.isNotEmpty) {
      await firestore
          .collection('bucket_list')
          .doc(modifiedBucketListModel.id)
          .update(updates);

      // 변경된 버킷 리스트 모델을 로컬에 업데이트
      ref
          .read(myBucketListListProvider.notifier)
          .changeBucketListModel(widget.bucketListId, modifiedBucketListModel);
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
