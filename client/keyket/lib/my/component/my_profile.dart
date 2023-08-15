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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller =
        TextEditingController(text: ref.watch(myInformationProvider)!.nickname);
    // print('top build');
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyImage(),
            Column(
              children: [
                SingleChildScrollView(
                  // 키보드 올라올 때 오류 해결 (지워도 됨)
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: _controller,
                          readOnly: !isSelect,
                          autofocus: true,
                          style: TextStyle(fontFamily: 'SCDream', fontSize: 24),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSelect = (isSelect == true) ? false : true;
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: ref
                            //               .watch(myInformationProvider)!
                            //               .nickname
                            //               .length
                            //               .toDouble() *
                            //           25,
                            //       child: TextFormField(
                            //         controller: _controller,
                            //         readOnly: false,
                            //         style: TextStyle(
                            //             fontFamily: 'SCDream', fontSize: 24),
                            //         maxLength: 8,
                            //         cursorColor: Color(0XFF616161),
                            //       ),
                            //     ),
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: Icon(Icons.add),
                            //     ),
                            //   ],
                            // );
                          });
                        },
                        icon: Icon(isSelect ? Icons.add : Remix.edit_line),
                        iconSize: 25, // 아이콘 사이즈 수정
                      ),
                    ],
                  ),
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
    );
  }

  // Widget renderTextField() {
  //   return TextFormField(
  //     cursorColor: Colors.black,
  //     maxLength: 8,
  //     decoration: InputDecoration(
  //       border: InputBorder.none, // 줄 없애기
  //       filled: true, // 색깔 넣기 위해
  //       fillColor: Colors.grey[300],
  //     ),
  //   );
  // }
}

// class ChangeName extends StatefulWidget {
//   const ChangeName({
//     super.key,
//   });

//   @override
//   State<ChangeName> createState() => _ChangeNameState();
// }

// class _ChangeNameState extends State<ChangeName> {
//   final GlobalKey<FormState> formKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: SafeArea(
//         child: Container(
//           height: MediaQuery.of(context).size.height / 2 + bottomInset,
//           color: Colors.white,
//           child: Padding(
//             padding: EdgeInsets.only(left: 8, right: 8, top: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }

