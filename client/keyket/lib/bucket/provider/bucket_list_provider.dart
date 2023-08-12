import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyket/common/provider/my_provider.dart';

final firestore = FirebaseFirestore.instance;

abstract class BucketListNotifier extends StateNotifier<List<BucketListModel>> {
  BucketListNotifier(String userId, bool isShared) : super([]) {
    getBucketList(userId, isShared);
  }

  void getBucketList(String userId, bool isShared) async {
    List<BucketListModel> bucketList = [];

    try {
      Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
      query = query.where('users', arrayContains: userId);
      query = query.where('isShared', isEqualTo: isShared);

      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        data['completedCustomItemList'] = data['completedCustomItemList'] ?? [];
        data['completedRecommendItemList'] =
            data['completedRecommendItemList'] ?? [];
        data['uncompletedCustomItemList'] =
            data['uncompletedCustomItemList'] ?? [];
        data['uncompletedRecommendItemList'] =
            data['uncompletedRecommendItemList'] ?? [];

        bucketList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = bucketList;
  }

  void addNewBucket(Map<String, dynamic> bucketData) async {
    try {
      // Firestore에 새로운 bucket 추가
      DocumentReference<Map<String, dynamic>> documentRef =
          await firestore.collection('bucket_list').add(bucketData);

      // Firestore에서 부여된 ID를 모델에 설정
      bucketData['id'] = documentRef.id;
      bucketData['createdAt'] = bucketData['createdAt'].toString();
      bucketData['updatedAt'] = bucketData['updatedAt'].toString();

      BucketListModel addedBucket = BucketListModel.fromJson(bucketData);

      // State에 추가된 bucket 추가
      state = [...state, addedBucket];
    } catch (e) {
      print(e);
    }
  }

  // 버킷리시트 업데이트
  void updateBucketList(BucketListModel updatedBucketList) {
    state = [
      for (final bucketList in state)
        if (bucketList.id == updatedBucketList.id)
          updatedBucketList
        else
          bucketList
    ];
  }

  void updateRecommendItems(String bucketListId, List<String> ids) async {
    final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);

    final Set<String> currentCompleted =
        bucketList.completedRecommendItemList.toSet();
    final Set<String> currentUncompleted =
        bucketList.uncompletedRecommendItemList.toSet();
    final Set<String> newIds = ids.toSet();

    // complete에서 삭제되어야 할 항목 찾기
    currentCompleted.retainAll(newIds);

    // uncomplete에서 삭제되어야 할 항목 찾기
    currentUncompleted.retainAll(newIds);

    // 새롭게 추가되어야 할 항목 찾기
    newIds.removeAll(currentCompleted);
    newIds.removeAll(currentUncompleted);

    currentUncompleted.addAll(newIds); // 새롭게 추가된 항목들은 uncompleted에 추가

    // 업데이트된 리스트로 BucketListModel 생성
    BucketListModel updatedBucket = BucketListModel(
      id: bucketList.id,
      name: bucketList.name,
      image: bucketList.image,
      host: bucketList.host,
      isShared: bucketList.isShared,
      users: bucketList.users,
      createdAt: bucketList.createdAt,
      updatedAt: DateTime.now(),
      uncompletedCustomItemList: bucketList.uncompletedCustomItemList,
      uncompletedRecommendItemList: currentUncompleted.toList(),
      completedCustomItemList: bucketList.completedCustomItemList,
      completedRecommendItemList: currentCompleted.toList(),
    );

    // state 업데이트
    updateBucketList(updatedBucket);

    // Firestore bucket_list에 업데이트
    try {
      await firestore.collection('bucket_list').doc(bucketListId).update({
        'completedRecommendItemList': currentCompleted.toList(),
        'uncompletedRecommendItemList': currentUncompleted.toList(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print("Firestore 업데이트 에러: $e");
    }
  }

  // 버킷리스트 모델로 버킷리스트 추가
  void addBucketList(BucketListModel newBucket) async {
    // State에 추가된 bucket 아이템 추가
    state = [...state, newBucket];
  }

  // 아이디로 버킷리스트 삭제
  void deleteBucketList(String bucketListId) async {
    // State에서 해당 bucket리스트 삭제
    state = state.where((bucket) => bucket.id != bucketListId).toList();
  }

  double getAchievementRate(String bucketListId) {
    final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
    int complementedCount = bucketList.completedCustomItemList.length +
        bucketList.completedRecommendItemList.length;
    int uncomplementedCount = bucketList.uncompletedCustomItemList.length +
        bucketList.uncompletedRecommendItemList.length;

    return (complementedCount) / (uncomplementedCount + complementedCount);
  }

  void sortByName() {
    state.sort((a, b) => a.name.compareTo(b.name));
    state = List.from(state);
  }

  void sortByCreatedAt() {
    state.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신 날짜가 먼저 오도록
    state = List.from(state);
  }

  void sortByUpdatedAt() {
    state.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // 최신 업데이트가 먼저 오도록
    state = List.from(state);
  }

  List<String> getCompleteList(String type, String bucketListId) {
    final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
    if (type == 'recommend') {
      return List.from(bucket.completedRecommendItemList);
    } else {
      return List.from(bucket.completedCustomItemList);
    }
  }

  List<String> getContainList(String type, String bucketListId) {
    final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
    if (type == 'recommend') {
      return List.from(bucket.uncompletedRecommendItemList);
    } else {
      return List.from(bucket.uncompletedCustomItemList);
    }
  }

  BucketListModel getBucketListModel(String bucketListId) {
    final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
    return bucketList.deepCopy();
  }

  void changeBucketListModel(
      String bucketListId, BucketListModel newBucketListModel) {
    state = [
      for (final item in state)
        if (item.id == bucketListId) newBucketListModel.deepCopy() else item,
    ];
  }
}

class MyBucketListNotifier extends BucketListNotifier {
  MyBucketListNotifier(String userId) : super(userId, false);
}

class SharedBucketListNotifier extends BucketListNotifier {
  SharedBucketListNotifier(String userId) : super(userId, true);
}

final myBucketListListProvider =
    StateNotifierProvider<MyBucketListNotifier, List<BucketListModel>>((ref) {
  String userId = ref.read(myInformationProvider)!.id;

  return MyBucketListNotifier(userId);
});

final sharedBucketListListProvider =
    StateNotifierProvider<SharedBucketListNotifier, List<BucketListModel>>(
        (ref) {
  String userId = ref.read(myInformationProvider)!.id;
  return SharedBucketListNotifier(userId);
});

Map<String, dynamic> _docToMap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  Map<String, dynamic> data = doc.data();
  data['id'] = doc.id;

  Timestamp createdAt = data['createdAt'];
  Timestamp updatedAt = data['updatedAt'];

  DateTime createdAtDateTime = createdAt.toDate();
  DateTime updatedAtDateTime = updatedAt.toDate();

  String createdAtString =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtDateTime);
  String updatedAtString =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAtDateTime);

  data['createdAt'] = createdAtString;
  data['updatedAt'] = updatedAtString;

  return data;
}
