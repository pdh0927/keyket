import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/model/kakao_login_model.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/common/view/login_screen.dart';
import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

final firestore = FirebaseFirestore.instance;

class Tmp extends ConsumerStatefulWidget {
  const Tmp({super.key});

  @override
  ConsumerState<Tmp> createState() => _TmpState();
}

class _TmpState extends ConsumerState<Tmp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = MainViewModel(KaKaoLoginModel());

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
            ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                },
                child: Text('login')),
            ElevatedButton(
              onPressed: () async {
                viewModel.logout();
              },
              child: Text('logout'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(recommendItemListProvider.notifier).getRecommendData(
                    ref.watch(selectedRegionFilterProvider),
                    ref.watch(selectedThemeFilterListProvider));
              },
              child: Text('추천 가져오기'),
            ),
            ElevatedButton(
                onPressed: () async {
                  getNotification();
                },
                child: Text('공지 가져오기')),
            ElevatedButton(
                onPressed: () {
                  myInformationTest();
                },
                child: Text('내 정보 테스트')),
          ],
        ),
      ),
    );
  }

  getNotification() async {
    Query<Map<String, dynamic>> query = firestore.collection('notification');
    QuerySnapshot<Map<String, dynamic>> docList = await query.get();
    print(docList);
    for (var doc in docList.docs) {
      print(doc.id);
      Map<String, dynamic> data = doc.data();
      // data['id'] = doc.id;
      print(data);
    }
  }

  saveData() async {
    List<Map<String, dynamic>> notifications = [
      {
        'content': '추천124',
        'region': 'seoul',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천214124',
        'region': 'daegu',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천312414',
        'region': 'busan',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '물고기 124124사냥하기',
        'region': 'seoul',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천12351354',
        'region': 'daegu',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천16165',
        'region': 'busan',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천6134134',
        'region': 'seoul',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천7125123',
        'region': 'daegu',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추천811',
        'region': 'busan',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '13추천9',
        'region': 'seoul',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '1616추천11',
        'region': 'daegu',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '31432추천12',
        'region': 'busan',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '123514추천13',
        'region': 'seoul',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '161634추천14',
        'region': 'daegu',
        'theme': ['healing', 'hist'],
      },
      {
        'content': '추12535132천10',
        'region': 'busan',
        'theme': ['healing', 'hist'],
      },
    ];
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var item in notifications) {
      // Create a new document reference
      DocumentReference ref =
          FirebaseFirestore.instance.collection('recommend').doc();
      // Add this item to the batch
      batch.set(ref, item);
    }

    // Commit the batch
    await batch.commit().then((value) {
      print('Batch write completed successfully.');
    }).catchError((error) {
      print('Error in batch write: $error');
    });
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

  myInformationTest() async {
    await ref.read(myInformationProvider.notifier).loadUserInfo();
  }
}
