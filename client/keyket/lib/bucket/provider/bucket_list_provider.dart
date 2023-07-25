import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';

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

final bucketListItemProvider =
    StateNotifierProvider<BucketListItemNotifier, Map<String, dynamic>>((ref) {
  return BucketListItemNotifier();
});

class BucketListItemNotifier extends StateNotifier<Map<String, dynamic>> {
  BucketListItemNotifier() : super({}) {}

  void getItems(String id, List<String> customItemList,
      List<String> recommendItemList) async {
    List<Item> itemList = [];

    try {
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
          itemList.add(CustomItemModel.fromJson(data));
        }
      }

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

          itemList.add(RecommendItemModel.fromJson(data));
        }
      }

      // 상태 갱신
      state = {...state, id: itemList};
      print(state);
    } catch (e) {
      print(e);
    }
  }
}
