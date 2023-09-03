import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:keyket/common/view/splash_screen.dart';
import 'package:keyket/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_APP_KEY']);
  MobileAds.instance.initialize();

  runApp(const ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    // 나중에 routing 시 buildcontext가 필요한 경우가 있어서 widget으로 감싸고 materialapp을 넣는다

    return MaterialApp(
        theme: ThemeData(fontFamily: 'SCDream'),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
