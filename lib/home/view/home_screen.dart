import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keyket/bucket/model/bucket_list_model.dart';
import 'package:keyket/bucket/provider/bucket_list_provider.dart';
import 'package:keyket/bucket/view/bucket_list_detail_screen.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/layout/default_layout.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:keyket/home/const/data.dart';
import 'package:keyket/home/const/style.dart';
import 'package:keyket/home/provider.dart/banner_advertisement_provider.dart';
import 'package:keyket/home/provider.dart/index_provider.dart';
import 'package:keyket/home/provider.dart/recommend_region_provider.dart';
import 'package:keyket/home/provider.dart/weather_provider.dart';
import 'package:keyket/my/component/my_notification.dart';
import 'package:keyket/tmp/saveToFirestore.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String authStatus = 'Unknown';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initPlugin());
    super.initState();
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => authStatus = '$status');
    }

    // final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    // print(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '홈',
      actions: [
        IconButton(
          icon: const Icon(Remix.notification_4_line, size: 28),
          splashRadius: 20,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyNotification(),
              ),
            );
          },
        )
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _AdvertisementContainer(
              //   adWidth: MediaQuery.of(context).size.width.toInt() - 32,
              //   adMaxHeight: 60,
              // ),
              WeatherContainer(),
              SizedBox(height: 20),
              _RegionImageContainer(),
              SizedBox(height: 30),
              _FixedBucketList(),
              SizedBox(height: 30),
              BucketListRecommend(), SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvertisementContainer extends ConsumerStatefulWidget {
  final int adWidth;
  final int adMaxHeight;

  const _AdvertisementContainer(
      {super.key, required this.adWidth, required this.adMaxHeight});

  @override
  ConsumerState<_AdvertisementContainer> createState() =>
      _AdvertisementContainerState();
}

class _AdvertisementContainerState
    extends ConsumerState<_AdvertisementContainer> {
  @override
  void initState() {
    if (ref.read(bannerAdvertisementProvider) == null) {
      ref
          .read(bannerAdvertisementProvider.notifier)
          .loadAd(widget.adWidth, widget.adMaxHeight);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAdvertisement = ref.watch(bannerAdvertisementProvider);
    if (bannerAdvertisement == null) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: widget.adWidth.toDouble(),
        height: widget.adMaxHeight.toDouble(),
        child: AdWidget(ad: bannerAdvertisement),
      );
    }
  }
}

class _FixedBucketList extends ConsumerStatefulWidget {
  const _FixedBucketList({
    super.key,
  });

  @override
  ConsumerState<_FixedBucketList> createState() => _FixedBucketListState();
}

class _FixedBucketListState extends ConsumerState<_FixedBucketList> {
  BucketListModel? fixedBucketList;

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(myInformationProvider);

    if (info != null) {
      if (ref.watch(myBucketListListProvider) != null &&
          ref.watch(sharedBucketListListProvider) != null) {
        if (ref.watch(myBucketListListProvider)!.isNotEmpty ||
            ref.watch(sharedBucketListListProvider)!.isNotEmpty) {
          fixedBucketList = ref
                  .read(myBucketListListProvider.notifier)
                  .getBucketListModel(info.fixedBucket) ??
              ref
                  .read(sharedBucketListListProvider.notifier)
                  .getBucketListModel(info.fixedBucket);
        }
      } else {
        ref
            .read(myBucketListListProvider.notifier)
            .getBucketList(info.id, false);

        ref
            .read(sharedBucketListListProvider.notifier)
            .getBucketList(info.id, true);
      }
    }

