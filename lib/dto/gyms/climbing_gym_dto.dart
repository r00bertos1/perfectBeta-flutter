import 'package:perfectBeta/constants/enums.dart';

class ClimbingGymDTO {
  int ownerId;
  String gymName;
  GymStatusEnum status;

  ClimbingGymDTO({this.ownerId, this.gymName, this.status});

  factory ClimbingGymDTO.fromJson(Map<String, dynamic> json) {
    return ClimbingGymDTO(
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: json['status']);
  }
}
