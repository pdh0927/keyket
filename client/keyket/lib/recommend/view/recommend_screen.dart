import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/custom_input_dialog.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/recommend/component/hash_tag_item_list.dart';
import 'package:keyket/recommend/const/data.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:keyket/recommend/provider/recommend_provider.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dots_indicator/dots_indicator.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  bool selectFlag = false;
  List<int> selectedRecommendIndexList = [];

  @override
  void initState() {
    selectedRecommendIndexList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recommendedItems = ref.watch(recommendItemListProvider);
    final selectedFilterList = ref.watch(selectedFilterListProvider);

    return DefaultLayout(
        title: '추천',
        actions: [
          InkWell(
            onTap: () {},
            child: const SizedBox(
              height: 10,
              child: Icon(Remix.search_line, color: BLACK_COLOR, size: 25),
            ),
          ),
          const SizedBox(width: 25)
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            // Flitering
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _SelectBox(),
            ),
            SizedBox(height: selectedFilterList.isNotEmpty ? 8 : 0),
            // HashTag
            SizedBox(
              width: 100.w - 32,
              child: const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HashTagItemList(),
              ),
            ),
            const SizedBox(height: 16),
            selectFlag == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Remix.check_line, size: 25),
                          Text('추천 목록 List', style: dropdownTextStyle)
                        ],
                      ),
                      // List 선택 버튼
                      _ListSelectButton(onTap: () {
                        showBottomSheet();
                      }),
                    ],
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // 선택 해제 버튼
                    _CustonUnderlineButton(
                        onPressed: () {
                          setState(() {
                            selectFlag = !selectFlag;
                            selectedRecommendIndexList = [];
                          });
                        },
                        icon: Remix.close_line,
                        text: '선택 해제'),

                    const SizedBox(width: 20),
                    // 버킷 저장 버튼
                    _CustonUnderlineButton(
                        onPressed: () {}, icon: Remix.add_line, text: '버킷 저장'),
                  ]),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                // 추천 리스트
                itemCount: recommendedItems.length,
                itemBuilder: (context, index) {
                  bool isContain = selectedRecommendIndexList.contains(index);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDottedLine(
                          index, true, recommendedItems.length), // 구분 점선
                      _RecommendItem(
                          // 추천 아이템
                          selectFlag: selectFlag,
                          isContain: isContain,
                          onPressed: () {
                            setState(() {
                              if (isContain) {
                                selectedRecommendIndexList.remove(index);
                              } else {
                                selectedRecommendIndexList.add(index);
                              }
                            });
                          },
                          content: recommendedItems[index].content),
                      const Divider(
                        // 구분선
                        color: Color(0xFF616161),
                        thickness: 1,
                        height: 0,
                      ),
                      getDottedLine(
                          index, false, recommendedItems.length) // 구분 점선
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }

  dynamic getDottedLine(int index, bool isFirst, int totalLength) {
    if ((index == 0 && isFirst) || (index == totalLength - 1) && !isFirst) {
      return Column(
        children: [
          SizedBox(height: !isFirst ? 24 : 0),
          const DottedLine(
            dashLength: 5,
            dashGapLength: 2,
            lineThickness: 1,
            dashColor: PRIMARY_COLOR,
          ),
        ],
      );
    } else {
      return const SizedBox(height: 0);
    }
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 80.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              Container(
                  width: 40.w,
                  height: 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF616161))),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: bucketList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 처음 요소를 새로운 버킷 만들기로
                        return _AddNewBucketItem(onTap: () async {
                          Navigator.pop(context);
                          await showCustomInputDialog(context, '새로운 버킷 만들기');
                          setState(() {
                            selectFlag = !selectFlag;
                          });
                        });
                      } else {
                        return _OrdinaryBucketItem(
                            bucketName: bucketList[index - 1]['name'],
                            bucketImage: bucketList[index - 1]['image'],
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectFlag = !selectFlag;
                              });
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ListSelectButton extends StatelessWidget {
  const _ListSelectButton({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Remix.checkbox_line,
            size: 25,
            color: BLACK_COLOR,
          ),
          const SizedBox(width: 5),
          Text('List 선택하기', style: dropdownTextStyle),
        ],
      ),
    );
  }
}

class _CustonUnderlineButton extends StatelessWidget {
  const _CustonUnderlineButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  final IconData icon;
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: BLACK_COLOR,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(text, style: dropdownTextStyle)
          ],
        ),
      ),
    );
  }
}

class _AddNewBucketItem extends StatelessWidget {
  const _AddNewBucketItem({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: const Icon(
                        Icons.add_box,
                        size: 66,
                        color: Color(0xFFd9d9d9),
                      )),
                  const SizedBox(width: 24),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    child: Text(
                      '새로운 버킷 만들기',
                      style: bucketTextStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFd9d9d9),
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}

class _OrdinaryBucketItem extends StatelessWidget {
  const _OrdinaryBucketItem(
      {super.key,
      required this.bucketName,
      required this.bucketImage,
      required this.onTap});