    if (fixedBucketList == null) {
      if (info != null && info.fixedBucket == '') {
        return Column(
          children: [
            Row(
              children: [
                Text('고정된 버킷', style: homeSubTitleStyle),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Remix.pushpin_fill,
                  color: PRIMARY_COLOR,
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 95,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'asset/img/mascot.png',
                      width: 55,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 0,
                    color: PRIMARY_COLOR,
                  ),
                  const Expanded(
                      child: Text(
                    '고정된 버킷이 없습니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontFamily: 'SCDream',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ),
          ],
        );
      }

      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300]!,
          ),
        ),
      );
    } else {
      return Column(children: [
        Row(
          children: [
            Text('고정된 버킷', style: homeSubTitleStyle),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Remix.pushpin_fill,
              color: PRIMARY_COLOR,
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 95,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: PRIMARY_COLOR),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: fixedBucketList!.image == '' ? 20 : 0),
                child: fixedBucketList!.image == ''
                    ? Image.asset(
                        'asset/img/mascot.png',
                        width: 55,
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: fixedBucketList!.image,
                          fit: BoxFit.fill,
                          width: 90,
                          height: 95,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
              ),
              const VerticalDivider(
                thickness: 1,
                width: 0,
                color: PRIMARY_COLOR,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fixedBucketList!.isShared ? '공유 버킷' : '내 버킷',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'SCDream',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '<${fixedBucketList!.name}>',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'SCDream',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BucketListDetailScreen(
                            bucketListId: fixedBucketList!.id,
                            isShared: fixedBucketList!.isShared,
                          )));
                },
                child: Container(
                  width: 60,
                  height: 95,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: const Icon(
                    Remix.arrow_right_circle_fill,
                    color: PRIMARY_COLOR,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        )
      ]);
    }
  }
}

class WeatherContainer extends ConsumerWidget {
  const WeatherContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider);

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 4.0,
            color: PRIMARY_COLOR,
          ),
          bottom: BorderSide(
            width: 4.0,
            color: PRIMARY_COLOR,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 8.0), // 테두리와 내용 사이의 간격을 조정 (선택 사항)
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(regionList[ref.watch(indexProvider)],
                textAlign: TextAlign.center, style: homeSubTitleStyle),
            const SizedBox(width: 2),
            const Icon(
              Remix.map_pin_user_fill,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(width: 10),
            Text(
                '기온 : ${weather['th3'] ?? 0}°C, 강수 확률 : ${weather['pop'] ?? 0}%',
                style: homeSubTitleStyle.copyWith(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}

class _RegionImageContainer extends ConsumerWidget {
  const _RegionImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> recommendRegion = ref.watch(recommmendRegionProvider);

    if (recommendRegion.isEmpty) {
      return _loadingWidget();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _RegionTitle(region: recommendRegion['region']),
            IconButton(
              icon: const Icon(Remix.repeat_2_line, size: 23),
              splashRadius: 20,
              splashColor: Colors.white,
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(
                  minHeight: 25, minWidth: 25, maxHeight: 25, maxWidth: 25),
              onPressed: () {
                ref
                    .read(indexProvider.notifier)
                    .update((state) => Random().nextInt(10));
              },
            )
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildRegionImages(ref, recommendRegion),
          ),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: PRIMARY_COLOR,
            ),
            height: 270 / 390 * 100.w,
          ),
        ),
        const Positioned(
          top: 117, // adjusted based on Container's height
          left: 0,
          right: 0,
          child: Text(
            "키킷이 지역을 추천중입니다!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SCDream',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRegionImages(
      WidgetRef ref, Map<String, dynamic> recommendRegion) {
    return List.generate(recommendRegion['images'].length, (index) {
      bool flag = false;
      return Padding(
        padding: EdgeInsets.only(
            right: index == recommendRegion['images'].length - 1 ? 0 : 15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (recommendRegion['region'] == '창녕' || flag)
                  ? AssetImageWidget(
                      imagePath: recommendRegion['images'][index],
                      width: 230 / 390 * 100.w,
                      height: 230 / 390 * 100.w,
                    )
                  : CachedNetworkImageWidget(
                      imageUrl: recommendRegion['images'][index],
                      width: 230 / 390 * 100.w,
                      height: 230 / 390 * 100.w,
                      changeFlag: () {
                        flag = true;
                        if (recommendRegion['region'] != '창녕') {
                          ref
                              .read(recommmendRegionProvider.notifier)
                              .loadDefaultImagesAndTitles();
                        }
                      }),
            ),
            const SizedBox(height: 12),
            Text(
              recommendRegion['titles'][index],
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'SCDream',
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    });
  }
}

class BucketListItem extends StatelessWidget {
  final String image;
  final String title;

  final VoidCallback onTap;

  const BucketListItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 95,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.asset(
                image,
                width: 95,
                height: 95,
                fit: BoxFit.fill,
              )),
          const VerticalDivider(
            thickness: 1,
            width: 0,
            color: PRIMARY_COLOR,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                height: 1.6,
                fontFamily: 'SCDream',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 60,
              height: 95,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Icon(
                Remix.arrow_right_circle_fill,
                color: PRIMARY_COLOR,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const AssetImageWidget({
    super.key,
    required this.imagePath,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}

class CachedNetworkImageWidget extends ConsumerStatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Function() changeFlag;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.changeFlag,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  ConsumerState createState() => _CachedNetworkImageWidgetState();
}

class _CachedNetworkImageWidgetState
    extends ConsumerState<CachedNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      width: widget.width,
      height: widget.height,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 90,
          height: 90,
          color: Colors.grey[300],
        ),
      ),
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
    );
  }
}

