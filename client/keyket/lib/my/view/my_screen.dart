import 'dart:io';
import 'package:keyket/my/view/my_image_screen.dart';
import 'package:keyket/my/view/my_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';
import 'package:image_picker/image_picker.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '내 정보',
      actions: getActions(context),
      child: const Column(
        children: [
          _Top(),
          _Divide(),
          _Middle(),
          _Divide(),
          _Bottom(),
        ],
      ),
    );
  }

  List<Widget> getActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => _Message(),
          //   ),
          // );
        },
        icon: const Icon(
          Remix.lock_unlock_line,
          size: 24,
          color: Color(0XFF3498DB),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyNotification(),
            ),
          );
        },
        icon: const Icon(
          Remix.notification_4_line,
          size: 24,
          color: Colors.black,
        ),
      ),
      SizedBox(width: 20)
    ];
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyProfile(),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '강수진',
                      style: TextStyle(fontSize: 24),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Remix.edit_line),
                      iconSize: 25, // 아이콘 사이즈 수정
                    ),
                  ],
                ),
                Container(
                  width: 210,
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFFF616161),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "초대코드",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: Color(0xFFFF616161)), // 가운데 나누는 선
                      Text(
                        "123456",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: '123456')); // 클립보드 복사
                        },
                        icon: Icon(Remix.file_copy_line),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future pickImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0XFF616161).withOpacity(0.2),
            ),
            child: GestureDetector(
              onTap: () {
                takeImage(context);
              },
              child: Icon(
                Remix.user_fill,
                size: 60,
                color: Color(0XFF3498DB).withOpacity(0.8),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0XFF616161).withOpacity(0.2),
            ),
            child: Icon(
              Remix.image_edit_line,
              color: Color(0XFF3498DB).withOpacity(0.8),
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              '프로필 사진 설정',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  '앨범에서 사진 선택하기',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // PickImage() {
  //   return _image != null
  //       ? Container(
  //           width: 100,
  //           height: 100,
  //           child: Image.file(File(_image!.path)),
  //         )
  //       : Container(
  //           width: 100,
  //           height: 100,
  //           color: Colors.grey,
  //         );
  // }
}

class _Middle extends StatelessWidget {
  const _Middle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30, bottom: 16),
          child: Row(
            children: [
              Text(
                'MY BUCKET',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Remix.shopping_cart_line,
                size: 18,
              ), // 아이콘 바꾸기
            ],
          ),
        ),
        Container(
          width: 308,
          height: 81,
          decoration: BoxDecoration(
            border: Border.all(
              color: PRIMARY_COLOR,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "완성된 버킷",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "0개",
                  ),
                  Container(
                    height: 1,
                    width: 76,
                    color: Colors.black,
                  ),
                ],
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: PRIMARY_COLOR,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "진행중 버킷",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "5개",
                  ),
                  Container(
                    height: 1,
                    width: 76,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({super.key});

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
            title: Text(
              '고객센터',
            ),
            onTap: () {
              _Message(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.gift_line,
              color: BLACK_COLOR,
            ),
            title: Text('이벤트'),
            onTap: () {
              _Message(context);
            },
          ),
          ListTile(
            leading: Icon(
              Remix.footprint_line,
              color: BLACK_COLOR,
            ),
            title: Text('여행 유형테스트'),
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
      builder: (BuildContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Color(0XFF616161).withOpacity(0.2),
          elevation: 0,
          content: Text(
            '준비중입니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class _Divide extends StatelessWidget {
  const _Divide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 1,
          width: 350,
          color: Color(0XFF616161).withOpacity(0.8),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
