import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Text('여행 유형테스트'),
            onTap: () {
              _Message(context);
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
    const instagramProfileUrl = 'https://www.instagram.com/keyket_official/';
    if (await canLaunch(instagramProfileUrl)) {
      await launch(instagramProfileUrl);
    } else {
      throw 'Could not launch $instagramProfileUrl';
    }
  }
}
