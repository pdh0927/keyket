import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';

showCustomInputDialog(BuildContext context, String title) async {
  TextEditingController nameController = TextEditingController();

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // 제목
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(title,
                        style: bucketTextStyle, textAlign: TextAlign.left),
                  ),
                  const SizedBox(height: 16),
                  // 입력 창
                  TextField(
                    controller: nameController,
                    maxLength: 10,
                    autofocus: true,
                    cursorColor: const Color(0xFF616161).withOpacity(0.1),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(maxWidth: 25, maxHeight: 25),
                        suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.clear,
                              color: BLACK_COLOR,
                            ),
                            onPressed: () {
                              nameController.clear();
                            })),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 확인 버튼
            InkWell(
              onTap: () {
                String bucketName = nameController.text;
                if (bucketName.isNotEmpty) {
                  // Perform bucket creation logic here
                  // ...

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFF616161).withOpacity(0.2),
                    border: const Border(
                        top: BorderSide(width: 0.5, color: Color(0xFF616161)))),
                alignment: Alignment.center,
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
