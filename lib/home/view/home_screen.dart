import 'dart:async';
import 'dart:math';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/bucket/provider/bucket_list_detail_provider.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/list_item.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/home/provider.dart/banner_advertisement_provider.dart';
import 'package:keyket/home/provider.dart/recommend_region_provider.dart';
import 'package:keyket/my/component/my_notification.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String authStatus = 'Unknown';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initPlugin());
    super.initState();
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '홈',
      actions: [
        IconButton(
          icon: const Icon(Remix.notification_4_line, size: 28),
          splashRadius: 20,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyNotification(),
              ),
            );
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _AdvertisementContainer(
                adWidth: MediaQuery.of(context).size.width.toInt() - 32,
                adMaxHeight: 60,
              ),
              const SizedBox(height: 20),
              _FixedBucketList(),
              const SizedBox(
                height: 20,
              ),
              const _RegionImageContainer(),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvertisementContainer extends ConsumerStatefulWidget {
  final int adWidth;
  final int adMaxHeight;

  const _AdvertisementContainer(
      {super.key, required this.adWidth, required this.adMaxHeight});

  @override
  ConsumerState<_AdvertisementContainer> createState() =>
      _AdvertisementContainerState();
}

class _AdvertisementContainerState
    extends ConsumerState<_AdvertisementContainer> {
  @override
  void initState() {
    if (ref.read(bannerAdvertisementProvider) == null) {
      ref
          .read(bannerAdvertisementProvider.notifier)
          .loadAd(widget.adWidth, widget.adMaxHeight);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAdvertisement = ref.watch(bannerAdvertisementProvider);
    if (bannerAdvertisement == null) {
      return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: const CircularProgressIndicator());
    } else {
      return Container(
        alignment: Alignment.center,
        width: widget.adWidth.toDouble(),
        height: widget.adMaxHeight.toDouble(),
        child: AdWidget(ad: bannerAdvertisement),
      );
    }
  }
}

class _FixedBucketList extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FixedBucketList> createState() => _FixedBucketListState();
}

class _FixedBucketListState extends ConsumerState<_FixedBucketList> {
  BucketListModel? fixedBucketList;
  List<CustomItemModel> completeCustomItemList = [];
  List<CustomItemModel> uncompleteCustomItemList = [];
  List<RecommendItemModel> completeRecommendItemList = [];
  List<RecommendItemModel> uncompleteRecommendItemList = [];
  bool isGetItemComplete = false;

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(myInformationProvider);

    if (info != null) {
      if (ref.watch(myBucketListListProvider) != null &&
          ref.watch(sharedBucketListListProvider) != null) {
        if (ref.watch(myBucketListListProvider)!.isNotEmpty ||
            ref.watch(sharedBucketListListProvider)!.isNotEmpty) {
          fixedBucketList = ref
                  .read(myBucketListListProvider.notifier)
                  .getBucketListModel(info.fixedBucket) ??
              ref
                  .read(sharedBucketListListProvider.notifier)
                  .getBucketListModel(info.fixedBucket);
        }
      } else {
        ref
            .read(myBucketListListProvider.notifier)
            .getBucketList(info.id, false);

        ref
            .read(sharedBucketListListProvider.notifier)
            .getBucketList(info.id, true);
      }
    }

    if (fixedBucketList != null && !isGetItemComplete) {
      getItems(
        fixedBucketList!.id,
        fixedBucketList!.uncompletedCustomItemList,
        fixedBucketList!.uncompletedRecommendItemList,
        fixedBucketList!.completedCustomItemList,
        fixedBucketList!.completedRecommendItemList,
      );
    }

