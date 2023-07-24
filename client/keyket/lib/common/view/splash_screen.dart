import 'package:flutter/material.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/view/root_tab.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    await Future.delayed(const Duration(seconds: 0)); // 임시 3초 delay
    if (true) {
      // 로그인 정보 있을 시
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootTab()), (route) => false);
    } else {
      // 로그인 정보 만료 시
    }
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '로딩 화면',
            style: TextStyle(fontFamily: 'SCDream', fontSize: 25),
          ),
          CircularProgressIndicator()
        ],
      )),
    );
  }
}
