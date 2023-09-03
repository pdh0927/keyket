import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nickname;
  final String image;
  final String fixedBucket;
  final String inviteCode;

  UserModel({
    required this.id,
    required this.nickname,
    required this.image,
    required this.fixedBucket,
    required this.inviteCode,
  });

  // 복사 생성자
  UserModel.copy(UserModel other)
      : id = other.id,
        nickname = other.nickname,
        image = other.image,
        inviteCode = other.inviteCode,
        fixedBucket = other.fixedBucket;

  UserModel copyWith({
    String? id,
    String? nickname,
    String? image,
    String? fixedBucket,
    String? inviteCode,
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      inviteCode: inviteCode ?? this.inviteCode,
      fixedBucket: fixedBucket ?? this.fixedBucket,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
