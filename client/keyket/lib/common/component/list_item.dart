import 'package:flutter/material.dart';
import 'package:keyket/bucket/component/custom_add_text_field.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:remixicon/remixicon.dart';

class ListItem extends StatefulWidget {
  final bool selectFlag;
  final bool isContain;
  final bool isRecommendItem;
  final bool isHome;
  final Function() onPressed;
  final Function? removeItem;
  final Function? modifyItem;
  final ItemModel item;

  const ListItem(
      {super.key,
      required this.selectFlag,
      required this.isContain,
      required this.isHome,
      required this.isRecommendItem,
      required this.onPressed,
      this.removeItem,
      this.modifyItem,
      required this.item});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool modifyFlag = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (widget.selectFlag && !modifyFlag)
            ? _SelectButton(
                onPressed: widget.onPressed,
                isContain: widget.isContain,
                isHome: widget.isHome,
              )
            : const SizedBox(height: 0),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: !modifyFlag
                        ? Container(
                            alignment: Alignment.centerLeft,
                            height: 55,
                            padding: EdgeInsets.only(
                                left: widget.selectFlag ? 0 : 10),
                            child: Text(
                              widget.item.content,
                              style: TextStyle(
                                  fontFamily: 'SCDream',
                                  decoration:
                                      (widget.isContain && widget.isHome)
                                          ? TextDecoration.lineThrough
                                          : null,
                                  backgroundColor:
                                      (widget.isContain && !widget.isHome)
                                          ? const Color(0xFFC4E4FA)
                                          : null,
                                  fontSize: 16,
                                  color: BLACK_COLOR),
                              textAlign: TextAlign.start,
                            ),
                          )
                        : CustomAddTextField(
                            item: widget.item,
                            modifyItem: widget.modifyItem,
                            changeModifyFlag: changeModifyFlag,
                            isCompleted: widget.isContain,
                          ),
                  ),
                  (!widget.isRecommendItem || modifyFlag)
                      ? _MoreButton(
                          item: widget.item,
                          removeItem: widget.removeItem!,
                          isContain: widget.isContain,
                          changeModifyFlag: changeModifyFlag)
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              ),
              Divider(
                color: const Color(0xFF616161),
                thickness: 1,
                height: 0,
                indent: modifyFlag ? 44 : 0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 9,
        )
      ],
    );
  }

  void changeModifyFlag() {
    setState(() {
      modifyFlag = !modifyFlag;
    });
  }
}

class _SelectButton extends StatelessWidget {
  final Function() onPressed;
  final bool isContain;
  final bool isHome;

  const _SelectButton({
    super.key,
    required this.onPressed,
    required this.isHome,
    required this.isContain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(maxHeight: 26, maxWidth: 26),
          splashRadius: 15,
          icon: isContain
              ? (isHome
                  ? Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Remix.check_line,
                        size: 24,
                        color: Color(0xFF616161),
                      ),
                    )
                  : const Icon(
                      Icons.check_box_rounded,
                      color: PRIMARY_COLOR,
                      size: 27,
                    ))
              : (isHome
                  ? Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF616161)),
                    )
                  : const Icon(
                      Icons.check_box_outline_blank_rounded,
                      color: PRIMARY_COLOR,
                      size: 27,
                    ))),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final ItemModel item;
  final Function removeItem;
  final Function changeModifyFlag;
  final bool isContain;

  const _MoreButton(
      {super.key,
      required this.item,
      required this.removeItem,
      required this.changeModifyFlag,
      required this.isContain});

  @override
  Widget build(BuildContext context) {
    final GlobalKey buttonKey = GlobalKey(); // IconButton에 대한 별도의 GlobalKey를 생성

    return IconButton(
      key: buttonKey, // IconButton에 GlobalKey를 연결
      padding: const EdgeInsets.all(0),
      splashRadius: 15,
      constraints: const BoxConstraints(maxWidth: 35, minWidth: 35),
      onPressed: () {
        // 버튼의 위치와 크기를 얻음
        final RenderBox renderBox =
            buttonKey.currentContext!.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final position = renderBox.localToGlobal(Offset.zero);

        // IconButton의 아래에 오버레이를 표시
        late OverlayEntry moreButtonOverlay;
        moreButtonOverlay = OverlayEntry(
          builder: (context) => Stack(
            children: <Widget>[
              // 외부를 클릭하면 오버레이를 제거하는 GestureDetector
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => moreButtonOverlay.remove(),
                  child: Container(),
                ),
              ),

              // 오버레이 내용
              Positioned(
                top: position.dy + size.height - 10,
                left: position.dx - 95,
                child: Material(
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: GREY_COLOR.withOpacity(0.2),
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          moreButtonOverlay.remove(); // 버튼을 클릭하면 오버레이를 제거
                          changeModifyFlag();
                        },
                        child: const Text(
                          '수정하기',
                          style: TextStyle(fontFamily: 'SCDream', fontSize: 10),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: GREY_COLOR.withOpacity(0.2),
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          removeItem(item, isContain);
                          moreButtonOverlay.remove(); // 버튼을 클릭하면 오버레이를 제거
                        },
                        child: const Text(
                          '삭제하기',
                          style: TextStyle(fontFamily: 'SCDream', fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        Overlay.of(context).insert(moreButtonOverlay);
      },
      icon: const Icon(
        Remix.more_line,
        size: 20,
        color: Color(0xFF616161),
      ),
    );
  }
}
