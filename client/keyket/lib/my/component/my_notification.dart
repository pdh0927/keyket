import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            fontFamily: 'SCDream',
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
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                return ExpansionTile(
                  // * message의 field명 'text'로 값 받아오기
                  textColor: Colors.black,
                  iconColor: const Color(0XFF616161),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('yy/MM/dd')
                            .format(docs[index]['updatedAt'].toDate()),
                        style: const TextStyle(
                            fontFamily: 'SCDream',
                            fontSize: 12,
                            color: Color(0XFF616161)),
                      ),
                      Text(
                        docs[index]['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SCDream',
                        ),
                      ),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: Container(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            docs[index]['content'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0XFF000000),
                              fontFamily: 'SCDream',
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0XFFC4E4FA),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
