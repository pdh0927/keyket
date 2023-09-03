import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/view/login_screen.dart';
import 'package:keyket/common/view/root_tab.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            return const RootTab(); // 사용자가 로그인한 상태
          }
          return const LoginScreen(); // 사용자가 로그아웃한 상태 또는 토큰 만료
        }
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
            ),
          ),
        );
      },
    );
  }
}