    return Container(
      width: double.infinity,
      height: 55.h,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: fixedBucketList == null
            ? PRIMARY_COLOR.withOpacity(0.5)
            : fixedBucketList!.image == ''
                ? PRIMARY_COLOR.withOpacity(0.5)
                : null, // null을 설정하여 기본 배경색을 삭제합니다.
        image: (fixedBucketList == null || fixedBucketList!.image == '')
            ? null
            : DecorationImage(
                image: NetworkImage(
                    fixedBucketList!.image), // 이미지 경로를 NetworkImage로 로드합니다.
                fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조정합니다.
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5),
                  BlendMode.srcOver, // BlendMode를 사용하여 이미지 위에 반투명한 색을 덧붙입니다.
                ),
              ),
      ),
      child: (isGetItemComplete && fixedBucketList != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Remix.arrow_left_s_line),
                    Text(
                      fixedBucketList!.name,
                      style: const TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const Icon(Remix.arrow_right_s_line)
                  ],
                ),
                const SizedBox(height: 15),
                // getItem 했을 때 id에 없으면 id에 해당하는 거만 불러와서 저장

                Expanded(
                  child: ListView.builder(
                    itemCount: fixedBucketList!
                            .uncompletedCustomItemList.length +
                        fixedBucketList!.uncompletedRecommendItemList.length +
                        fixedBucketList!.completedCustomItemList.length +
                        fixedBucketList!.completedRecommendItemList.length,
                    itemBuilder: (context, index) {
                      return buildListItem(index);
                    },
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/img/logo_transparent.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 10),
                const Text(
                  '고정된 버킷이 없습니다',
                  style: TextStyle(
                      fontFamily: 'SCDream',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
    );
  }

  Future<void> getItems(
    String id,
    List<String> uncompletedCustomItemList,
    List<String> uncompletedRecommendItemList,
    List<String> completedCustomItemList,
    List<String> completedRecommendItemList,
  ) async {
    final bucketListCustomItemState = ref.read(customBucketListItemProvider);
    final bucketListRecommendItemState =
        ref.read(recommendBucketListItemProvider);

    // ID를 로컬에서 찾을 수 있는 경우 Firestore에 접근하지 않음
    if (!bucketListCustomItemState.containsKey(id) ||
        !bucketListRecommendItemState.containsKey(id)) {
      await _fetchAndUpdate(
        id,
        uncompletedCustomItemList,
        uncompletedRecommendItemList,
        completedCustomItemList,
        completedRecommendItemList,
      );
    } else {
      if (fixedBucketList!.isShared) {
        Set<String> currentCustomBucketUncompleteItemIdsSet = Set.from(
            bucketListCustomItemState[id]
                    ?.uncompleteItems
                    .map((item) => item.id) ??
                []);
        Set<String> currentCustomBucketCompleteItemIdsSet = Set.from(
            bucketListCustomItemState[id]
                    ?.completeItems
                    .map((item) => item.id) ??
                []);
        Set<String> currentRecommendBucketUncompleteItemIdsSet = Set.from(
            bucketListRecommendItemState[id]
                    ?.uncompleteItems
                    .map((item) => item.id) ??
                []);
        Set<String> currentRecommendBucketCompleteItemIdsSet = Set.from(
            bucketListRecommendItemState[id]
                    ?.completeItems
                    .map((item) => item.id) ??
                []);

        bool isCustomUncompleteItemsChanged = itemsChanged(
            currentCustomBucketUncompleteItemIdsSet, uncompletedCustomItemList);
        bool isCustomCompleteItemsChanged = itemsChanged(
            currentCustomBucketCompleteItemIdsSet, completedCustomItemList);
        bool isRecommendUncompleteItemsChanged = itemsChanged(
            currentRecommendBucketUncompleteItemIdsSet,
            uncompletedRecommendItemList);
        bool isRecommendCompleteItemsChanged = itemsChanged(
            currentRecommendBucketCompleteItemIdsSet,
            completedRecommendItemList);

        if (isCustomUncompleteItemsChanged ||
            isCustomCompleteItemsChanged ||
            isRecommendUncompleteItemsChanged ||
            isRecommendCompleteItemsChanged) {
          await _fetchAndUpdate(
            id,
            uncompletedCustomItemList,
            uncompletedRecommendItemList,
            completedCustomItemList,
            completedRecommendItemList,
          );
        }
      }
    }

    setState(() {
      CustomItems tmpCustomItems = ref
          .read(customBucketListItemProvider)[fixedBucketList!.id]!
          .deepCopy();
      RecommendItems tmpRecommendsItems = ref
          .read(recommendBucketListItemProvider)[fixedBucketList!.id]!
          .deepCopy();
      completeCustomItemList = tmpCustomItems.completeItems;
      uncompleteCustomItemList = tmpCustomItems.uncompleteItems;
      completeRecommendItemList = tmpRecommendsItems.completeItems;
      uncompleteRecommendItemList = tmpRecommendsItems.uncompleteItems;

      isGetItemComplete = true;
    });
  }

  bool itemsChanged(Set<String> current, List<String> newItems) {
    Set<String> newItemSet = Set.from(newItems);
    return current.difference(newItemSet).isNotEmpty ||
        newItemSet.difference(current).isNotEmpty;
  }

  _fetchAndUpdate(
      String id,
      List<String> uncompletedCustomItemList,
      List<String> uncompletedRecommendItemList,
      List<String> completedCustomItemList,
      List<String> completedRecommendItemList) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> tmpCustomItemsList = List.from(uncompletedCustomItemList)
      ..addAll(completedCustomItemList);
    List<String> tmpRecommendItemsList = List.from(uncompletedRecommendItemList)
      ..addAll(completedRecommendItemList);

    // Firestore에서 해당하는 item 불러오기
    final List<CustomItemModel> fetchedCustomItems =
        (await _fetchItems(firestore, 'custom', tmpCustomItemsList))
            .map((item) => item as CustomItemModel)
            .toList();

    // 재정렬을 위해 id를 key로 가진 Map 생성
    final Map<String, CustomItemModel> idToItem = {
      for (var item in fetchedCustomItems) item.id: item
    };

    // 기존 순서(uncomplete앞, complete뒤)에 맞게 재정렬
    final List<CustomItemModel> customItems =
        tmpCustomItemsList.map((id) => idToItem[id]!).toList();

    final List<RecommendItemModel> fetchedRecommendItems =
        (await _fetchItems(firestore, 'recommend', tmpRecommendItemsList))
            .map((item) => item as RecommendItemModel)
            .toList();

    final Map<String, RecommendItemModel> idToRecommendItem = {
      for (var item in fetchedRecommendItems) item.id: item
    };

    final List<RecommendItemModel> recommendItems =
        tmpRecommendItemsList.map((id) => idToRecommendItem[id]!).toList();

    // Firestore에서 가져온 customItems id 목록
    Set<String> fetchedCustomItemsIds =
        Set.from(customItems.map((item) => item.id));

    // Firestore에서 존재하지 않으면 customItemList와 completedCustomItemList에서 제거
    int targetRemoveCount = uncompletedCustomItemList.length +
        completedCustomItemList.length -
        fetchedCustomItemsIds.length;
    int uncustomItemListRemovedCount = _removeNonExistentItems(
        uncompletedCustomItemList, fetchedCustomItemsIds, targetRemoveCount);
    int completedCustomItemListRemovedCount = 0;
    if (uncustomItemListRemovedCount < targetRemoveCount) {
      completedCustomItemListRemovedCount = _removeNonExistentItems(
          completedCustomItemList,
          fetchedCustomItemsIds,
          targetRemoveCount - uncustomItemListRemovedCount);
    }

    // 나눠 담기 위해 index 수정
    int uncompletedCustomItemsCount = uncompletedCustomItemList.length;
    int completedCustomItemsCount = completedCustomItemList.length;

    // 나눠 담기
    ref.read(customBucketListItemProvider.notifier).addCustomItemsToBucketList(
        id,
        CustomItems(
            completeItems: customItems
                .getRange(uncompletedCustomItemsCount,
                    uncompletedCustomItemsCount + completedCustomItemsCount)
                .toList(),
            uncompleteItems:
                customItems.getRange(0, uncompletedCustomItemsCount).toList()));

    ref
        .read(recommendBucketListItemProvider.notifier)
        .addRecommendItemsToBucketList(
            id,
            RecommendItems(
              completeItems: recommendItems
                  .getRange(
                      uncompletedRecommendItemList.length,
                      uncompletedRecommendItemList.length +
                          completedRecommendItemList.length)
                  .toList(),
              uncompleteItems: recommendItems
                  .getRange(0, uncompletedRecommendItemList.length)
                  .toList(),
            ));

    Map<String, dynamic> updates = {};

    // custom_item_list가 변경되었으면 updates에 추가
    if (uncustomItemListRemovedCount > 0) {
      updates['uncompletedCustomItemList'] = uncompletedCustomItemList;
    }

    // completed_custom_item_list가 변경되었으면 updates에 추가
    if (completedCustomItemListRemovedCount > 0) {
      updates['completedCustomItemList'] = completedCustomItemList;
    }

    // updates에 변경 사항이 있으면 Firestore에 한 번의 쓰기 작업으로 업데이트
    if (updates.isNotEmpty) {
      await firestore.collection('bucket_list').doc(id).update(updates);

      // 기존 BucketListModel 찾기
      final existingBucketList = fixedBucketList!.isShared
          ? ref
              .read(sharedBucketListListProvider.notifier)
              .getBucketListModel(fixedBucketList!.id)
          : ref
              .read(myBucketListListProvider.notifier)
              .getBucketListModel(fixedBucketList!.id);

      // 새로운 itemList로 BucketListModel 업데이트
      final updatedBucketList = existingBucketList!.copyWith(
        customItemList: uncompletedCustomItemList,
        completedCustomItemList: completedCustomItemList,
      );

      // StateNotifier를 통해 상태 업데이트
      fixedBucketList!.isShared
          ? ref
              .read(sharedBucketListListProvider.notifier)
              .updateBucketList(updatedBucketList)
          : ref
              .read(myBucketListListProvider.notifier)
              .updateBucketList(updatedBucketList);
    }
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

    return removedCount; // 제거된 수
  }

  // 완료 목록에서 제거
  void removeComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        fixedBucketList!.completedRecommendItemList.remove(item.id);
        fixedBucketList!.uncompletedRecommendItemList.add(item.id);

        completeRecommendItemList.remove(item as RecommendItemModel);
        uncompleteRecommendItemList.add(item);
      } else {
        fixedBucketList!.completedCustomItemList.remove(item.id);
        fixedBucketList!.uncompletedCustomItemList.add(item.id);

        completeCustomItemList.remove(item as CustomItemModel);
        uncompleteCustomItemList.add(item);
      }
    });
  }

  // 완료 목록에 추가
  void addComplete(ItemModel item) {
    setState(() {
      if (item.runtimeType == RecommendItemModel) {
        fixedBucketList!.completedRecommendItemList.add(item.id);
        fixedBucketList!.uncompletedRecommendItemList.remove(item.id);

        completeRecommendItemList.add(item as RecommendItemModel);
        uncompleteRecommendItemList.remove(item);
      } else {
        fixedBucketList!.completedCustomItemList.add(item.id);
        fixedBucketList!.uncompletedCustomItemList.remove(item.id);

        completeCustomItemList.add(item as CustomItemModel);
        uncompleteCustomItemList.remove(item);
      }
    });
  }

  // 리스트의 각 항목을 구성
  ListItem buildListItem(int index) {
    ItemModel item;

    // 먼저 미완료 목록부터 띄움
    if (index < uncompleteCustomItemList.length) {
      item = uncompleteCustomItemList[index];
    } else if (index <
        uncompleteCustomItemList.length + uncompleteRecommendItemList.length) {
      item =
          uncompleteRecommendItemList[index - uncompleteCustomItemList.length];
    } else if (index <
        uncompleteCustomItemList.length +
            uncompleteRecommendItemList.length +
            completeCustomItemList.length) {
      item = completeCustomItemList[index -
          uncompleteCustomItemList.length -
          uncompleteRecommendItemList.length];
    } else {
      item = completeRecommendItemList[index -
          uncompleteCustomItemList.length -
          uncompleteRecommendItemList.length -
          completeCustomItemList.length];
    }

    final bool isCompleted = index >=
        (uncompleteCustomItemList.length + uncompleteRecommendItemList.length);

    return ListItem(
      // 추천 아이템
      isNeedSelectButton: true,
      isContain: isCompleted,
      isNeedMoreButton: false,
      isHome: true,
      onPressed: () {
        if (isCompleted) {
          removeComplete(item);
          if (item.runtimeType == RecommendItemModel) {
            fixedBucketList!.isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .moveToUncompleted(
                        fixedBucketList!.id, item.id, 'recommend')
                : ref.read(myBucketListListProvider.notifier).moveToUncompleted(
                    fixedBucketList!.id, item.id, 'recommend');
            ref
                .read(recommendBucketListItemProvider.notifier)
                .moveToUncompleted(fixedBucketList!.id, item.id);
          } else {
            fixedBucketList!.isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .moveToUncompleted(fixedBucketList!.id, item.id, 'custom')
                : ref
                    .read(myBucketListListProvider.notifier)
                    .moveToUncompleted(fixedBucketList!.id, item.id, 'custom');
            ref
                .read(customBucketListItemProvider.notifier)
                .moveToUncompleted(fixedBucketList!.id, item.id);
          }
        } else {
          addComplete(item);
          if (item.runtimeType == RecommendItemModel) {
            fixedBucketList!.isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .moveToCompleted(fixedBucketList!.id, item.id, 'recommend')
                : ref
                    .read(myBucketListListProvider.notifier)
                    .moveToCompleted(fixedBucketList!.id, item.id, 'recommend');
            ref
                .read(recommendBucketListItemProvider.notifier)
                .moveToCompleted(fixedBucketList!.id, item.id);
          } else {
            fixedBucketList!.isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .moveToCompleted(fixedBucketList!.id, item.id, 'custom')
                : ref
                    .read(myBucketListListProvider.notifier)
                    .moveToCompleted(fixedBucketList!.id, item.id, 'custom');
            ref
                .read(customBucketListItemProvider.notifier)
                .moveToCompleted(fixedBucketList!.id, item.id);
          }
        }
      },
      item: item,
    );
  }
}

class _RegionImageContainer extends ConsumerWidget {
  const _RegionImageContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> recommendRegion = ref.watch(recommmendRegionProvider);

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16),
        alignment: Alignment.center,
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFD9D9D9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: recommendRegion.isNotEmpty
              ? [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '오늘 ${recommendRegion['region']} 어때요?',
                        style: const TextStyle(
                            fontFamily: 'SCDream',
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                        icon: const Icon(Remix.repeat_2_line, size: 20),
                        splashRadius: 20,
                        splashColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(
                            minHeight: 25,
                            minWidth: 25,
                            maxHeight: 25,
                            maxWidth: 25),
                        onPressed: () async {
                          ref
                              .read(recommmendRegionProvider.notifier)
                              .getRegionData();
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(recommendRegion['images'].length,
                        (index) {
                      return SizedBox(
                        width: 90,
                        child: Column(
                          children: [
                            Image.network(
                              recommendRegion['images'][index],
                              fit: BoxFit.cover,
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              recommendRegion['titles'][index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: BLACK_COLOR,
                                  fontFamily: 'SCDream',
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ]
              : [
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                ],
        ));
  }
}