class _RegionTitle extends StatelessWidget {
  final String region;
  const _RegionTitle({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '오늘 ',
            style: homeSubTitleStyle,
          ),
          TextSpan(
            text: region,
            style: homeSubTitleStyle.copyWith(color: PRIMARY_COLOR),
          ),
          TextSpan(
            text: ' 어때요?',
            style: homeSubTitleStyle,
          ),
        ],
      ),
    );
  }
}

class BucketListRecommend extends StatefulWidget {
  const BucketListRecommend({super.key});

  @override
  State<BucketListRecommend> createState() => _BucketListRecommendState();
}

class _BucketListRecommendState extends State<BucketListRecommend> {
  List<Map> recommendList = [
    {
      'title': '여자친구와 함께하는\n부산 여행',
      'thumbImage': 'asset/img/bucketlist/girlfriend_thumb_image.png',
      'resultImage': 'asset/img/bucketlist/girlfriend_result_image.png'
    },
    {
      'title': '부모님을 모시고 가는\n창녕 힐링 여행',
      'thumbImage': 'asset/img/bucketlist/parents_thumb_image.png',
      'resultImage': 'asset/img/bucketlist/parents_result_image.png'
    },
    {
      'title': '친구들과 함께 떠나는\n액티비티 여행',
      'thumbImage': 'asset/img/bucketlist/friends_thumb_image.png',
      'resultImage': 'asset/img/bucketlist/friends_result_image.png'
    },
    {
      'title': '아이와 함께하는\n역사 기행 탐방기',
      'thumbImage': 'asset/img/bucketlist/kids_thumb_image.png',
      'resultImage': 'asset/img/bucketlist/kids_result_image.png'
    }
  ];
  int selectedBucketIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이런 버킷리스트는 어때요?', style: homeSubTitleStyle),
        const SizedBox(height: 10),
        selectedBucketIndex == -1
            ? Column(
                children: getChilds(),
              )
            : Stack(
                children: [
                  Image.asset(
                      recommendList[selectedBucketIndex]['resultImage']),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBucketIndex = -1;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 40, // 원하는 너비
                        height: 40, // 원하는 높이
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  getChilds() {
    List<Widget> childs = [];
    for (int i = 0; i < 4; i++) {
      childs.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: BucketListItem(
          image: recommendList[i]['thumbImage'],
          title: recommendList[i]['title'],
          onTap: () {
            selectBucket(i);
          },
        ),
      ));
    }
    return childs;
  }

  selectBucket(int index) {
    setState(() {
      selectedBucketIndex = index;
    });
  }
}

// class _FixedBucketList extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<_FixedBucketList> createState() => _FixedBucketListState();
// }

