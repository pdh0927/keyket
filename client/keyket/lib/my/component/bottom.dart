import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/check_dialog.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/model/apple_login_model.dart';
import 'package:keyket/common/model/kakao_login_model.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/model/main_view_model.dart';

class Bottom extends ConsumerWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Remix.customer_service_2_line,
              color: BLACK_COLOR,
            ),
            title: const Text(
              '고객센터',
            ),
            onTap: () {
              _launchInstagramProfile();
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.gift_line,
              color: BLACK_COLOR,
            ),
            title: const Text('이벤트'),
            onTap: () {
              _Message(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.footprint_line,
              color: BLACK_COLOR,
            ),
            title: const Text('여행 유형 테스트'),
            onTap: () {
              _Message(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.user_unfollow_line,
              color: BLACK_COLOR,
            ),
            title: const Text(
              '회원 탈퇴',
            ),
            onTap: () {
              showCheckDialog(
                context: context,
                title: '회원 탈퇴',
                content: '정말로 회원을 탈퇴하시겠습니까?',
                leftActionText: '예',
                leftAction: () async {
                  Navigator.of(context).pop();
                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;

                  if (user != null) {
                    if (user.providerData.isNotEmpty) {
                      final viewModel = MainViewModel(AppleLoginModel());
                      await viewModel.deleteUser();
                    } else {
                      final viewModel = MainViewModel(KaKaoLoginModel());

                      await viewModel.deleteUser();
                    }

                    ref.read(myInformationProvider.notifier).resetState();
                  }
                },
                rightActionText: '아니요',
                rightAction: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  _Message(context) async {
    return showDialog(
      context: context,
      barrierColor: const Color(0xff616161).withOpacity(0.2),
      barrierDismissible: false,
      builder: (BuildContext) {
        Future.delayed(const Duration(seconds: 1), () {
          // 1초 후에 사라짐
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xff616161),
          elevation: 0,
          content: const Text(
            '준비 중입니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  _launchInstagramProfile() async {
    String instagramProfilePath = 'https://www.instagram.com/keyket_official/';
    Uri instagramProfileUrl = Uri.parse(instagramProfilePath);

    if (await canLaunchUrl(instagramProfileUrl)) {
      await launchUrl(instagramProfileUrl);
    } else {
      throw 'Could not launch $instagramProfileUrl';
    }
  }
}
