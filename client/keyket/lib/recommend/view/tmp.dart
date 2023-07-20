import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyket/recommend/const/data.dart';

final firestore = FirebaseFirestore.instance;

class Tmp extends StatefulWidget {
  const Tmp({super.key});

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  getRecommendData() async {
    // var one_result = await firestore
    //     .collection('recommend')
    //     .doc('8Xeyk8hiF8m00THpT3dq')
    //     .get();
    // print(one_result['content']);
    // print(one_result['region']);
    // print(one_result['theme']);

    try {
      var all_result = await firestore.collection('recommend').get();

      print(all_result);
      print(all_result.docs);
      for (var doc in all_result.docs) {
        print(doc['content']);
        print(doc['region']);
        print(doc['theme']);
        print(doc.data().runtimeType);
      }
    } catch (e) {
      print(e);
    }

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

  saveData() async {
    for (var item in recommendedItems) {
      // await firestore.collection('recommend').add(item);
      // print(item);
    }

    // print(result);
  }

  // updateData() async {
  //   var result = await firestore.collection('recommend').doc({id}).update({});
  // }

  // deleteData() async {
  //   var result = await firestore.collection('recommend').doc({id}).delete();
  // }

  @override
  void initState() {
    // getRecommendData();
    // saveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('추천 임시 페이지임');
  }
}
