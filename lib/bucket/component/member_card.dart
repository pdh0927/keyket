import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/const/colors.dart';
import 'package:keyket/common/model/user_model.dart';
import 'package:keyket/common/provider/my_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';

class MemberCard extends ConsumerWidget {
  final String userId;
  final String nickname;
  final Widget? image;
  final String host;

  final String bucketListId;
  final Function(String) removeUser;

  const MemberCard({
    super.key,
    required this.userId,
    required this.nickname,
    required this.host,
    this.image,
    required this.bucketListId,
    required this.removeUser,
  });

  factory MemberCard.fromModel({
    required UserModel model,
    required String bucketListId,
    required String host,
    required Function(String) removeUser,
  }) {
    return MemberCard(
      userId: model.id,
      nickname: model.nickname,
      image: model.image == ''
          ? CircleAvatar(
              radius: 15,
              child: Text(
                model.nickname[0].toUpperCase(), // 이름의 첫 글자를 대문자로 변환
                style: const TextStyle(fontSize: 20),
              ),
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: model.image,
                fit: BoxFit.cover,
                width: 30, // 원의 두 배의 지름
                height: 30, // 원의 두 배의 지름
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
      host: host,
      bucketListId: bucketListId,
      removeUser: removeUser,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // 외부 간격을 위한 패딩
      child: Row(
        children: [
          image ??
              const CircleAvatar(
                  radius: 15, child: Icon(Remix.question_mark)), // CircleAvatar
          const SizedBox(width: 10), // 간격 설정
          Text(nickname),
          const SizedBox(width: 5), // 간격 설정
          // 이 부분은 방장인지 아닌지를 판별하는 boolean 값이 들어가야 합니다.
          // 실제 조건에 따라 변경하십시오.
          if (userId == host)
            const Icon(Remix.vip_crown_fill,
                color: Colors.yellow), // 왕관 아이콘, 실제 아이콘으로 교체하십시오.
          const Spacer(), // 이 부분은 메뉴 버튼을 끝으로 밀어냅니다.
          if ((userId != host) && (host == ref.read(myInformationProvider)!.id))
            _MoreButton(
              removeUser: removeUser,
              userId: userId,
              isMember: image != null,
            )
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final String userId;
  final Function(String) removeUser;
  final bool isMember;

  const _MoreButton({
    required this.userId,
    required this.removeUser,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey buttonKey = GlobalKey(); // IconButton에 대한 별도의 GlobalKey를 생성

    return IconButton(
      key: buttonKey, // IconButton에 GlobalKey를 연결
      padding: const EdgeInsets.all(0),
      splashRadius: 15,
      constraints: const BoxConstraints(
          maxWidth: 35, minWidth: 35, maxHeight: 25, minHeight: 25),
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
                left: position.dx - 40,
                child: Material(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: GREY_COLOR.withOpacity(0.2),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: () {
                      removeUser(userId);
                      moreButtonOverlay.remove();
                    },
                    child: Text(
                      isMember ? '강퇴' : '취소',
                      style: const TextStyle(
                          fontFamily: 'SCDream',
                          color: BLACK_COLOR,
                          fontSize: 12),
                    ),
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
