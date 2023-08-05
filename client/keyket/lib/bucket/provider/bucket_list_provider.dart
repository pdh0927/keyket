import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

abstract class BucketListNotifier extends StateNotifier<List<BucketListModel>> {
  BucketListNotifier(bool isShared) : super([]) {
    getBucketList(isShared);
  }

  void getBucketList(bool isShared) async {
    List<BucketListModel> bucketList = [];

    try {
      Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
      query = query.where('users', arrayContains: 'dh');
      query = query.where('isShared', isEqualTo: isShared);

      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        data['completedCustomItemList'] = data['completedCustomItemList'] ?? [];
        data['completedRecommendItemList'] =
            data['completedRecommendItemList'] ?? [];
        data['customItemList'] = data['customItemList'] ?? [];
        data['recommendItemList'] = data['recommendItemList'] ?? [];

        bucketList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = bucketList;
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

  double getAchievementRate(String bucketListId) {
    final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
    int complementedCount = bucketList.completedCustomItemList.length +
        bucketList.completedRecommendItemList.length;
    int uncomplementedCount =
        bucketList.customItemList.length + bucketList.recommendItemList.length;

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
      return List.from(bucket.recommendItemList);
    } else {
      return List.from(bucket.customItemList);
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
  MyBucketListNotifier() : super(false);
}

class SharedBucketListNotifier extends BucketListNotifier {
  SharedBucketListNotifier() : super(true);
}

final myBucketListListProvider =
    StateNotifierProvider<MyBucketListNotifier, List<BucketListModel>>((ref) {
  return MyBucketListNotifier();
});

final sharedBucketListListProvider =
    StateNotifierProvider<SharedBucketListNotifier, List<BucketListModel>>(
        (ref) {
  return SharedBucketListNotifier();
});

// final myBucketListListProvider =
//     StateNotifierProvider<MyBucketListNotifier, List<BucketListModel>>((ref) {
//   return MyBucketListNotifier();
// }); // class를 privider로

// class MyBucketListNotifier extends StateNotifier<List<BucketListModel>> {
//   MyBucketListNotifier() : super([]) {
//     getMyBucketList();
//   }

//   void getMyBucketList() async {
//     List<BucketListModel> myBucketListList = [];

//     try {
//       Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
//       query = query.where('users', arrayContains: 'dh');
//       query = query.where('isShared', isEqualTo: false);

//       QuerySnapshot<Map<String, dynamic>> docList = await query.get();

//       for (var doc in docList.docs) {
//         Map<String, dynamic> data = _docToMap(doc);

//         // null이 있다면 []로 저장
//         data['completedCustomItemList'] = data['completedCustomItemList'] ?? [];
//         data['completedRecommendItemList'] =
//             data['completedRecommendItemList'] ?? [];
//         data['customItemList'] = data['customItemList'] ?? [];
//         data['recommendItemList'] = data['recommendItemList'] ?? [];

//         myBucketListList.add(BucketListModel.fromJson(data));
//       }
//     } catch (e) {
//       print(e);
//     }

//     state = myBucketListList;
//   }

//   // 버킷리시트 업데이트
//   void updateBucketList(BucketListModel updatedBucketList) {
//     state = [
//       for (final bucketList in state)
//         if (bucketList.id == updatedBucketList.id)
//           updatedBucketList
//         else
//           bucketList
//     ];
//   }

//   double getAchievementRate(String bucketListId) {
//     final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
//     int complementedCount = bucketList.completedCustomItemList.length +
//         bucketList.completedRecommendItemList.length;
//     int uncomplementedCount =
//         bucketList.customItemList.length + bucketList.recommendItemList.length;

//     return (complementedCount) / (uncomplementedCount + complementedCount);
//   }

//   void sortByName() {
//     state.sort((a, b) => a.name.compareTo(b.name));
//     state = List.from(state);
//   }

//   void sortByCreatedAt() {
//     state.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신 날짜가 먼저 오도록
//     state = List.from(state);
//   }

//   void sortByUpdatedAt() {
//     state.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // 최신 업데이트가 먼저 오도록
//     state = List.from(state);
//   }

//   List<String> getCompleteList(String type, String bucketListId) {
//     final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
//     if (type == 'recommend') {
//       return List.from(bucket.completedRecommendItemList);
//     } else {
//       return List.from(bucket.completedCustomItemList);
//     }
//   }

//   List<String> getContainList(String type, String bucketListId) {
//     final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
//     if (type == 'recommend') {
//       return List.from(bucket.recommendItemList);
//     } else {
//       return List.from(bucket.customItemList);
//     }
//   }

//   BucketListModel getBucketListModel(String bucketListId) {
//     final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
//     return bucketList.deepCopy();
//   }

//   void changeBucketListModel(
//       String bucketListId, BucketListModel newBucketListModel) {
//     state = [
//       for (final item in state)
//         if (item.id == bucketListId) newBucketListModel.deepCopy() else item,
//     ];
//   }
// }

// final sharedBucketListListProvider =
//     StateNotifierProvider<SharedBucketListNotifier, List<BucketListModel>>(
//         (ref) {
//   return SharedBucketListNotifier();
// }); // class를 privider로

// class SharedBucketListNotifier extends StateNotifier<List<BucketListModel>> {
//   SharedBucketListNotifier() : super([]) {
//     getSharedBucketList();
//   }

//   void getSharedBucketList() async {
//     List<BucketListModel> myBucketListList = [];

//     try {
//       Query<Map<String, dynamic>> query = firestore.collection('bucket_list');
//       query = query.where('users', arrayContains: 'dh');
//       query = query.where('isShared', isEqualTo: true);

//       QuerySnapshot<Map<String, dynamic>> docList = await query.get();

//       for (var doc in docList.docs) {
//         Map<String, dynamic> data = _docToMap(doc);

//         // null이 있다면 []로 저장
//         data['completedCustomItemList'] = data['completedCustomItemList'] ?? [];
//         data['completedRecommendItemList'] =
//             data['completedRecommendItemList'] ?? [];
//         data['customItemList'] = data['customItemList'] ?? [];
//         data['recommendItemList'] = data['recommendItemList'] ?? [];

//         myBucketListList.add(BucketListModel.fromJson(data));
//       }
//     } catch (e) {
//       print(e);
//     }

//     state = myBucketListList;
//   }

//   // 버킷리시트 업데이트
//   void updateBucketList(BucketListModel updatedBucketList) {
//     state = [
//       for (final bucketList in state)
//         if (bucketList.id == updatedBucketList.id)
//           updatedBucketList
//         else
//           bucketList
//     ];
//   }

//   double getAchievementRate(String bucketListId) {
//     final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
//     int complementedCount = bucketList.completedCustomItemList.length +
//         bucketList.completedRecommendItemList.length;
//     int uncomplementedCount =
//         bucketList.customItemList.length + bucketList.recommendItemList.length;

//     return (complementedCount) / (uncomplementedCount + complementedCount);
//   }

//   void sortByName() {
//     state.sort((a, b) => a.name.compareTo(b.name));
//     state = List.from(state);
//   }

//   void sortByCreatedAt() {
//     state.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신 날짜가 먼저 오도록
//     state = List.from(state);
//   }

//   void sortByUpdatedAt() {
//     state.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // 최신 업데이트가 먼저 오도록
//     state = List.from(state);
//   }

//   List<String> getCompleteList(String type, String bucketListId) {
//     final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
//     if (type == 'recommend') {
//       return List.from(bucket.completedRecommendItemList);
//     } else {
//       return List.from(bucket.completedCustomItemList);
//     }
//   }

//   List<String> getContainList(String type, String bucketListId) {
//     final bucket = state.firstWhere((bucket) => bucket.id == bucketListId);
//     if (type == 'recommend') {
//       return List.from(bucket.recommendItemList);
//     } else {
//       return List.from(bucket.customItemList);
//     }
//   }

//   BucketListModel getBucketListModel(String bucketListId) {
//     final bucketList = state.firstWhere((bucket) => bucket.id == bucketListId);
//     return bucketList.deepCopy();
//   }

//   void changeBucketListModel(
//       String bucketListId, BucketListModel newBucketListModel) {
//     state = [
//       for (final item in state)
//         if (item.id == bucketListId) newBucketListModel.deepCopy() else item,
//     ];
//   }
// }

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
