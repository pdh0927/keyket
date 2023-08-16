import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyket/common/provider/my_provider.dart';

final firestore = FirebaseFirestore.instance;

abstract class BucketListNotifier
    extends StateNotifier<Map<String, BucketListModel>> {
  BucketListNotifier(String userId, bool isShared) : super({}) {
    getBucketList(userId, isShared);
  }

  void getBucketList(String userId, bool isShared) async {
    Map<String, BucketListModel> bucketListMap = {};

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

        bucketListMap[data['id']] = BucketListModel.fromJson(data);
      }
    } catch (e) {
      print(e);
    }

    state = bucketListMap;
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

      // State에 추가된 bucket 추가
      state[bucketData['id']] = BucketListModel.fromJson(bucketData);
      state = {...state};
    } catch (e) {
      print(e);
    }
  }

  // 버킷리시트 업데이트
  void updateBucketList(BucketListModel updatedBucketList) {
    state[updatedBucketList.id] = updatedBucketList;
  }

  void updateRecommendItems(String bucketListId, List<String> ids) async {
    final bucketList = state[bucketListId];

    if (bucketList == null) {
      print("No bucket found with ID: $bucketListId");
      return;
    }

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
    state[bucketListId] = updatedBucket;

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
    state[newBucket.id] = newBucket;
    state = {...state};
  }

  // 아이디로 버킷리스트 삭제
  void deleteBucketList(String bucketListId) async {
    try {
      // State에서 해당 버킷 리스트 삭제
      state.remove(bucketListId);
      state = {...state};

      // Firebase Firestore에서도 해당 버킷 리스트 삭제
      await firestore.collection('bucket_list').doc(bucketListId).delete();
    } catch (error) {
      print('Error deleting bucket list: $error');
    }
  }

  double getAchievementRate(String bucketListId) {
    final bucketList = state[bucketListId];

    if (bucketList == null) {
      print("No bucket found with ID: $bucketListId");
      return 0;
    }

    int complementedCount = bucketList.completedCustomItemList.length +
        bucketList.completedRecommendItemList.length;
    int uncomplementedCount = bucketList.uncompletedCustomItemList.length +
        bucketList.uncompletedRecommendItemList.length;

    return (complementedCount) / (uncomplementedCount + complementedCount);
  }

  void sortByName() {
    var sortedList = state.values.toList();
    sortedList.sort((a, b) => a.name.compareTo(b.name));
    state = {for (var item in sortedList) item.id: item};
  }

  void sortByCreatedAt() {
    var sortedList = state.values.toList();
    sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = {for (var item in sortedList) item.id: item};
  }

  void sortByUpdatedAt() {
    var sortedList = state.values.toList();
    sortedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = {for (var item in sortedList) item.id: item};
  }

  List<String> getCompleteList(String type, String bucketListId) {
    final bucket = state[bucketListId];

    if (bucket == null) {
      print("No bucket found with ID: $bucketListId");
      return [];
    }

    if (type == 'recommend') {
      return List.from(bucket.completedRecommendItemList);
    } else {
      return List.from(bucket.completedCustomItemList);
    }
  }

  List<String> getContainList(String type, String bucketListId) {
    final bucket = state[bucketListId];

    if (bucket == null) {
      print("No bucket found with ID: $bucketListId");
      return [];
    }

    if (type == 'recommend') {
      return List.from(bucket.uncompletedRecommendItemList);
    } else {
      return List.from(bucket.uncompletedCustomItemList);
    }
  }

  BucketListModel? getBucketListModel(String bucketListId) {
    final bucketList = state[bucketListId];

    if (bucketList == null) {
      print("No bucket found with ID: $bucketListId");
      return null;
    }

    return bucketList.deepCopy();
  }

  void changeBucketListModel(
      String bucketListId, BucketListModel newBucketListModel) {
    state[bucketListId] = newBucketListModel.deepCopy();
    state = {...state};
  }

  void moveToCompleted(String bucketListId, String itemId, String itemType) {
    final bucketList = state[bucketListId];
    if (bucketList == null) {
      print("No bucket found with ID: $bucketListId");
      return;
    }

    if (itemType == 'recommend') {
      if (bucketList.uncompletedRecommendItemList.contains(itemId)) {
        bucketList.uncompletedRecommendItemList.remove(itemId);
        bucketList.completedRecommendItemList.add(itemId);

        // Firestore에서 bucket_list 데이터 업데이트
        firestore.collection('bucket_list').doc(bucketListId).update({
          'completedRecommendItemList': bucketList.completedRecommendItemList,
          'uncompletedRecommendItemList':
              bucketList.uncompletedRecommendItemList,
        });
      } else {
        print("Item not found in uncompleted Recommend list");
        return;
      }
    } else if (itemType == 'custom') {
      if (bucketList.uncompletedCustomItemList.contains(itemId)) {
        bucketList.uncompletedCustomItemList.remove(itemId);
        bucketList.completedCustomItemList.add(itemId);

        firestore.collection('bucket_list').doc(bucketListId).update({
          'completedCustomItemList': bucketList.completedCustomItemList,
          'uncompletedCustomItemList': bucketList.uncompletedCustomItemList,
        });
      } else {
        print("Item not found in uncompleted Custom list");
        return;
      }
    } else {
      print("Unknown itemType: $itemType");
      return;
    }

    state[bucketListId] = bucketList; // state 업데이트
  }

  void moveToUncompleted(String bucketListId, String itemId, String itemType) {
    final bucketList = state[bucketListId];
    if (bucketList == null) {
      print("No bucket found with ID: $bucketListId");
      return;
    }

    if (itemType == 'recommend') {
      if (bucketList.completedRecommendItemList.contains(itemId)) {
        bucketList.completedRecommendItemList.remove(itemId);
        bucketList.uncompletedRecommendItemList.add(itemId);

        // Firestore에서 bucket_list 데이터 업데이트
        firestore.collection('bucket_list').doc(bucketListId).update({
          'completedRecommendItemList': bucketList.completedRecommendItemList,
          'uncompletedRecommendItemList':
              bucketList.uncompletedRecommendItemList,
        });
      } else {
        print("Item not found in completed Recommend list");
        return;
      }
    } else if (itemType == 'custom') {
      if (bucketList.completedCustomItemList.contains(itemId)) {
        bucketList.completedCustomItemList.remove(itemId);
        bucketList.uncompletedCustomItemList.add(itemId);

        // Firestore에서 bucket_list 데이터 업데이트
        firestore.collection('bucket_list').doc(bucketListId).update({
          'completedCustomItemList': bucketList.completedCustomItemList,
          'uncompletedCustomItemList': bucketList.uncompletedCustomItemList,
        });
      } else {
        print("Item not found in completed Custom list");
        return;
      }
    } else {
      print("Unknown itemType: $itemType");
      return;
    }

    state[bucketListId] = bucketList; // state 업데이트
  }
}

class MyBucketListNotifier extends BucketListNotifier {
  MyBucketListNotifier(String userId) : super(userId, false);
}

class SharedBucketListNotifier extends BucketListNotifier {
  SharedBucketListNotifier(String userId) : super(userId, true);
}

final myBucketListListProvider =
    StateNotifierProvider<MyBucketListNotifier, Map<String, BucketListModel>>(
        (ref) {
  String userId = ref.read(myInformationProvider)!.id;

  return MyBucketListNotifier(userId);
});

final sharedBucketListListProvider = StateNotifierProvider<
    SharedBucketListNotifier, Map<String, BucketListModel>>((ref) {
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