// class _FixedBucketListState extends ConsumerState<_FixedBucketList> {
//   BucketListModel? fixedBucketList;
//   List<CustomItemModel> completeCustomItemList = [];
//   List<CustomItemModel> uncompleteCustomItemList = [];
//   List<RecommendItemModel> completeRecommendItemList = [];
//   List<RecommendItemModel> uncompleteRecommendItemList = [];
//   bool isGetItemComplete = false;

//   @override
//   Widget build(BuildContext context) {
//     final info = ref.watch(myInformationProvider);

//     if (info != null) {
//       if (ref.watch(myBucketListListProvider) != null &&
//           ref.watch(sharedBucketListListProvider) != null) {
//         if (ref.watch(myBucketListListProvider)!.isNotEmpty ||
//             ref.watch(sharedBucketListListProvider)!.isNotEmpty) {
//           fixedBucketList = ref
//                   .read(myBucketListListProvider.notifier)
//                   .getBucketListModel(info.fixedBucket) ??
//               ref
//                   .read(sharedBucketListListProvider.notifier)
//                   .getBucketListModel(info.fixedBucket);
//         }
//       } else {
//         ref
//             .read(myBucketListListProvider.notifier)
//             .getBucketList(info.id, false);

//         ref
//             .read(sharedBucketListListProvider.notifier)
//             .getBucketList(info.id, true);
//       }
//     }

//     if (fixedBucketList != null && !isGetItemComplete) {
//       getItems(
//         fixedBucketList!.id,
//         fixedBucketList!.uncompletedCustomItemList,
//         fixedBucketList!.uncompletedRecommendItemList,
//         fixedBucketList!.completedCustomItemList,
//         fixedBucketList!.completedRecommendItemList,
//       );
//     }

//     return getFixedBucketListWidget();
//   }

//   Future<void> getItems(
//     String id,
//     List<String> uncompletedCustomItemList,
//     List<String> uncompletedRecommendItemList,
//     List<String> completedCustomItemList,
//     List<String> completedRecommendItemList,
//   ) async {
//     final bucketListCustomItemState = ref.read(customBucketListItemProvider);
//     final bucketListRecommendItemState =
//         ref.read(recommendBucketListItemProvider);

//     // ID를 로컬에서 찾을 수 있는 경우 Firestore에 접근하지 않음
//     if (!bucketListCustomItemState.containsKey(id) ||
//         !bucketListRecommendItemState.containsKey(id)) {
//       await _fetchAndUpdate(
//         id,
//         uncompletedCustomItemList,
//         uncompletedRecommendItemList,
//         completedCustomItemList,
//         completedRecommendItemList,
//       );
//     } else {
//       if (fixedBucketList!.isShared) {
//         Set<String> currentCustomBucketUncompleteItemIdsSet = Set.from(
//             bucketListCustomItemState[id]
//                     ?.uncompleteItems
//                     .map((item) => item.id) ??
//                 []);
//         Set<String> currentCustomBucketCompleteItemIdsSet = Set.from(
//             bucketListCustomItemState[id]
//                     ?.completeItems
//                     .map((item) => item.id) ??
//                 []);
//         Set<String> currentRecommendBucketUncompleteItemIdsSet = Set.from(
//             bucketListRecommendItemState[id]
//                     ?.uncompleteItems
//                     .map((item) => item.id) ??
//                 []);
//         Set<String> currentRecommendBucketCompleteItemIdsSet = Set.from(
//             bucketListRecommendItemState[id]
//                     ?.completeItems
//                     .map((item) => item.id) ??
//                 []);

//         bool isCustomUncompleteItemsChanged = itemsChanged(
//             currentCustomBucketUncompleteItemIdsSet, uncompletedCustomItemList);
//         bool isCustomCompleteItemsChanged = itemsChanged(
//             currentCustomBucketCompleteItemIdsSet, completedCustomItemList);
//         bool isRecommendUncompleteItemsChanged = itemsChanged(
//             currentRecommendBucketUncompleteItemIdsSet,
//             uncompletedRecommendItemList);
//         bool isRecommendCompleteItemsChanged = itemsChanged(
//             currentRecommendBucketCompleteItemIdsSet,
//             completedRecommendItemList);

