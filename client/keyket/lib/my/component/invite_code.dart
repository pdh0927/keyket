import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

import '../../common/provider/my_provider.dart';

class InviteCode extends ConsumerStatefulWidget {
  const InviteCode({super.key});

  @override
  ConsumerState createState() => _InviteCodeState();
}

class _InviteCodeState extends ConsumerState<InviteCode> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35,
          width: 99,
          decoration: const BoxDecoration(
            color: Color(0XFFC4E4FA),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(20.0),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "초대코드",
                style: TextStyle(
                  fontFamily: 'SCDream',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Container(
          height: 35,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20.0),
            ),
            border: Border.all(color: const Color(0XFF616161), width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref.watch(myInformationProvider)!.id,
                style: TextStyle(
                    fontFamily: 'SCDream', fontSize: 16, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: ref.watch(myInformationProvider)!.id),
                  ); // 클립보드 복사
                  _InviteMessage(context);
                },
                icon: Icon(Remix.file_copy_line),
                iconSize: 20,
              )
            ],
          ),
        ),
      ],
    );
  }

  _InviteMessage(context) async {
    return showDialog(
      context: context,
      barrierColor: const Color(0xff616161).withOpacity(0.2),
      builder: (BuildContext) {
        Future.delayed(Duration(seconds: 1), () {
          // 1초 후에 사라짐
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xff616161),
          elevation: 0,
          content: const Text(
            '초대코드가 복사되었습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
