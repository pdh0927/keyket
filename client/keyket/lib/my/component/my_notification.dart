import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class MyNotification extends StatelessWidget {
  const MyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(builder: (BuildContext context,
    //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    //   return ;
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 배경색 투명하게
        elevation: 0,
        title: const Text(
          '공지사항',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); //뒤로가기
          },
          // visualDensity: VisualDensity(horizontal: -2, vertical: -2), 아이콘 간격
          color: Colors.black,
          icon: const Icon(
            Remix.arrow_left_s_line,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: FutureBuilder(
          // * collection path : Collection / ID / Collection
          // * snapshots() : 데이터가 바뀔 때마다 받아옴
          future: FirebaseFirestore.instance.collection('notification').get(),
          // * AsyncSnapshot : Stream에서 가장 최신의 snapShot을 가져오기 위한 클래스
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // * 데이터를 받아오기 전 대기 상태일 때 화면 처리
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length, // * 데이터 갯수
              itemBuilder: (context, index) {
                return ListTile(
                  // * message의 field명 'text'로 값 받아오기
                  title: Text(docs[index]['title']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
