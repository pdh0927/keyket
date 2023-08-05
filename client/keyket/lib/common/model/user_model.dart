import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String kakaoId;
  final String nickname;
  final String image;
  final int inviteCode;

  UserModel({
    required this.kakaoId,
    required this.nickname,
    required this.image,
    required this.inviteCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
