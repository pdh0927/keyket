import 'package:flutter/material.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/model/apple_login_model.dart';
import 'package:keyket/common/model/kakao_login_model.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:remixicon/remixicon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final viewModel = MainViewModel(KaKaoLoginModel());
                  await viewModel.login();
                },
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
                        size: 50,
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
              InkWell(
                onTap: () async {
                  final viewModel = MainViewModel(AppleLoginModel());
                  await viewModel.login();
                },
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
                        Remix.apple_fill,
                        size: 50,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '애플 로그인',
                        style: dropdownTextStyle,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
