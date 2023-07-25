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
            const SizedBox(height: 200),
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
                testReference('acaagF1vSB2wJ4SYcSDd');
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

    List<Map<String, dynamic>> bucketListItems = [
      {
        'id': 'dh',
        'name': 'in 20대',
        'image': '',
        'achievementRate': 0.2,
        'isShared': false,
        'users': ['dh'],
        'createdAt': DateTime(2023, 1, 1),
        'updatedAt': DateTime(2023, 1, 2),
        'completedCustomItemList': [],
        'completedRecommendItemList': [],
        'customItemList': [],
        'recommendItemList': [],
      },
      {
        'id': 'dh',
        'name': 'frieds',
        'image': '',
        'achievementRate': 0.72,
        'isShared': false,
        'users': ['dh', 'sj'],
        'createdAt': DateTime(2023, 4, 2),
        'updatedAt': DateTime(2023, 5, 2),
        'completedCustomItemList': [],
        'completedRecommendItemList': [],
        'customItemList': [],
        'recommendItemList': [],
      },
      {
        'id': 'dh',
        'name': 'family',
        'image': '',
        'achievementRate': 0.52,
        'isShared': false,
        'users': ['dh', 'sj'],
        'createdAt': DateTime(2023, 1, 23),
        'updatedAt': DateTime(2023, 3, 2),
        'completedCustomItemList': [],
        'completedRecommendItemList': [],
        'customItemList': [],
        'recommendItemList': [],
      },
    ];
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var item in bucketListItems) {
      // Create a new document reference
      DocumentReference ref =
          FirebaseFirestore.instance.collection('bucket_list').doc();
      // Add this item to the batch
      batch.set(ref, item);
    }

// Commit the batch
    await batch.commit().then((value) {
      print('Batch write completed successfully.');
    }).catchError((error) {
      print('Error in batch write: $error');
    });

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

  Future<void> testReference(String bucketListItem) async {
    DocumentReference docRef =
        firestore.collection('bucket_list_item').doc(bucketListItem);
    DocumentSnapshot bucketListItemDoc = await docRef.get();

    List<String> customItemList =
        List<String>.from(bucketListItemDoc['customItemList']);
    List<String> recommendItemList =
        List<String>.from(bucketListItemDoc['recommendItemList']);

    // customItemList를 불러옵니다.
    QuerySnapshot customItemDocs = await firestore
        .collection('custom')
        .where(FieldPath.documentId, whereIn: customItemList)
        .get();
    for (DocumentSnapshot customItemDoc in customItemDocs.docs) {
      print('Custom content: ${customItemDoc['content']}');
    }

    // recommendItemList를 불러옵니다.
    QuerySnapshot recommendItemDocs = await firestore
        .collection('recommend')
        .where(FieldPath.documentId, whereIn: recommendItemList)
        .get();
    for (DocumentSnapshot recommendItemDoc in recommendItemDocs.docs) {
      print('Recommend content: ${recommendItemDoc['content']}');
    }
  }
}
