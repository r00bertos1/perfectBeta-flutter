import 'package:perfectBeta/dto/users/user_dto.dart';

import 'data/access_level_dto.dart';

class UserWithAccessLevelDTO extends UserDTO {
  List<AccessLevelDTO> accessLevels;

  UserWithAccessLevelDTO(
      {int id,
      String login,
      String email,
      bool isActive,
      bool isVerified,
      this.accessLevels})
      : super(
            id: id,
            login: login,
            email: email,
            isActive: isActive,
            isVerified: isVerified);

  factory UserWithAccessLevelDTO.fromJson(Map<String, dynamic> json) {
    var list = json['accessLevels'] as List;
    List<AccessLevelDTO> accessLevelList =
        list.map((i) => AccessLevelDTO.fromJson(i)).toList();

    return UserWithAccessLevelDTO(
        id: json['id'],
        login: json['login'],
        email: json['email'],
        isActive: json['isActive'],
        isVerified: json['isVerified'],
        accessLevels: accessLevelList);
  }
}
