import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:keyket/bucket/component/custom_add_text_field.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/recommend/component/hash_tag_item.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ListItem extends StatefulWidget {
  final bool isNeedSelectButton;
  final bool isNeedMoreButton;
  final bool isRecommendItem;

  final bool isContain;
  final Function() onPressed;
  final Function? removeItem;
  final Function? modifyItem;
  final ItemModel item;

  const ListItem({
    super.key,
    required this.isNeedSelectButton,
    required this.isContain,
    required this.isRecommendItem,
    required this.isNeedMoreButton,
    required this.onPressed,
    this.removeItem,
    this.modifyItem,
    required this.item,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool modifyFlag = false;

  @override
  Widget build(BuildContext context) {
    return widget.isRecommendItem
        ? Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    (widget.item as RecommendItemModel).image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop), // 투명도 적용
              ),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          width: 200 / 390 * 100.w,
                          height: 140 / 390 * 100.w,
                          imageUrl: (widget.item as RecommendItemModel).image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200 / 390 * 100.w,
                              height: 140 / 390 * 100.w,
                              color: Colors.grey[300],
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getHashTagItem(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (widget.isNeedSelectButton && !modifyFlag)
                        ? _SelectButton(
                            onPressed: widget.onPressed,
                            isContain: widget.isContain,
                          )
                        : const SizedBox(height: 0),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            top: 5, left: widget.isNeedSelectButton ? 0 : 10),
                        child: Text(
                          widget.item.content,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'SCDream',
                              backgroundColor: widget.isContain
                                  ? const Color(0xFFC4E4FA)
                                  : null,
                              fontSize: 16,
                              color: BLACK_COLOR),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        : Row(
            children: [
              (widget.isNeedSelectButton && !modifyFlag)
                  ? _SelectButton(
                      onPressed: widget.onPressed,
                      isContain: widget.isContain,
                    )
                  : const SizedBox(height: 0),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: !modifyFlag
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: widget.isNeedSelectButton ? 0 : 10),
                                  child: Text(
                                    widget.item.content,
                                    style: TextStyle(
                                        fontFamily: 'SCDream',
                                        height: 1.6,
                                        decoration: widget.isContain
                                            ? TextDecoration.lineThrough
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
                        (widget.isNeedMoreButton && !modifyFlag)
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

  List<Padding> getHashTagItem() {
    List<Padding> childs = [];
    childs.add(Padding(
      padding: EdgeInsets.only(top: (140 / 390 * 100.w - 105) / 4),
      child: HashTagItem(
        region: (widget.item as RecommendItemModel).region,
        canSelect: false,
      ),
    ));

    for (var theme in (widget.item as RecommendItemModel).theme) {
      childs.add(Padding(
        padding: EdgeInsets.only(top: (140 / 390 * 100.w - 105) / 4),
        child: HashTagItem(
          theme: theme,
          canSelect: false,
        ),
      ));
    }

    return childs;
  }
}

class _SelectButton extends StatelessWidget {
  final Function() onPressed;
  final bool isContain;

  const _SelectButton({
    super.key,
    required this.onPressed,
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
              ? const Icon(
                  Icons.check_box_rounded,
                  color: PRIMARY_COLOR,
                  size: 27,
                )
              : const Icon(
                  Icons.check_box_outline_blank_rounded,
                  color: PRIMARY_COLOR,
                  size: 27,
                )),
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
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
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
                          backgroundColor: const Color(0xFFD9D9D9),
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


// class ListItem extends StatefulWidget {
//   final bool isNeedSelectButton;
//   final bool isNeedMoreButton;
//   final bool isHome;

//   final bool isContain;
//   final Function() onPressed;
//   final Function? removeItem;
//   final Function? modifyItem;
//   final ItemModel item;

//   const ListItem({
//     super.key,
//     required this.isNeedSelectButton,
//     required this.isContain,
//     required this.isHome,
//     required this.isNeedMoreButton,
//     required this.onPressed,
//     this.removeItem,
//     this.modifyItem,
//     required this.item,
//   });

//   @override
//   State<ListItem> createState() => _ListItemState();
// }

// class _ListItemState extends State<ListItem> {
//   bool modifyFlag = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         (widget.isNeedSelectButton && !modifyFlag)
//             ? _SelectButton(
//                 onPressed: widget.onPressed,
//                 isContain: widget.isContain,
//                 isHome: widget.isHome,
//               )
//             : const SizedBox(height: 0),
//         Expanded(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: !modifyFlag
//                         ? Container(
//                             alignment: Alignment.centerLeft,
//                             padding: EdgeInsets.only(
//                                 top: 8,
//                                 bottom: 8,
//                                 left: widget.isNeedSelectButton ? 0 : 10),
//                             child: Text(
//                               widget.item.content,
//                               style: TextStyle(
//                                   fontFamily: 'SCDream',
//                                   height: 1.6,
//                                   letterSpacing: 1.5,
//                                   decoration:
//                                       (widget.isContain && widget.isHome)
//                                           ? TextDecoration.lineThrough
//                                           : null,
//                                   backgroundColor:
//                                       (widget.isContain && !widget.isHome)
//                                           ? const Color(0xFFC4E4FA)
//                                           : null,
//                                   fontSize: 16,
//                                   color: BLACK_COLOR),
//                               textAlign: TextAlign.start,
//                             ),
//                           )
//                         : CustomAddTextField(
//                             item: widget.item,
//                             modifyItem: widget.modifyItem,
//                             changeModifyFlag: changeModifyFlag,
//                             isCompleted: widget.isContain,
//                           ),
//                   ),
//                   (widget.isNeedMoreButton && !modifyFlag)
//                       ? _MoreButton(
//                           item: widget.item,
//                           removeItem: widget.removeItem!,
//                           isContain: widget.isContain,
//                           changeModifyFlag: changeModifyFlag)
//                       : const SizedBox(
//                           width: 0,
//                         ),
//                 ],
//               ),
//               Divider(
//                 color: const Color(0xFF616161),
//                 thickness: 1,
//                 height: 0,
//                 indent: modifyFlag ? 44 : 0,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           width: 9,
//         )
//       ],
//     );
//   }

//   void changeModifyFlag() {
//     setState(() {
//       modifyFlag = !modifyFlag;
//     });
//   }
// }

// class _SelectButton extends StatelessWidget {
//   final Function() onPressed;
//   final bool isContain;
//   final bool isHome;

//   const _SelectButton({
//     super.key,
//     required this.onPressed,
//     required this.isHome,
//     required this.isContain,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16.0),
//       child: IconButton(
//           onPressed: onPressed,
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(maxHeight: 26, maxWidth: 26),
//           splashRadius: 15,
//           icon: isContain
//               ? (isHome
//                   ? Container(
//                       height: 22,
//                       width: 22,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.white,
//                       ),
//                       alignment: Alignment.center,
//                       child: const Icon(
//                         Remix.check_line,
//                         size: 24,
//                         color: Color(0xFF616161),
//                       ),
//                     )
//                   : const Icon(
//                       Icons.check_box_rounded,
//                       color: PRIMARY_COLOR,
//                       size: 27,
//                     ))
//               : (isHome
//                   ? Container(
//                       height: 22,
//                       width: 22,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: const Color(0xFF616161)),
//                     )
//                   : const Icon(
//                       Icons.check_box_outline_blank_rounded,
//                       color: PRIMARY_COLOR,
//                       size: 27,
//                     ))),
//     );
//   }
// }

// class _MoreButton extends StatelessWidget {
//   final ItemModel item;
//   final Function removeItem;
//   final Function changeModifyFlag;
//   final bool isContain;

//   const _MoreButton(
//       {super.key,
//       required this.item,
//       required this.removeItem,
//       required this.changeModifyFlag,
//       required this.isContain});

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey buttonKey = GlobalKey(); // IconButton에 대한 별도의 GlobalKey를 생성

//     return IconButton(
//       key: buttonKey, // IconButton에 GlobalKey를 연결
//       padding: const EdgeInsets.all(0),
//       splashRadius: 15,
//       constraints: const BoxConstraints(maxWidth: 35, minWidth: 35),
//       onPressed: () {
//         // 버튼의 위치와 크기를 얻음
//         final RenderBox renderBox =
//             buttonKey.currentContext!.findRenderObject() as RenderBox;
//         final size = renderBox.size;
//         final position = renderBox.localToGlobal(Offset.zero);

//         // IconButton의 아래에 오버레이를 표시
//         late OverlayEntry moreButtonOverlay;
//         moreButtonOverlay = OverlayEntry(
//           builder: (context) => Stack(
//             children: <Widget>[
//               // 외부를 클릭하면 오버레이를 제거하는 GestureDetector
//               Positioned.fill(
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.opaque,
//                   onTap: () => moreButtonOverlay.remove(),
//                   child: Container(),
//                 ),
//               ),

//               // 오버레이 내용
//               Positioned(
//                 top: position.dy + size.height - 10,
//                 left: position.dx - 95,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: Row(
//                     children: <Widget>[
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: const Color(0xFFD9D9D9),
//                           padding: EdgeInsets.zero,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           moreButtonOverlay.remove(); // 버튼을 클릭하면 오버레이를 제거
//                           changeModifyFlag();
//                         },
//                         child: const Text(
//                           '수정하기',
//                           style: TextStyle(fontFamily: 'SCDream', fontSize: 10),
//                         ),
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: const Color(0xFFD9D9D9),
//                           padding: EdgeInsets.zero,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               bottomRight: Radius.circular(10),
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           removeItem(item, isContain);
//                           moreButtonOverlay.remove(); // 버튼을 클릭하면 오버레이를 제거
//                         },
//                         child: const Text(
//                           '삭제하기',
//                           style: TextStyle(fontFamily: 'SCDream', fontSize: 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//         Overlay.of(context).insert(moreButtonOverlay);
//       },
//       icon: const Icon(
//         Remix.more_line,
//         size: 20,
//         color: Color(0xFF616161),
//       ),
//     );
//   }
// }
