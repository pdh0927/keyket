import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Hi(),
            ),
          );
        },
        icon: const Icon(
          Remix.lock_line,
          size: 24,
          color: Color(0XFF3498DB),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _Notification(),
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

class _Notification extends StatelessWidget {
  const _Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '공지사항',
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ListView(
          children: [
            Container(
              color: Color(0xFF616161),
              width: 10,
              height: 1,
            ),
            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('24/06/07'),
                  Text('여행 유형테스트 업데이트 안내'),
                ],
              ),
              children: [
                ListTile(
                  title: Text(' '),
                ),
              ],
            ),
            Container(
              color: Color(0xFF616161),
              width: 350,
              height: 1,
            ),
            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('24/01/01'),
                  Text('유료 구매 혜택 안내'),
                ],
              ),
              children: [
                ListTile(
                  title: Text(' '),
                ),
              ],
            ),
            Container(
              color: Color(0xFF616161),
              width: 350,
              height: 1,
            ),
            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('23/07/07'),
                  Text('안녕하세요 키킷입니다.'),
                ],
              ),
              children: [
                ListTile(
                  title: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '안녕하세요 여행을 여는 열쇠, 키킷입니다. \n'
                        '키킷 앱은 버킷리스트를 작성하는 것 뿐만 아니라 버킷리스트를 추천해주는 어플입니다. \n'
                        '어쩌구 저쩌구 요러케 저러케 궁시렁 왕시렁 헤이즐넛 아메리카노는 더위사냥. \n'
                        '음 앙버터가 눈앞에 있다. 하나 남은 앙버터를 가져왔다. \n'
                        '감사합니다.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0XFF3498DB).withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    width: 350,
                    height: 200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Hi extends StatelessWidget {
  const Hi({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Text(''),
    );
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
            _ExamplePage(),
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

class _ExamplePage extends StatefulWidget {
  const _ExamplePage({super.key});

  @override
  State<_ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<_ExamplePage> {
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
                _ShowSheet();
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

  _ShowSheet() {
    final result = showDialog(
      context: context,
      builder: (BuildContext context) {
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: Color(0XFF616161).withOpacity(0.2),
          ),
          child: Text('프로필 사진 설정하기'),
        );
      },
    );
  }
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
              color: PRIMARY_COLOR.withOpacity(0.5),
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
                color: PRIMARY_COLOR.withOpacity(0.5),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Hi(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.gift_line,
              color: BLACK_COLOR,
            ),
            title: Text('이벤트'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Hi(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.footprint_line,
              color: BLACK_COLOR,
            ),
            title: Text('여행 유형테스트'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Hi(),
                ),
              );
            },
          ),
        ],
      ),
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
