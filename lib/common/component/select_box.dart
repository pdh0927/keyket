import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/const/text_style.dart';
import 'package:keyket/recommend/const/text_style.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';
import 'package:remixicon/remixicon.dart';

class SelectBox extends StatefulWidget {
  const SelectBox({super.key});

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  bool isLocationSelected = false;
  bool isThemeSelected = false;
  OverlayEntry? overlayEntry;

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay(BuildContext context, String label) {
    hideOverlay();

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 바깥 부분을 누를 때 Overlay를 닫도록 하는 GestureDetector
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  hideOverlay();
                  setState(() {
                    isLocationSelected = false;
                  });
                },
              ),
            ),
            Positioned(
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
                ),
              ),
            ),
          ],
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
                showOverlay(context, '지역');
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
                showOverlay(context, '테마');
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
  final String label;

  _OptionGrid({
    required this.label,
  });

  @override
  __OptionGridState createState() => __OptionGridState();
}

class __OptionGridState extends ConsumerState<_OptionGrid> {
  int currentIndexPage = 0;
  final _controller = PageController();
  var optionsList;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        currentIndexPage = _controller.page!.toInt();
      });
    });
    super.initState();
    optionsList =
        widget.label == '지역' ? RecommendRegion.values : RecommendTheme.values;
  }

  @override
  Widget build(BuildContext context) {
    int numOfPages = widget.label == '지역'
        ? (optionsList.length / 12).ceil()
        : (optionsList.length / 6).ceil();
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
                      ? (start + 12 > optionsList.length
                          ? optionsList.length
                          : start + 12)
                      : (start + 6 > optionsList.length
                          ? optionsList.length
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
                      children:
                          optionsList.sublist(start, end).map<Widget>((option) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: InkResponse(
                              onTap: () {
                                widget.label == '지역'
                                    ? ref
                                        .read(selectedRegionFilterProvider
                                            .notifier)
                                        .onSelected(option)
                                    : ref
                                        .read(selectedThemeFilterListProvider
                                            .notifier)
                                        .onSelected(context, option);
                              },
                              containedInkWell: true,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.label == '지역'
                                      ? recommendRegionKor[option.index]
                                      : recommendThemeKor[option.index],
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

class _CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final bool isSelected;

  const _CustomTextButton(
      {required this.label,
      required this.onPressed,
      required this.borderRadius,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
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
                  ? dropdownTextStyle
                  : dropdownTextStyle.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 15),
            Icon(
              Remix.arrow_down_s_line,
              color: isSelected ? Colors.black : Colors.white,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
