import 'package:flutter/material.dart';

void showCheckDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String leftActionText,
  required Function() leftAction,
  required String rightActionText,
  required Function() rightAction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        content: content,
        leftActionText: leftActionText,
        leftAction: leftAction,
        rightActionText: rightActionText,
        rightAction: rightAction,
      );
    },
  );
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String leftActionText;
  final Function() leftAction;
  final String rightActionText;
  final Function() rightAction;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.leftActionText,
    required this.leftAction,
    required this.rightActionText,
    required this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: leftAction,
          child: Text(leftActionText),
        ),
        TextButton(
          onPressed: rightAction,
          child: Text(rightActionText),
        ),
      ],
    );
  }
}