//         if (isCustomUncompleteItemsChanged ||
//             isCustomCompleteItemsChanged ||
//             isRecommendUncompleteItemsChanged ||
//             isRecommendCompleteItemsChanged) {
//           await _fetchAndUpdate(
//             id,
//             uncompletedCustomItemList,
//             uncompletedRecommendItemList,
//             completedCustomItemList,
//             completedRecommendItemList,
//           );
//         }
//       }
//     }

//     setState(() {
//       CustomItems tmpCustomItems = ref
//           .read(customBucketListItemProvider)[fixedBucketList!.id]!
//           .deepCopy();
//       RecommendItems tmpRecommendsItems = ref
//           .read(recommendBucketListItemProvider)[fixedBucketList!.id]!
//           .deepCopy();
//       completeCustomItemList = tmpCustomItems.completeItems;
//       uncompleteCustomItemList = tmpCustomItems.uncompleteItems;
//       completeRecommendItemList = tmpRecommendsItems.completeItems;
//       uncompleteRecommendItemList = tmpRecommendsItems.uncompleteItems;

//       isGetItemComplete = true;
//     });
//   }

//   bool itemsChanged(Set<String> current, List<String> newItems) {
//     Set<String> newItemSet = Set.from(newItems);
//     return current.difference(newItemSet).isNotEmpty ||
//         newItemSet.difference(current).isNotEmpty;
//   }

//   _fetchAndUpdate(
//       String id,
//       List<String> uncompletedCustomItemList,
//       List<String> uncompletedRecommendItemList,
//       List<String> completedCustomItemList,
//       List<String> completedRecommendItemList) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     List<String> tmpCustomItemsList = List.from(uncompletedCustomItemList)
//       ..addAll(completedCustomItemList);
//     List<String> tmpRecommendItemsList = List.from(uncompletedRecommendItemList)
//       ..addAll(completedRecommendItemList);

//     // Firestore에서 해당하는 item 불러오기
//     final List<CustomItemModel> fetchedCustomItems =
//         (await _fetchItems(firestore, 'custom', tmpCustomItemsList))
//             .map((item) => item as CustomItemModel)
//             .toList();

//     // 재정렬을 위해 id를 key로 가진 Map 생성
//     final Map<String, CustomItemModel> idToItem = {
//       for (var item in fetchedCustomItems) item.id: item
//     };

//     // 기존 순서(uncomplete앞, complete뒤)에 맞게 재정렬
//     final List<CustomItemModel> customItems =
//         tmpCustomItemsList.map((id) => idToItem[id]!).toList();

//     final List<RecommendItemModel> fetchedRecommendItems =
//         (await _fetchItems(firestore, 'recommend', tmpRecommendItemsList))
//             .map((item) => item as RecommendItemModel)
//             .toList();

//     final Map<String, RecommendItemModel> idToRecommendItem = {
//       for (var item in fetchedRecommendItems) item.id: item
//     };

//     final List<RecommendItemModel> recommendItems =
//         tmpRecommendItemsList.map((id) => idToRecommendItem[id]!).toList();

//     // Firestore에서 가져온 customItems id 목록
//     Set<String> fetchedCustomItemsIds =
//         Set.from(customItems.map((item) => item.id));

//     // Firestore에서 존재하지 않으면 customItemList와 completedCustomItemList에서 제거
//     int targetRemoveCount = uncompletedCustomItemList.length +
//         completedCustomItemList.length -
//         fetchedCustomItemsIds.length;
//     int uncustomItemListRemovedCount = _removeNonExistentItems(
//         uncompletedCustomItemList, fetchedCustomItemsIds, targetRemoveCount);
//     int completedCustomItemListRemovedCount = 0;
//     if (uncustomItemListRemovedCount < targetRemoveCount) {
//       completedCustomItemListRemovedCount = _removeNonExistentItems(
//           completedCustomItemList,
//           fetchedCustomItemsIds,
//           targetRemoveCount - uncustomItemListRemovedCount);
//     }

