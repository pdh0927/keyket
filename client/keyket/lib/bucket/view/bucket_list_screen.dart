import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/component/bucket_list_card.dart';
import 'package:keyket/bucket/const/text_style.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/common/component/custom_input_dialog.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';

enum SortItem { name, latest, oldest }

class BucketListListScreen extends ConsumerStatefulWidget {
  const BucketListListScreen({super.key});

  @override
  ConsumerState<BucketListListScreen> createState() =>
      _BucketListListScreenScreenState();
}

class _BucketListListScreenScreenState
    extends ConsumerState<BucketListListScreen> {
  bool isShared = false;
  SortItem selectedSortItem = SortItem.name;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '버킷',
        actions: [
          IconButton(
              onPressed: () async {
                String? name = await showCustomInputDialog(
                  context,
                  '새로운 버킷 만들기',
                );
                if (name != null) {
                  Map<String, dynamic> newBucketData = {
                    'name': name,
                    'image': '',
                    'isShared': false,
                    'users': [ref.read(myInformationProvider)!.id],
                    'host': ref.read(myInformationProvider)!.id,
                    'completedCustomItemList': [],
                    'completedRecommendItemList': [],
                    'uncompletedCustomItemList': [],
                    'uncompletedRecommendItemList': [],
                    'createdAt': DateTime.now(),
                    'updatedAt': DateTime.now(),
                  };

                  ref
                      .read(myBucketListListProvider.notifier)
                      .addNewBucket(newBucketData);
                }
              },
              icon: Icon(Remix.add_line)),
        ],
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
                          isShared = false;
                        });
                      },
                      isShared: isShared),
                  _ToggleMenuButton(
                      title: '공유',
                      onTap: () {
                        setState(() {
                          isShared = true;
                        });
                      },
                      isShared: !isShared)
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: PRIMARY_COLOR, thickness: 1, height: 0),
              Align(
                alignment: Alignment.centerRight,
                child: _SortPopupMenuButton(
                  isShared: isShared,
                ),
              ),
              Expanded(
                child: isShared
                    ? const _SharedBucketListList()
                    : const _MyBucketListList(),
              )
            ],
          ),
        ));
  }
}

class _MyBucketListList extends ConsumerWidget {
  const _MyBucketListList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BucketListModel> myBucketListList =
        ref.watch(myBucketListListProvider).values.toList();
    return _BucketListList(bucketListList: myBucketListList);
  }
}

class _SharedBucketListList extends ConsumerWidget {
  const _SharedBucketListList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .read(sharedBucketListListProvider.notifier)
        .getBucketList(ref.read(myInformationProvider)!.id, true);
    final List<BucketListModel> sharedBucketListList =
        ref.watch(sharedBucketListListProvider).values.toList();
    return _BucketListList(bucketListList: sharedBucketListList);
  }
}

class _BucketListList extends StatelessWidget {
  final List<BucketListModel> bucketListList;

  const _BucketListList({super.key, required this.bucketListList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bucketListList.length,
      itemBuilder: (_, index) {
        final pItem = bucketListList[index];
        return GestureDetector(child: BucketListCard.fromModel(model: pItem));
      },
      separatorBuilder: (_, index) {
        // 분리 시 들어갈 항목
        return const SizedBox(height: 16.0);
      },
    );
  }
}

class _ToggleMenuButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isShared;

  const _ToggleMenuButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.isShared});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 105,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isShared
                  ? const Color(0xFF1A1A1A).withOpacity(0.2)
                  : PRIMARY_COLOR.withOpacity(0.35),
              borderRadius: BorderRadius.circular(5)),
          child: Text(title, style: toggleButtonTextStlye)),
    );
  }
}

class _SortPopupMenuButton extends ConsumerWidget {
  final bool isShared;

  const _SortPopupMenuButton({super.key, required this.isShared});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<SortItem>(
      icon: const Icon(Remix.equalizer_line, size: 21),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortItem>>[
        PopupMenuItem<SortItem>(
          value: SortItem.name,
          onTap: () {
            isShared
                ? ref.read(sharedBucketListListProvider.notifier).sortByName()
                : ref.read(myBucketListListProvider.notifier).sortByName();
          },
          child: Text('이름 순', style: popupMenuTextStlye),
        ),
        PopupMenuItem<SortItem>(
          value: SortItem.latest,
          onTap: () {
            isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .sortByUpdatedAt()
                : ref.read(myBucketListListProvider.notifier).sortByUpdatedAt();
          },
          child: Text('업데이트 순', style: popupMenuTextStlye),
        ),
        PopupMenuItem<SortItem>(
          value: SortItem.oldest,
          onTap: () {
            isShared
                ? ref
                    .read(sharedBucketListListProvider.notifier)
                    .sortByCreatedAt()
                : ref.read(myBucketListListProvider.notifier).sortByCreatedAt();
          },
          child: Text('생성 순', style: popupMenuTextStlye),
        ),
      ],
      position: PopupMenuPosition.under,
    );
  }
}
