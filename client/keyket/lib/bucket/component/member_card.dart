import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/model/user_model.dart';
import 'package:remixicon/remixicon.dart';

class MemberCard extends ConsumerWidget {
  final String id;
  final String nickname;
  final Widget image;
  final bool isHost;

  const MemberCard({
    super.key,
    required this.id,
    required this.nickname,
    required this.image,
    required this.isHost,
  });

  factory MemberCard.fromModel(
      {required UserModel model, required bool isHost}) {
    return MemberCard(
      id: model.kakaoId,
      nickname: model.nickname,
      image: model.image == ''
          ? CircleAvatar(
              radius: 15,
              child: Text(
                model.nickname[0].toUpperCase(), // 이름의 첫 글자를 대문자로 변환
                style: const TextStyle(fontSize: 20),
              ),
            )
          : CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(model.image),
            ),
      isHost: isHost,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // 외부 간격을 위한 패딩
      child: Row(
        children: [
          image, // CircleAvatar
          SizedBox(width: 10), // 간격 설정
          Text(nickname),
          SizedBox(width: 5), // 간격 설정
          // 이 부분은 방장인지 아닌지를 판별하는 boolean 값이 들어가야 합니다.
          // 실제 조건에 따라 변경하십시오.
          if (isHost)
            Icon(Remix.vip_crown_fill,
                color: Colors.yellow), // 왕관 아이콘, 실제 아이콘으로 교체하십시오.
          Spacer(), // 이 부분은 메뉴 버튼을 끝으로 밀어냅니다.
          if (!isHost) // 메뉴 버튼을 보여주는 실제 조건으로 변경하십시오.
            IconButton(
              icon: Icon(Icons.more_vert),
              padding: EdgeInsets.all(0),
              splashRadius: 20,
              constraints: BoxConstraints(
                  minHeight: 20, minWidth: 20, maxHeight: 20, maxWidth: 20),
              onPressed: () {}, // 메뉴 버튼 클릭시의 동작을 정의하십시오.
            ),
        ],
      ),
    );
  }
}