//     // 나눠 담기 위해 index 수정
//     int uncompletedCustomItemsCount = uncompletedCustomItemList.length;
//     int completedCustomItemsCount = completedCustomItemList.length;

//     // 나눠 담기
//     ref.read(customBucketListItemProvider.notifier).addCustomItemsToBucketList(
//         id,
//         CustomItems(
//             completeItems: customItems
//                 .getRange(uncompletedCustomItemsCount,
//                     uncompletedCustomItemsCount + completedCustomItemsCount)
//                 .toList(),
//             uncompleteItems:
//                 customItems.getRange(0, uncompletedCustomItemsCount).toList()));

//     ref
//         .read(recommendBucketListItemProvider.notifier)
//         .addRecommendItemsToBucketList(
//             id,
//             RecommendItems(
//               completeItems: recommendItems
//                   .getRange(
//                       uncompletedRecommendItemList.length,
//                       uncompletedRecommendItemList.length +
//                           completedRecommendItemList.length)
//                   .toList(),
//               uncompleteItems: recommendItems
//                   .getRange(0, uncompletedRecommendItemList.length)
//                   .toList(),
//             ));

//     Map<String, dynamic> updates = {};

//     // custom_item_list가 변경되었으면 updates에 추가
//     if (uncustomItemListRemovedCount > 0) {
//       updates['uncompletedCustomItemList'] = uncompletedCustomItemList;
//     }

//     // completed_custom_item_list가 변경되었으면 updates에 추가
//     if (completedCustomItemListRemovedCount > 0) {
//       updates['completedCustomItemList'] = completedCustomItemList;
//     }

//     // updates에 변경 사항이 있으면 Firestore에 한 번의 쓰기 작업으로 업데이트
//     if (updates.isNotEmpty) {
//       await firestore.collection('bucket_list').doc(id).update(updates);

//       // 기존 BucketListModel 찾기
//       final existingBucketList = fixedBucketList!.isShared
//           ? ref
//               .read(sharedBucketListListProvider.notifier)
//               .getBucketListModel(fixedBucketList!.id)
//           : ref
//               .read(myBucketListListProvider.notifier)
//               .getBucketListModel(fixedBucketList!.id);

//       // 새로운 itemList로 BucketListModel 업데이트
//       final updatedBucketList = existingBucketList!.copyWith(
//         customItemList: uncompletedCustomItemList,
//         completedCustomItemList: completedCustomItemList,
//       );

//       // StateNotifier를 통해 상태 업데이트
//       fixedBucketList!.isShared
//           ? ref
//               .read(sharedBucketListListProvider.notifier)
//               .updateBucketList(updatedBucketList)
//           : ref
//               .read(myBucketListListProvider.notifier)
//               .updateBucketList(updatedBucketList);
//     }
//   }

//   // FireStore에 접근해서 item 가져오기
//   Future<List<ItemModel>> _fetchItems(FirebaseFirestore firestore,
//       String collectionName, List<String> itemList) async {
//     List<ItemModel> items = [];

//     // FireStore에서는 한번에 10개씩 데이터를 가져올 수 있으므로 10개씩 분리하여 가져오기
//     for (List<String> chunk in _chunkedList(itemList, 10)) {
//       var querySnapshot = await firestore
//           .collection(collectionName)
//           .where(FieldPath.documentId, whereIn: chunk)
//           .get();

//       for (var doc in querySnapshot.docs) {
//         var data = doc.data();
//         data['id'] = doc.id; // 모델에 넣기 위해 id도 map에 넣어주기

//         // item 종류에 따라서 알맞은 모델 변환해서 넣기
//         items.add(collectionName == 'recommend'
//             ? RecommendItemModel.fromJson(data)
//             : CustomItemModel.fromJson(data));
//       }
//     }

