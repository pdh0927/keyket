import 'package:flutter/material.dart';
import 'package:keyket/bucket/view/bucket_list_screen.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/my/view/my_screen.dart';
import 'package:keyket/recommend/view/recommend_screen.dart';
import 'package:remixicon/remixicon.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController
      controller; // late : 나중에 무조건 null이 아니라 controller 사용전에 세팅 한다
  int index = 0;

  @override
  void initState() {
    super.initState();
    // length : 몇 개 탭 사용할건지, vsync : 현재의  state 넣어주면 됨(그런데 SingleTickerProviderStateMixin이라는 기능 가지고 있어야함)
    controller = TabController(length: 4, vsync: this);
    controller.addListener(
        tabListener); // controller의 변경사항이 감지될 때마다 tabListener 함수 실행
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BLACK_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            controller
                .animateTo((index)); // 현재 탭과 인덱스가 다를 경우, 애니메이션을 사용하여 탭을 부드럽게 전환
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Remix.home_line), label: 'HOME'),
            BottomNavigationBarItem(
                icon: Icon(Remix.check_double_fill), label: 'RECOMMEND'),
            BottomNavigationBarItem(
                icon: Icon(Remix.sticky_note_line), label: 'BUCKET'),
            BottomNavigationBarItem(icon: Icon(Remix.user_3_line), label: 'MY')
          ]),
      child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // scroll로는 화면 전환 x
          controller: controller,
          children: const [
            Center(child: Text('HOME')),
            RecommendScreen(),
            BucketListScreen(),
            MyScreen()
          ]),
    );
  }
}
