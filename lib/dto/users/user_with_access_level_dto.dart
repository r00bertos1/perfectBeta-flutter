import 'package:perfectBeta/dto/users/user_dto.dart';

import 'data/access_level_dto.dart';

class UserWithAccessLevelDTO extends UserDTO {
  List<AccessLevelDTO> accessLevels;

  UserWithAccessLevelDTO(
      {String login,
      String email,
      bool isActive,
      bool isVerified,
      this.accessLevels})
      : super(
            login: login,
            email: email,
            isActive: isActive,
            isVerified: isVerified);

  factory UserWithAccessLevelDTO.fromJson(Map<String, dynamic> json) {
    return UserWithAccessLevelDTO(
        login: json['login'],
        email: json['email'],
        isActive: json['isActive'],
        isVerified: json['isVerified'],
        accessLevels: json['accessLevels']
    );
  }
}
