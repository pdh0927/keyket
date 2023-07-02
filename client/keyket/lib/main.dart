import 'package:flutter/material.dart';
import 'package:keyket/common/view/splash_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    // 나중에 routing 시 buildcontext가 필요한 경우가 있어서 widget으로 감싸고 materialapp을 넣는다
    return MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSans'),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
