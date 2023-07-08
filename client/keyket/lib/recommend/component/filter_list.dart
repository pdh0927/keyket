import 'package:flutter/material.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:remixicon/remixicon.dart';

class FilterList extends StatelessWidget {
  final List<String> featureList;
  final Function onSelected;

  const FilterList(
      {super.key, required this.featureList, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: featureList.first,
      icon: const Icon(Remix.arrow_down_s_line),
      elevation: 16,
      style: dropdownTextStyle,
      underline: Container(
        height: 2,
        color: BLACK_COLOR,
      ),
      onChanged: (String? value) {
        onSelected(featureList[0], value);
      },
      items: featureList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: dropdownTextStyle,
            ));
      }).toList(),
    );
  }
}