  final String bucketName;
  final String? bucketImage;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: bucketImage != null
                          ? Image.asset(bucketImage!, width: 60)
                          : Image.asset('asset/img/default_bucket.png',
                              width: 60)),
                  const SizedBox(width: 24),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    child: Text(
                      bucketName,
                      style: bucketTextStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFd9d9d9),
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}

class _RecommendItem extends StatelessWidget {
  const _RecommendItem(
      {super.key,
      required this.selectFlag,
      required this.isContain,
      required this.onPressed,
      required this.content});
  final bool selectFlag;
  final bool isContain;
  final Function() onPressed;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        selectFlag == true
            ? IconButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                splashRadius: 15,
                icon: isContain
                    ? const Icon(Icons.check_box_rounded, color: PRIMARY_COLOR)
                    : const Icon(Icons.check_box_outline_blank_rounded,
                        color: PRIMARY_COLOR))
            : const SizedBox(height: 0),
        Container(
          alignment: Alignment.centerLeft,
          height: 55,
          padding: EdgeInsets.only(left: selectFlag == true ? 0 : 10),
          child: Text(
            content,
            style: dropdownTextStyle,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class _CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final bool isSelected;

  _CustomTextButton(
      {required this.label,
      required this.onPressed,
      required this.borderRadius,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: GREY_COLOR.withOpacity(0.2),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: isSelected
                  ? dropdownTextStyle.copyWith(color: PRIMARY_COLOR)
                  : dropdownTextStyle,
            ),
            const SizedBox(width: 15),
            Icon(
              Remix.arrow_down_s_line,
              color: GREY_COLOR.withOpacity(0.6),
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}

class _SelectBox extends StatefulWidget {
  const _SelectBox({super.key});

  @override
  State<_SelectBox> createState() => __SelectBoxState();
}

class __SelectBoxState extends State<_SelectBox> {
  bool isLocationSelected = false;
  bool isThemeSelected = false;
  OverlayEntry? overlayEntry;

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay(
      BuildContext context, List<String> optionList, String label) {
    hideOverlay();

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          height: label == '지역' ? 180 : 130,
          top: offset.dy + size.height, // 'top' 속성 조정
          left: offset.dx,
          child: GestureDetector(
            onTap: () {
              hideOverlay();
              setState(() {
                isLocationSelected = false;
              });
            },
            child: _OptionGrid(
              label: label,
              optionsList: optionList,
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _CustomTextButton(
            label: "지역",
            onPressed: () {
              if (isLocationSelected) {
                hideOverlay();
                setState(() {
                  isLocationSelected = false;
                });
              } else {
                showOverlay(context, locationList, '지역');
                setState(() {
                  isLocationSelected = !isLocationSelected;
                  isThemeSelected = false;
                });
              }
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            isSelected: isLocationSelected,
          ),
          const VerticalDivider(width: 1, color: Colors.white),
          _CustomTextButton(
            label: "테마",
            onPressed: () {
              if (isThemeSelected) {
                hideOverlay();
                setState(() {
                  isThemeSelected = false;
                });
              } else {
                showOverlay(context, themeList, '테마');
                setState(() {
                  isThemeSelected = !isThemeSelected;
                  isLocationSelected = false;
                });
              }
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            isSelected: isThemeSelected,
          ),
        ],
      ),
    );
  }
}

class _OptionGrid extends ConsumerStatefulWidget {
  final List<String> optionsList;
  final String label;

  _OptionGrid({
    required this.label,
    required this.optionsList,
  });

  @override
  __OptionGridState createState() => __OptionGridState();
}

class __OptionGridState extends ConsumerState<_OptionGrid> {
  int currentIndexPage = 0;
  final _controller = PageController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        currentIndexPage = _controller.page!.toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int numOfPages = widget.label == '지역'
        ? (widget.optionsList.length / 12).ceil()
        : (widget.optionsList.length / 6).ceil();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.grey[350],
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: numOfPages,
                itemBuilder: (context, index) {
                  int start = widget.label == '지역' ? index * 12 : index * 6;
                  int end = widget.label == '지역'
                      ? (start + 12 > widget.optionsList.length
                          ? widget.optionsList.length
                          : start + 12)
                      : (start + 6 > widget.optionsList.length
                          ? widget.optionsList.length
                          : start + 6);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: GridView.count(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: widget.label == '지역'
                          ? 58 / 36
                          : 75 / 36, // 아이템 가로/세로 비율 지정
                      crossAxisCount: widget.label == '지역' ? 4 : 3,
                      children: widget.optionsList
                          .sublist(start, end)
                          .map((location) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextButton(
                            onPressed: () {
                              ref
                                  .read(selectedFilterListProvider.notifier)
                                  .onSelected(context, widget.label, location);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: InkResponse(
                              onTap: () {
                                ref
                                    .read(selectedFilterListProvider.notifier)
                                    .onSelected(
                                        context, widget.label, location);
                              },
                              containedInkWell: true,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  location,
                                  style: optionTextStyle,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            DotsIndicator(
              dotsCount: numOfPages,
              position: currentIndexPage,
              decorator: const DotsDecorator(
                color: Colors.white, // Inactive color
                activeColor: GREY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
