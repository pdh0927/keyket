import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/common/const/text_style.dart';

class CustomAddTextField extends StatefulWidget {
  final ItemModel? item;
  final bool? isCompleted;
  final Function? modifyItem;
  final Function? changeModifyFlag;
  final Function? onPressed;
  const CustomAddTextField(
      {super.key,
      this.item,
      this.onPressed,
      this.modifyItem,
      this.changeModifyFlag,
      this.isCompleted});

  @override
  State<CustomAddTextField> createState() => _CustomAddTextFieldState();
}

class _CustomAddTextFieldState extends State<CustomAddTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.item == null ? "" : widget.item!.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 16.0),
          child: DottedBorder(
            color: const Color(0xFF616161),
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(3),
            child: const SizedBox(
              width: 16,
              height: 16,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 55,
                padding: const EdgeInsets.only(left: 0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: dropdownTextStyle,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) {
                    if (widget.modifyItem != null &&
                        widget.changeModifyFlag != null) {
                      if (text != widget.item!.content) {
                        widget.modifyItem!(
                            text,
                            widget.item.runtimeType,
                            widget.isCompleted,
                            widget.item!.id,
                            widget.item!.content);
                      }

                      widget.changeModifyFlag!();
                    }

                    if (widget.onPressed != null) {
                      widget.onPressed!(text);
                    }

                    _controller.clear();
                  },
                ),
              ),
              const Divider(
                color: Color(0xFF616161),
                thickness: 1,
                height: 0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 9,
        ),
      ],
    );
  }
}
