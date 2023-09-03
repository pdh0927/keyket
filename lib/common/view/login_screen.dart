import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/model/apple_login_model.dart';
import 'package:keyket/common/model/google_login_model.dart';
import 'package:keyket/common/model/kakao_login_model.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:remixicon/remixicon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false; // 로딩 상태를 표시하는 변수 추가

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('asset/img/logo.png', width: 250, height: 200),
                  Text(
                    '여행을 여는 열쇠',
                    style: loginLogoTextStyle,
                  ),
                  Text(
                    '키킷',
                    style: loginLogoTextStyle.copyWith(color: PRIMARY_COLOR),
                  ),
                  const SizedBox(height: 90),
                  InkWell(
                    onTap: _loginWithKakao,
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFAEA5C)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Remix.kakao_talk_fill,
                            size: 30,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '카카오톡 로그인',
                            style: dropdownTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _loginWithGoogle,
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Remix.google_fill,
                            size: 30,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '구글 로그인',
                            style: dropdownTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: Platform.isIOS ? 20 : 0), // 간격 추가
                  Platform.isIOS
                      ? InkWell(
                          onTap: _loginWithApple,
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: BLACK_COLOR),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Remix.apple_fill,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  '애플 로그인',
                                  style: dropdownTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(height: 0)
                ],
              ),
            ),
          ),
          if (isLoading) // 로딩 상태가 true일 때만 로딩 창 표시
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _loginWithKakao() async {
    setState(() {
      isLoading = true; // 로딩 시작 전에 상태를 true로 변경
    });

    final viewModel = MainViewModel(KaKaoLoginModel());
    bool isSuccessed = await viewModel.login();
    if (!isSuccessed) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loginWithApple() async {
    setState(() {
      isLoading = true;
    });

    final viewModel = MainViewModel(AppleLoginModel());
    bool isSuccessed = await viewModel.login();
    if (!isSuccessed) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    final viewModel = MainViewModel(GoogleLoginModel());
    bool isSuccessed = await viewModel.login();
    if (!isSuccessed) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
