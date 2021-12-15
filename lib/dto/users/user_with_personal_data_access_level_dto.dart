import 'package:perfectBeta/dto/users/user_with_access_level_dto.dart';
import 'data/access_level_dto.dart';
import 'data/personal_data_dto.dart';

class UserWithPersonalDataAccessLevelDTO extends UserWithAccessLevelDTO {
  PersonalDataDTO personalData;

  UserWithPersonalDataAccessLevelDTO(
      {String login,
      String email,
      bool isActive,
      bool isVerified,
      List<AccessLevelDTO> accessLevels,
      this.personalData})
      : super(
            login: login,
            email: email,
            isActive: isActive,
            isVerified: isVerified,
            accessLevels: accessLevels);

  factory UserWithPersonalDataAccessLevelDTO.fromJson(
      Map<String, dynamic> json) {
    return UserWithPersonalDataAccessLevelDTO(
        login: json['login'],
        email: json['email'],
        isActive: json['isActive'],
        isVerified: json['isVerified'],
        accessLevels: json['accessLevels'],
        personalData: json['personalData']
    );
  }
}
