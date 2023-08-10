import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nickname;
  final String image;

  UserModel({
    required this.id,
    required this.nickname,
    required this.image,
  });

  // 복사 생성자
  UserModel.copy(UserModel other)
      : id = other.id,
        nickname = other.nickname,
        image = other.image;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
