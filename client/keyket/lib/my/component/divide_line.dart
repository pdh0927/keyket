import 'package:flutter/cupertino.dart';

class DivideLine extends StatelessWidget {
  const DivideLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 1,
          width: 350,
          color: const Color(0XFF616161),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
