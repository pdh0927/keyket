import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../common/const/colors.dart';

class MyBucket extends ConsumerWidget {
  const MyBucket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                style: TextStyle(fontFamily: 'SCDream', fontSize: 16),
              ),
              Icon(
                Remix.shopping_cart_line,
                size: 18,
              ),
            ],
          ),
        ),
        Container(
          width: 308,
          height: 81,
          decoration: BoxDecoration(
            border: Border.all(
              color: PRIMARY_COLOR,
              width: 2,
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
                    "나만의 버킷",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'SCDream',
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${ref.read(myBucketListListProvider.notifier).getBucketListCount()}개",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SCDream',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 1,
                          width: 76,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const VerticalDivider(
                thickness: 2,
                width: 1,
                color: PRIMARY_COLOR,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "공유 버킷",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'SCDream',
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${ref.read(sharedBucketListListProvider.notifier).getBucketListCount()}개",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SCDream',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 1,
                          width: 76,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
