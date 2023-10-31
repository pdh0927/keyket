import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MyNotification extends StatelessWidget {
  const MyNotification({super.key});

  Future<bool?> _showAdPopup(context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('광고 보기'),
          content: Text('보상형 광고를 보시겠습니까? 보면 앱의 더 많은 기능을 이용할 수 있습니다!'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                await showRewardedAd();
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showRewardedAd() async {
    print('******************showRewardedAD******************');

    // 비동기 작업을 확인하기 위한 bool 타입의 Completer
    Completer<bool> completer = Completer<bool>();
    // 보상 지급 확인 변수
    bool isRewarded = false;

    await RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? dotenv.env['ANDROID_REWARD_UNIT_KEY']!
          : dotenv.env['IOS_REWARD_UNIT_KEY']!,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // 보상 광고 로드 완료
        onAdLoaded: (rewardedAd) async {
          rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
            // 광고가 표시 될 때 호출
            onAdShowedFullScreenContent: (ad) =>
                print('$ad onAdShowedFullScreenContent.'),
            // 광고가 닫힐 때 호출
            onAdDismissedFullScreenContent: (ad) {
              print('$ad onAdDismissedFullScreenContent.');
              // 광고 리소스 해제
              ad.dispose();
              completer.complete(isRewarded);
            },
            // 광고가 표시되지 못했을 때의 호출, 오류 정보 제공
            onAdFailedToShowFullScreenContent: (ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              completer.complete(isRewarded);
            },
            // 광고가 노출되었을 때 호출
            onAdImpression: (ad) => print('$ad impression occurred.'),
          );
          // 광고 보여주기
          await rewardedAd.show(
            onUserEarnedReward: (ad, reward) {
              // 광고 보상 지급 코드
              print(
                  'Reward ad : $ad    reward : $reward,   type : ${reward.type},    amount : ${reward.amount}');
              // 보상 지급 완료 처리
              isRewarded = true;
            },
          );
        },
        // 보상 광고 로드 실패
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          completer.complete(isRewarded);
        },
      ),
    );
    return completer.future;
  }

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
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _showAdPopup(context);
            },
            child: Icon(
              Icons.abc,
              color: Colors.white,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.transparent), // 배경을 투명하게 설정
              elevation: MaterialStateProperty.all(0), // 그림자 제거
              overlayColor: MaterialStateProperty.all(
                  Colors.transparent), // 눌렀을 때 아무런 효과도 없도록 설정
              fixedSize: MaterialStateProperty.all(Size(5, 5)),
              padding: MaterialStateProperty.all(EdgeInsets.zero), // 패딩 제거
            ),
          ),
        ],
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
                                        height: 1.4,
                                        fontSize: 15,
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
                                                    const Icon(Icons.error),
                                          )
                                        : const SizedBox(height: 0)
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
