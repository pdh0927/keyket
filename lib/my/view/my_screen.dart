import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/model/apple_login_model.dart';
import 'package:keyket/common/model/kakao_login_model.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/my/component/bottom.dart';
import 'package:keyket/my/component/divide_line.dart';
import 'package:keyket/my/component/my_bucket.dart';
import 'package:keyket/my/component/my_notification.dart';

import 'package:flutter/material.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/my/component/my_profile.dart';
import 'package:remixicon/remixicon.dart';

class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    if (ref.watch(myInformationProvider) != null) {
      return DefaultLayout(
        title: '내 정보',
        actions: getActions(context),
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(children: [
              MyProfile(),
              DivideLine(),
              MyBucket(),
              DivideLine(),
              Bottom(),
            ]),
          ),
        ),
      );
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        ref.read(myInformationProvider.notifier).loadUserInfo();
      }

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  List<Widget> getActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.providerData.isNotEmpty) {
              final viewModel = MainViewModel(AppleLoginModel());
              viewModel.logout();
            } else {
              final viewModel = MainViewModel(KaKaoLoginModel());
              viewModel.logout();
            }
            ref.read(myInformationProvider.notifier).resetState();
          }
        },
        icon: const Icon(
          Remix.lock_unlock_line,
          size: 27,
          color: Color(0XFF3498DB),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyNotification(),
            ),
          );
        },
        icon: const Icon(
          Remix.notification_4_line,
          size: 27,
          color: Colors.black,
        ),
      ),
      const SizedBox(width: 20)
    ];
  }

  Logout(context) {
    // 팝업창 구현
    return showDialog(
        barrierColor: const Color(0xff616161).withOpacity(0.2), // 팝업창 뒷배경 색깔
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)), // 테두리 둥글게
            backgroundColor: const Color(0xff616161), // 팝업창 바탕색
            title: const Text(
              '로그아웃 하시겠습니까?',
              style: TextStyle(
                fontFamily: 'SCDream',
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SimpleDialogOption(
                    child: const Text(
                      '예',
                      style: TextStyle(
                        fontFamily: 'SCDream',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SimpleDialogOption(
                    child: const Text(
                      '아니요',
                      style: TextStyle(
                        fontFamily: 'SCDream',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
