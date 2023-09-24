import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';

void showHelpImageDialog(BuildContext context, String imageName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10.0), // 화면 주변의 패딩 값
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0), // 다이얼로그의 모서리를 둥글게
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text('도움말',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Image.asset('asset/img/help/$imageName.png'),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    child: const Text(
                      '닫기',
                      style: TextStyle(color: BLACK_COLOR, fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      );
    },
  );
}
