import 'package:perfectBeta/dto/users/user_dto.dart';
import 'data/personal_data_dto.dart';

class UserWithPersonalDataDTO extends UserDTO {
  PersonalDataDTO personalData;

  UserWithPersonalDataDTO(
      {String login,
      String email,
      bool isActive,
      bool isVerified,
      PersonalDataDTO personalData})
      : super(
            login: login,
            email: email,
            isActive: isActive,
            isVerified: isVerified);

  factory UserWithPersonalDataDTO.fromJson(Map<String, dynamic> json) {
    return UserWithPersonalDataDTO(
        login: json['login'],
        email: json['email'],
        isActive: json['isActive'],
        isVerified: json['isVerified'],
        personalData: json['personalData']);
  }
}
