import 'package:flutter/material.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:flutter/services.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '내 정보',
      actions: const [
        Icon(
          Icons.notifications_outlined,
          size: 24,
          color: Colors.black,
        ),
        SizedBox(width: 25)
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Top(),
          _Middle(),
          _Bottom(),
        ],
      ),
    );
  }
}

class Hi extends StatelessWidget {
  const Hi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('고객센터'),
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.account_circle),
          iconSize: 100,
        ),
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
                  icon: Icon(Icons.drive_file_rename_outline),
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
                    style: TextStyle(fontSize: 16),
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
                    icon: Icon(Icons.copy),
                    iconSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Middle extends StatelessWidget {
  const _Middle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: Row(
            children: [
              Text(
                'MY BUCKET',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.shopping_cart,
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
              color: Color(0xFFFF3498DB),
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
                  Text(
                    "완성된 버킷",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "0개",
                  ),
                ],
              ),
              VerticalDivider(
                  thickness: 1, width: 1, color: Color(0xFFFF3498DB)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "진행중 버킷",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "5개",
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
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.headset_mic),
          title: Text('고객센터'),
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
          leading: Icon(Icons.redeem),
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
          leading: Icon(Icons.square_foot), // 아이콘 변경
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
    );
  }
}