//     return items;
//   }

//   // 리스트를 청크로 분리
//   List<List<String>> _chunkedList(List<String> list, int chunkSize) {
//     List<List<String>> chunks = [];
//     for (int i = 0; i < list.length; i += chunkSize) {
//       chunks.add(list.sublist(i, min(i + chunkSize, list.length)));
//     }
//     return chunks;
//   }

//   int _removeNonExistentItems(List<String> itemList,
//       Set<String> existingItemsIds, int targetRemoveCount) {
//     int removedCount = 0;
//     int currentIndex = 0;

//     while (currentIndex < itemList.length && removedCount < targetRemoveCount) {
//       if (!existingItemsIds.contains(itemList[currentIndex])) {
//         itemList.removeAt(currentIndex);

//         removedCount++;
//       } else {
//         currentIndex++;
//       }
//     }

//     return removedCount; // 제거된 수
//   }

//   // 완료 목록에서 제거
//   void removeComplete(ItemModel item) {
//     setState(() {
//       if (item.runtimeType == RecommendItemModel) {
//         fixedBucketList!.completedRecommendItemList.remove(item.id);
//         fixedBucketList!.uncompletedRecommendItemList.add(item.id);

//         completeRecommendItemList.remove(item as RecommendItemModel);
//         uncompleteRecommendItemList.add(item);
//       } else {
//         fixedBucketList!.completedCustomItemList.remove(item.id);
//         fixedBucketList!.uncompletedCustomItemList.add(item.id);

//         completeCustomItemList.remove(item as CustomItemModel);
//         uncompleteCustomItemList.add(item);
//       }
//     });
//   }

//   // 완료 목록에 추가
//   void addComplete(ItemModel item) {
//     setState(() {
//       if (item.runtimeType == RecommendItemModel) {
//         fixedBucketList!.completedRecommendItemList.add(item.id);
//         fixedBucketList!.uncompletedRecommendItemList.remove(item.id);

//         completeRecommendItemList.add(item as RecommendItemModel);
//         uncompleteRecommendItemList.remove(item);
//       } else {
//         fixedBucketList!.completedCustomItemList.add(item.id);
//         fixedBucketList!.uncompletedCustomItemList.remove(item.id);

//         completeCustomItemList.add(item as CustomItemModel);
//         uncompleteCustomItemList.remove(item);
//       }
//     });
//   }

//   // 리스트의 각 항목을 구성
//   ListItem buildListItem(int index) {
//     ItemModel item;

//     // 먼저 미완료 목록부터 띄움
//     if (index < uncompleteCustomItemList.length) {
//       item = uncompleteCustomItemList[index];
//     } else if (index <
//         uncompleteCustomItemList.length + uncompleteRecommendItemList.length) {
//       item =
//           uncompleteRecommendItemList[index - uncompleteCustomItemList.length];
//     } else if (index <
//         uncompleteCustomItemList.length +
//             uncompleteRecommendItemList.length +
//             completeCustomItemList.length) {
//       item = completeCustomItemList[index -
//           uncompleteCustomItemList.length -
//           uncompleteRecommendItemList.length];
//     } else {
//       item = completeRecommendItemList[index -
//           uncompleteCustomItemList.length -
//           uncompleteRecommendItemList.length -
//           completeCustomItemList.length];
//     }

//     final bool isCompleted = index >=
//         (uncompleteCustomItemList.length + uncompleteRecommendItemList.length);

