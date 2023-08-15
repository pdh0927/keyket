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
    return Material(
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
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent, // 배경색 투명하게
    //     elevation: 0,
    //     title: const Text(
    //       '공지사항',
    //       style: TextStyle(
    //         color: Colors.black,
    //         fontSize: 24,
    //       ),
    //     ),
    //     leading: IconButton(
    //       onPressed: () {
    //         Navigator.pop(context); //뒤로가기
    //       },
    //       // visualDensity: VisualDensity(horizontal: -2, vertical: -2), 아이콘 간격
    //       color: Colors.black,
    //       icon: const Icon(
    //         Remix.arrow_left_s_line,
    //         size: 35,
    //       ),
    //     ),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
    //     child: ListView(
    //       children: [
    //         Container(
    //           color: const Color(0xFF616161),
    //           width: 10,
    //           height: 1,
    //         ),
    //         const ExpansionTile(
    //           title: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text('24/06/07'),
    //               Text('여행 유형테스트 업데이트 안내'),
    //             ],
    //           ),
    //           children: [
    //             ListTile(
    //               title: Text(' '),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           color: const Color(0xFF616161),
    //           width: 350,
    //           height: 1,
    //         ),
    //         const ExpansionTile(
    //           title: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text('24/01/01'),
    //               Text('유료 구매 혜택 안내'),
    //             ],
    //           ),
    //           children: [
    //             ListTile(
    //               title: Text(' '),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           color: const Color(0xFF616161),
    //           width: 350,
    //           height: 1,
    //         ),
    //         ExpansionTile(
    //           title: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text('23/07/07'),
    //               Text('안녕하세요 키킷입니다.'),
    //             ],
    //           ),
    //           children: [
    //             ListTile(
    //               title: Container(
    //                 // ignore: sort_child_properties_last
    //                 child: const Padding(
    //                   padding: EdgeInsets.all(16.0),
    //                   child: Text(
    //                     '안녕하세요 여행을 여는 열쇠, 키킷입니다. \n'
    //                     '키킷 앱은 버킷리스트를 작성하는 것 뿐만 아니라 버킷리스트를 추천해주는 어플입니다. \n'
    //                     '어쩌구 저쩌구 요러케 저러케 궁시렁 왕시렁 헤이즐넛 아메리카노는 더위사냥. \n'
    //                     '음 앙버터가 눈앞에 있다. 하나 남은 앙버터를 가져왔다. \n'
    //                     '감사합니다.',
    //                     style: TextStyle(
    //                       fontSize: 12,
    //                       height: 2,
    //                     ),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //                 decoration: BoxDecoration(
    //                   color: const Color(0XFF3498DB).withOpacity(0.2),
    //                   borderRadius: const BorderRadius.all(
    //                     Radius.circular(10),
    //                   ),
    //                 ),
    //                 width: 350,
    //                 height: 200,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
