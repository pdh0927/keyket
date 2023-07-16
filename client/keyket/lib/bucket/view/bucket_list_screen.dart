import 'package:flutter/material.dart';
import 'package:keyket/bucket/component/bucket_card.dart';
import 'package:keyket/bucket/const/data.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:remixicon/remixicon.dart';

enum SortItem { name, latest, oldest }

class BucketListScreen extends StatefulWidget {
  const BucketListScreen({super.key});

  @override
  State<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  bool flag = true; // true면 나, false면 공유
  SortItem selectedSortItem = SortItem.name;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '버킷',
        child: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 40, bottom: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ToggleMenuButton(
                      title: '나',
                      onTap: () {
                        setState(() {
                          flag = true;
                        });
                      },
                      flag: flag),
                  _ToggleMenuButton(
                      title: '공유',
                      onTap: () {
                        setState(() {
                          flag = false;
                        });
                      },
                      flag: !flag)
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: PRIMARY_COLOR, thickness: 1, height: 0),
              Align(
                alignment: Alignment.centerRight,
                child: _SortPopupMenuButton(
                    selectedSortItem: selectedSortItem, onSelected: onSelected),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: bucketList.length,
                  itemBuilder: (_, index) {
                    final pItem = bucketList[index];
                    return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (_) =>
                          //         RestaurantDetailScreen(id: pItem.id)));
                        },
                        child: BucketCard.fromModel(model: pItem));
                  },
                  separatorBuilder: (_, index) {
                    // 분리 시 들어갈 항목
                    return const SizedBox(height: 16.0);
                  },
                ),
              )
            ],
          ),
        ));
  }

  void onSelected(SortItem item) {
    setState(() {
      selectedSortItem = item;
    });
  }
}

class _ToggleMenuButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool flag;

  const _ToggleMenuButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 105,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: flag
                  ? PRIMARY_COLOR.withOpacity(0.35)
                  : const Color(0xFF1A1A1A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(5)),
          child: Text(title, style: toggleButtonTextStlye)),
    );
  }
}

class _SortPopupMenuButton extends StatelessWidget {
  final SortItem selectedSortItem;
  final Function(SortItem) onSelected;

  const _SortPopupMenuButton(
      {super.key, required this.selectedSortItem, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortItem>(
      icon: const Icon(Remix.equalizer_line, size: 21),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortItem>>[
        PopupMenuItem<SortItem>(
          value: SortItem.name,
          child: Text('이름 순', style: popupMenuTextStlye),
        ),
        PopupMenuItem<SortItem>(
          value: SortItem.latest,
          child: Text('최신 순', style: popupMenuTextStlye),
        ),
        PopupMenuItem<SortItem>(
          value: SortItem.oldest,
          child: Text('오래된 순', style: popupMenuTextStlye),
        ),
      ],
      position: PopupMenuPosition.under,
    );
  }
}