//     return ListItem(
//       // 추천 아이템
//       isNeedSelectButton: true,
//       isContain: isCompleted,
//       isNeedMoreButton: false,
//       isHome: true,
//       onPressed: () {
//         if (isCompleted) {
//           removeComplete(item);
//           if (item.runtimeType == RecommendItemModel) {
//             fixedBucketList!.isShared
//                 ? ref
//                     .read(sharedBucketListListProvider.notifier)
//                     .moveToUncompleted(
//                         fixedBucketList!.id, item.id, 'recommend')
//                 : ref.read(myBucketListListProvider.notifier).moveToUncompleted(
//                     fixedBucketList!.id, item.id, 'recommend');
//             ref
//                 .read(recommendBucketListItemProvider.notifier)
//                 .moveToUncompleted(fixedBucketList!.id, item.id);
//           } else {
//             fixedBucketList!.isShared
//                 ? ref
//                     .read(sharedBucketListListProvider.notifier)
//                     .moveToUncompleted(fixedBucketList!.id, item.id, 'custom')
//                 : ref
//                     .read(myBucketListListProvider.notifier)
//                     .moveToUncompleted(fixedBucketList!.id, item.id, 'custom');
//             ref
//                 .read(customBucketListItemProvider.notifier)
//                 .moveToUncompleted(fixedBucketList!.id, item.id);
//           }
//         } else {
//           addComplete(item);
//           if (item.runtimeType == RecommendItemModel) {
//             fixedBucketList!.isShared
//                 ? ref
//                     .read(sharedBucketListListProvider.notifier)
//                     .moveToCompleted(fixedBucketList!.id, item.id, 'recommend')
//                 : ref
//                     .read(myBucketListListProvider.notifier)
//                     .moveToCompleted(fixedBucketList!.id, item.id, 'recommend');
//             ref
//                 .read(recommendBucketListItemProvider.notifier)
//                 .moveToCompleted(fixedBucketList!.id, item.id);
//           } else {
//             fixedBucketList!.isShared
//                 ? ref
//                     .read(sharedBucketListListProvider.notifier)
//                     .moveToCompleted(fixedBucketList!.id, item.id, 'custom')
//                 : ref
//                     .read(myBucketListListProvider.notifier)
//                     .moveToCompleted(fixedBucketList!.id, item.id, 'custom');
//             ref
//                 .read(customBucketListItemProvider.notifier)
//                 .moveToCompleted(fixedBucketList!.id, item.id);
//           }
//         }
//       },
//       item: item,
//     );
//   }

//   getFixedBucketListWidget() {
//     if (fixedBucketList == null) {
//       return Container(
//         width: double.infinity,
//         height: 55.h,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: PRIMARY_COLOR.withOpacity(0.5)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'asset/img/logo_transparent.png',
//               height: 200,
//               width: 200,
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               '고정된 버킷이 없습니다',
//               style: TextStyle(
//                   fontFamily: 'SCDream',
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       );
//     } else if (isGetItemComplete) {
//       return Container(
//           width: double.infinity,
//           height: 55.h,
//           alignment: Alignment.center,
//           decoration: fixedBucketList!.image.isNotEmpty
//               ? null
//               : BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: PRIMARY_COLOR.withOpacity(0.5)),
//           child: Stack(
//             children: [
//               fixedBucketList!.image.isNotEmpty
//                   ? Positioned.fill(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Opacity(
//                           opacity: 0.5,
//                           child: CachedNetworkImage(
//                             imageUrl: fixedBucketList!.image,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Shimmer.fromColors(
//                               baseColor: Colors.grey[300]!,
//                               highlightColor: Colors.grey[100]!,
//                               child: Container(
//                                 color: Colors.grey[300],
//                               ),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           ),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Remix.arrow_left_s_line),
//                         Text(
//                           fixedBucketList!.name,
//                           style: const TextStyle(
//                               fontFamily: 'SCDream',
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         const Icon(Remix.arrow_right_s_line),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: fixedBucketList!
//                                 .uncompletedCustomItemList.length +
//                             fixedBucketList!
//                                 .uncompletedRecommendItemList.length +
//                             fixedBucketList!.completedCustomItemList.length +
//                             fixedBucketList!.completedRecommendItemList.length,
//                         itemBuilder: (context, index) {
//                           return buildListItem(index);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ));
//     } else {
//       return Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           width: double.infinity,
//           height: 55.h,
//           color: Colors.grey[300],
//         ),
//       );
//     }
//   }
// }
