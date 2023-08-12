import 'package:flutter/material.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '홈',
        actions: [
          IconButton(
            icon: const Icon(Remix.notification_4_line, size: 28),
            splashRadius: 20,
            // constraints: BoxConstraints(maxHeight: 25, maxWidth: 25),
            onPressed: () {},
          )
        ],
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 16.0, left: 16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text('광고'),
                width: double.infinity,
                height: 85,
                decoration: BoxDecoration(border: Border.all(width: 1.0)),
              ),
              Container()
            ],
          ),
        ));
  }
}
