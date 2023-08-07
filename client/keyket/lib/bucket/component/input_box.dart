import 'package:flutter/material.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/common/const/colors.dart';

class InputBox extends StatefulWidget {
  final String inputType;
  final String? defaultName;
  final Function(String) onLeftPressed;
  final Function() onRightPressed;

  const InputBox({
    super.key,
    required this.inputType,
    this.defaultName,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultName ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 230,
          height: 95,
          padding:
              const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFC4E4FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Text(
              widget.inputType,
              style: inputBoxTextStyle,
            ),
            TextField(
              controller: _controller,
              autofocus: true,
              style: inputBoxTextStyle,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.only(left: 5, bottom: 0, top: 0)),
              onSubmitted: (text) {
                FocusScope.of(context).unfocus();
                // _controller.clear();
              },
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              _CustomButton(
                buttonText: '확인',
                onPressed: () {
                  // 이름이 없거나, 이전 이름과 같지 않으면 변경 실행
                  if (_controller.text != '' &&
                      _controller.text != widget.defaultName) {
                    widget.onLeftPressed(_controller.text);
                  }
                },
              ),
              const Spacer(),
              _CustomButton(
                buttonText: '취소',
                onPressed: () {
                  widget.onRightPressed();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const _CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD9D9D9),
        foregroundColor: BLACK_COLOR,
        minimumSize: const Size(105, 28),
        maximumSize: const Size(105, 28),
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'SCDream',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
