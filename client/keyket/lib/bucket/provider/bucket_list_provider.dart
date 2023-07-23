import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
Query<Map<String, dynamic>> query = firestore.collection('bucket_list');

final myBucketListListProvider =
    StateNotifierProvider<MyBucketListNotifier, List<BucketListModel>>((ref) {
  return MyBucketListNotifier();
}); // class를 privider로

class MyBucketListNotifier extends StateNotifier<List<BucketListModel>> {
  MyBucketListNotifier() : super([]) {
    getMyBucketListdData();
  }

  void getMyBucketListdData() async {
    List<BucketListModel> myBucketListList = [];

    try {
      Query<Map<String, dynamic>> myQuery;
      myQuery = query.where('users', arrayContains: 'dh');
      myQuery = myQuery.where('isShared', isEqualTo: false);

      QuerySnapshot<Map<String, dynamic>> docList = await myQuery.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        myBucketListList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = myBucketListList;
  }
}

final sharedBucketListListProvider =
    StateNotifierProvider<SharedBucketListNotifier, List<BucketListModel>>(
        (ref) {
  return SharedBucketListNotifier();
}); // class를 privider로

class SharedBucketListNotifier extends StateNotifier<List<BucketListModel>> {
  SharedBucketListNotifier() : super([]) {
    getSharedBucketListdData();
  }

  void getSharedBucketListdData() async {
    List<BucketListModel> sharedBucketListList = [];

    try {
      Query<Map<String, dynamic>> sharedQuery;
      sharedQuery = query.where('users', arrayContains: 'dh');
      sharedQuery = sharedQuery.where('isShared', isEqualTo: true);

      QuerySnapshot<Map<String, dynamic>> docList = await sharedQuery.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = _docToMap(doc);

        sharedBucketListList.add(BucketListModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = sharedBucketListList;
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
