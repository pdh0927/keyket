import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

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
          // * collection path : notification
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
              itemCount: docs.length + 1, // * 데이터 갯수
              itemBuilder: (context, index) {
                if (index == 0) {
                  // index가 0일떄 구분선
                  return const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFF616161),
                  );
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Theme(
                      data: ThemeData(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        // * message의 field명 'text'로 값 받아오기
                        textColor: Colors.black,
                        iconColor: const Color(0XFF616161),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yy/MM/dd').format(
                                  docs[index - 1]['updatedAt'].toDate()),
                              style: const TextStyle(
                                  fontFamily: 'SCDream',
                                  fontSize: 12,
                                  color: Color(0XFF616161)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              docs[index - 1]['title'],
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
                              decoration: const BoxDecoration(
                                color: Color(0XFFC4E4FA),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      docs[index - 1]['content'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0XFF000000),
                                        fontFamily: 'SCDream',
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    docs[index - 1]['image'] != ''
                                        ? CachedNetworkImage(
                                            imageUrl: docs[index - 1]['image'],
                                            fit: BoxFit.cover,
                                            width: 80.w, // 원의 두 배의 지름
                                            height: 60.w, // 원의 두 배의 지름
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 80.w,
                                                height: 60.w,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : SizedBox(height: 0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFF616161))
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
