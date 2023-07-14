import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';

showCustomAlertDialog(BuildContext context, String content) {
  showDialog<void>(
    context: context,
    barrierDismissible: true, // 배경 터치로 Dialog 닫기 가능
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: Colors.grey[300],
        titlePadding: const EdgeInsets.all(5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              constraints: const BoxConstraints(maxWidth: 25, maxHeight: 25),
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 50, left: 25, right: 25),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, color: BLACK_COLOR),
        ),
      );
    },
  );
}
