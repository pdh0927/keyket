import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';

import 'invite_code.dart';
import 'my_image.dart';

class MyProfile extends ConsumerStatefulWidget {
  const MyProfile({super.key});

  @override
  ConsumerState<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends ConsumerState<MyProfile> {
  late TextEditingController _controller;

  bool isSelect = false;

  late FocusNode _focusNode; // focus = 사용자 인터페이스에서 현재 활성화된 컨트롤 또는 위젯

  @override
  void initState() {
    // 위젯이 생성될 때 호출되는 메서드
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(
        _onFocusChanged); // _focusNode의 상태 변화를 감지하는 _onFocusChanged

    _controller = TextEditingController(text: "");
  }

  void _onFocusChanged() {
    // _focusNode의 상태가 감지될 때 호출되는 함수
    if (!_focusNode.hasFocus) {
      // 포커스가 해당 FocusNode에 없는 경우
      if (isSelect) {
        setState(() {
          isSelect = false;
          _controller.text =
              ref.read(myInformationProvider)!.nickname; // 원래 닉네임으로 저장
        });
      }
    }
  }

  void saveNickname(String text) {
    if (text != ref.read(myInformationProvider)!.nickname) {
      // 수정한 닉네임(text)이 현재 닉네임과 다르면
      ref
          .read(myInformationProvider.notifier)
          .changeName(text); // changeName 함수를 호출하여 수정한 닉네임으로 변경하여 저장
    }
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 호출되는 메서드 /  메모리 누수를 방지하고 필요한 정리 작업을 수행하는 데 사용
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(myInformationProvider) != null) {
      _controller = TextEditingController(
          text: ref.watch(myInformationProvider)!.nickname);
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const MyImage(),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 190,
                      child: TextFormField(
                        focusNode: _focusNode, // 포커스가 있는지 없는지 제어
                        controller: _controller, // 텍스트 필드의 입력 내용 관리
                        cursorColor: const Color(0XFF616161), // 커서 색 변경
                        readOnly: !isSelect, // isSelect가 false면 읽기 전용
                        textAlign: TextAlign.center,
                        maxLength:
                            isSelect ? 8 : null, // isSelect가 true면 최대 길이 표시
                        // autofocus: true, // 자동으로 포커스 받음
                        style: const TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 24,
                        ),
                        decoration: isSelect
                            ? const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(0),
                              )
                            : const InputDecoration(border: InputBorder.none),
                        onFieldSubmitted: (text) {
                          // 사용자가 '엔터'나 '완료' 버튼을 누르면
                          saveNickname(text); // 변경한 닉네임 저장
                          setState(() {
                            isSelect = !isSelect; // 수정모드 해제
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (isSelect) {
                          if (_controller.text.isNotEmpty) {
                            saveNickname(_controller.text);
                          } else {
                            // text가 아무것도 없으면
                            _controller.text = ref
                                .read(myInformationProvider)!
                                .nickname; // 기존 닉네임으로 저장
                          }
                        }
                        setState(() {
                          isSelect = !isSelect;
                        });
                      },
                      icon: Icon(isSelect ? Remix.check_line : Remix.edit_line),
                      iconSize: 25, // 아이콘 사이즈 수정
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const InviteCode(),
              ],
            ),
          ],
        ),
      ],
      // ),
    );
  }
}
