import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

final myBucketListListProvider =
    StateNotifierProvider<MyBucketListNotifier, List<BucketListModel>>((ref) {
  return MyBucketListNotifier();
}); // class를 privider로

class MyBucketListNotifier extends StateNotifier<List<BucketListModel>> {
  MyBucketListNotifier() : super([]) {
    getMyBucketList();
  }

  void getMyBucketList() async {
    List<BucketListModel> myBucketListList = [];

    try {
      Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
      query = query.where('users', arrayContains: 'dh');
      query = query.where('isShared', isEqualTo: false);

      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        myBucketListList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = myBucketListList;
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
      return List.from(bucket.recommendItemList);
    } else {
      return List.from(bucket.customItemList);
    }
  }

  BucketListModel getBucketListModel(String bucketListId) {
    final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
    return bucketList.deepCopy();
  }

  void addComplete(String type, String bucketId, String itemId) async {
    // DocumentReference bucketRef =
    //     firestore.collection('bucket_list').doc(bucketId);

    if (type == 'recommend') {
      int index = state.indexWhere((bucket) => bucket.id == bucketId);
      if (index != -1) {
        // 기존 BucketListModel 객체를 복사하고 completedRecommendItemList에 itemId를 추가하는 새로운 객체를 생성합니다.
        BucketListModel updatedBucket = state[index].copyWith(
          completedRecommendItemList:
              List<String>.from(state[index].completedRecommendItemList)
                ..add(itemId),
        );

        // 새로운 BucketListModel 객체를 포함하는 새로운 상태 리스트를 생성합니다.
        state = List<BucketListModel>.from(state)..[index] = updatedBucket;

        // try {
        //   await bucketRef.update({
        //     'completedRecommendItemList': FieldValue.arrayUnion([itemId]),
        //   });
        // } catch (e) {
        //   print(e);
        // }
      }
    } else {
      int index = state.indexWhere((bucket) => bucket.id == bucketId);
      if (index != -1) {
        // 기존 BucketListModel 객체를 복사하고 completedCustomItemList에 itemId를 추가하는 새로운 객체를 생성합니다.
        BucketListModel updatedBucket = state[index].copyWith(
          completedCustomItemList:
              List<String>.from(state[index].completedCustomItemList)
                ..add(itemId),
        );

        // 새로운 BucketListModel 객체를 포함하는 새로운 상태 리스트를 생성합니다.
        state = List<BucketListModel>.from(state)..[index] = updatedBucket;

        // // firestore에 추가
        // try {
        //   await bucketRef.update({
        //     'completedCustomItemList': FieldValue.arrayUnion([itemId]),
        //   });
        // } catch (e) {
        //   print(e);
        // }
      }
    }
  }

  void removeComplete(String type, String bucketId, String itemId) async {
    // DocumentReference bucketRef =
    //     firestore.collection('bucket_list').doc(bucketId);

    if (type == 'recommend') {
      int index = state.indexWhere((bucket) => bucket.id == bucketId);
      if (index != -1) {
        // 기존 BucketListModel 객체를 복사하고 completedCustomItemList에 itemId를 추가하는 새로운 객체를 생성합니다.
        BucketListModel updatedBucket = state[index].copyWith(
          completedRecommendItemList:
              List<String>.from(state[index].completedRecommendItemList)
                ..remove(itemId),
        );

        // 새로운 BucketListModel 객체를 포함하는 새로운 상태 리스트를 생성합니다.
        state = List<BucketListModel>.from(state)..[index] = updatedBucket;

        // firestore에 추가
        // try {
        //   await bucketRef.update({
        //     'completedRecommendItemList': FieldValue.arrayRemove([itemId]),
        //   });
        // } catch (e) {
        //   print(e);
        // }
      }
    } else {
      int index = state.indexWhere((bucket) => bucket.id == bucketId);
      if (index != -1) {
        // 기존 BucketListModel 객체를 복사하고 completedCustomItemList에 itemId를 추가하는 새로운 객체를 생성합니다.
        BucketListModel updatedBucket = state[index].copyWith(
          completedCustomItemList:
              List<String>.from(state[index].completedCustomItemList)
                ..remove(itemId),
        );

        // 새로운 BucketListModel 객체를 포함하는 새로운 상태 리스트를 생성합니다.
        state = List<BucketListModel>.from(state)..[index] = updatedBucket;

        // firestore에 제거
        // try {
        //   await bucketRef.update({
        //     'completedCustomItemList': FieldValue.arrayRemove([itemId]),
        //   });
        // } catch (e) {
        //   print(e);
        // }
      }
    }
  }
}

final sharedBucketListListProvider =
    StateNotifierProvider<SharedBucketListNotifier, List<BucketListModel>>(
        (ref) {
  return SharedBucketListNotifier();
}); // class를 privider로

class SharedBucketListNotifier extends StateNotifier<List<BucketListModel>> {
  SharedBucketListNotifier() : super([]) {
    getSharedBucketListd();
  }

  void getSharedBucketListd() async {
    List<BucketListModel> sharedBucketListList = [];

    try {
      Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
      query = query.where('users', arrayContains: 'dh');
      query = query.where('isShared', isEqualTo: true);

      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        sharedBucketListList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = sharedBucketListList;
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
}

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

final bucketListItemListProvider =
    StateNotifierProvider<BucketListItemNotifier, Map<String, dynamic>>((ref) {
  return BucketListItemNotifier();
});

class BucketListItemNotifier extends StateNotifier<Map<String, dynamic>> {
  BucketListItemNotifier() : super({});
}

final bucketListChangeProvider =
    StateNotifierProvider<BucketListChangeNotifier, Map<String, dynamic>>(
        (ref) {
  return BucketListChangeNotifier();
});

class BucketListChangeNotifier extends StateNotifier<Map<String, dynamic>> {
  BucketListChangeNotifier() : super({});
}

// completeCutomAddList, completeCutomRemoveList, completeRecommendAddList, completeRecommendRemoveList에 추가 // 이렇게나 아니면 마지막에 초기 리스트와 비교해서 뺄건빼고 더할건 더하고
// 새로 생성은 newCustomList, newRecommendList에 추가
// 새로 추가된놈들이 complete된지는 따로 List 관리

// 새로 custom 항목 추가하고
// Id가지고 와서 complete라면 list에 추가
// complete 바뀐거 바탕으로 update

// 새로 recommend 추가라면 recommendlist 업데이트
// complete 바뀐거 바탕으로 update

// Item provider에서 옮기기