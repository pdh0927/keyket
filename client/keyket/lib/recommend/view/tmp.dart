import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class Tmp extends StatefulWidget {
  const Tmp({super.key});

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('추천 임시 페이지임'),
            ElevatedButton(
              onPressed: () {
                saveData();
              },
              child: Text('saveData function'),
            ),
            ElevatedButton(
              onPressed: () {
                getRecommendData()();
              },
              child: Text('getRecommendData function'),
            ),
            ElevatedButton(
              onPressed: () {
                testReference('4M9cJT2swqL2ZASwBpqI');
              },
              child: Text('testreference call function'),
            ),
          ],
        ),
      ),
    );
  }

  saveData() async {
    // List<Map<String, dynamic>> recommendedItems = [
    //   {
    //     'content': 'tes123t',
    //     'region': 'seoul',
    //     'theme': ['healing', 'activity']
    //   },
    //   {
    //     'content': 'test1123',
    //     'region': 'daegu',
    //     'theme': ['healing']
    //   }
    // ];
    // for (var item in recommendedItems) {
    //   await firestore.collection('recommend').add(item);
    // }

    //   List<Map<String, dynamic>> bucketListItems = [
    //     {
    //       'id': 'dh',
    //       'name': 'in 20대',
    //       'image': '',
    //       'achievementRate': 0.2,
    //       'isShared': false,
    //       'users': ['dh'],
    //       'createdAt': DateTime(2023, 1, 1),
    //       'updatedAt': DateTime(2023, 1, 2)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'frieds',
    //       'image': '',
    //       'achievementRate': 0.72,
    //       'isShared': true,
    //       'users': ['dh', 'sj'],
    //       'createdAt': DateTime(2023, 4, 2),
    //       'updatedAt': DateTime(2023, 5, 2)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'family',
    //       'image': '',
    //       'achievementRate': 0.52,
    //       'isShared': true,
    //       'users': ['dh', 'sj'],
    //       'createdAt': DateTime(2023, 1, 23),
    //       'updatedAt': DateTime(2023, 3, 2)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'school',
    //       'image': '',
    //       'achievementRate': 0.34,
    //       'isShared': true,
    //       'users': ['dh', 'sj'],
    //       'createdAt': DateTime(2023, 5, 5),
    //       'updatedAt': DateTime(2023, 6, 2)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'in 20대',
    //       'image': '',
    //       'achievementRate': 0.3,
    //       'isShared': false,
    //       'users': ['dh', 'sj'],
    //       'createdAt': DateTime(2023, 5, 1),
    //       'updatedAt': DateTime(2023, 7, 8)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'in 20대',
    //       'image': '',
    //       'achievementRate': 0.44,
    //       'isShared': false,
    //       'users': ['dh'],
    //       'createdAt': DateTime(2023, 1, 1),
    //       'updatedAt': DateTime(2023, 1, 6)
    //     },
    //     {
    //       'id': 'dh',
    //       'name': 'in 20대',
    //       'image': '',
    //       'achievementRate': 0.55,
    //       'isShared': false,
    //       'users': ['dh', 'sj'],
    //       'createdAt': DateTime(2023, 2, 1),
    //       'updatedAt': DateTime(2023, 4, 2)
    //     },
    //   ];
    //   for (var item in bucketListItems) {
    //     await firestore.collection('bucket_list').add(item);
    //   }
    // }

    // print(result);
    // }

    // updateData() async {
    //   var result = await firestore.collection('recommend').doc({id}).update({});
    // }

    // deleteData() async {
    //   var result = await firestore.collection('recommend').doc({id}).delete();
  }

  getRecommendData() async {
    // var one_result = await firestore
    //     .collection('recommend')
    //     .doc('8Xeyk8hiF8m00THpT3dq')
    //     .get();
    // print(one_result['content']);
    // print(one_result['region']);
    // print(one_result['theme']);

    // try {
    //   var all_result = await firestore.collection('recommend').get();

    //   print(all_result);
    //   print(all_result.docs);
    //   for (var doc in all_result.docs) {
    //     print(doc['content']);
    //     print(doc['region']);
    //     print(doc['theme']);
    //     print(doc.data().runtimeType);
    //   }
    // } catch (e) {
    //   print(e);
    // }

    // var wanted_result = await firestore
    //     .collection('recommend')
    //     .where('region', isEqualTo: 'seoul')
    //     .get();
    // print('wanted_result');
    // for (var doc in wanted_result.docs) {
    //   print(doc['content']);
    //   print(doc['region']);
    //   print(doc['theme']);
    // }
  }

  Future<void> testReference(String bucketListId) async {
    // Get the bucket list document.
    DocumentSnapshot bucketListDoc = await FirebaseFirestore.instance
        .collection('bucket_list')
        .doc(bucketListId)
        .get();

    // Read the bucket list item reference.
    DocumentReference bucketListItemRef = bucketListDoc['bucket_list_item'];

    // Fetch the bucket list item data.
    DocumentSnapshot bucketListItemDoc = await bucketListItemRef.get();

    // Get the customItemList and recommendItemList arrays.
    List<DocumentReference> customItemListRefs =
        List<DocumentReference>.from(bucketListItemDoc['customItemList']);
    List<DocumentReference> recommendItemListRefs =
        List<DocumentReference>.from(bucketListItemDoc['recommendItemList']);

    // Load the data for each custom item and recommend item.
    List<DocumentSnapshot> customItemList = [];
    List<DocumentSnapshot> recommendItemList = [];

    for (DocumentReference itemRef in customItemListRefs) {
      DocumentSnapshot itemDoc = await itemRef.get();
      customItemList.add(itemDoc);
    }

    for (DocumentReference itemRef in recommendItemListRefs) {
      DocumentSnapshot itemDoc = await itemRef.get();
      recommendItemList.add(itemDoc);
    }

// Print data of each item in the customItemList
    for (var item in customItemList) {
      print(item.data());
    }

// Print data of each item in the recommendItemList
    for (var item in recommendItemList) {
      print(item.data());
    }
    // Now, customItemList and recommendItemList contain the data for each item.
    // You can process this data as needed.
  }
}
