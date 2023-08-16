import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';

import '../../common/provider/my_provider.dart';
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

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      if (isSelect) {
        setState(() {
          isSelect = false;
          _controller.text = ref.read(myInformationProvider)!.nickname;
        });
      }
    }
  }

  void saveNickname(String text) {
    if (text != ref.read(myInformationProvider)!.nickname) {
      ref.read(myInformationProvider.notifier).changeName(text);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller =
        TextEditingController(text: ref.watch(myInformationProvider)!.nickname);
    // print('top build');
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyImage(),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: _controller,
                        cursorColor: Color(0XFF616161),
                        readOnly: !isSelect,
                        maxLength: isSelect ? 8 : null,
                        autofocus: true,
                        style: const TextStyle(
                          fontFamily: 'SCDream',
                          fontSize: 24,
                        ),
                        decoration: isSelect
                            ? InputDecoration(
                                // focusedBorder: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.all(0),
                              )
                            : InputDecoration(border: InputBorder.none),
                        onFieldSubmitted: (text) {
                          saveNickname(text);
                          setState(() {
                            isSelect = !isSelect;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (isSelect) {
                          saveNickname(_controller.text);
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
                SizedBox(
                  height: 20,
                ),
                InviteCode(),
              ],
            ),
          ],
        ),
      ],
      // ),
    );
  }
}
