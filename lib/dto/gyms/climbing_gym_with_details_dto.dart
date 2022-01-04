import 'package:perfectBeta/constants/enums.dart';

import 'climbing_gym_dto.dart';
import 'gym_details_dto.dart';

class ClimbingGymWithDetailsDTO extends ClimbingGymDTO {
  GymDetailsDTO gymDetailsDTO;

  ClimbingGymWithDetailsDTO(
      {int ownerId, String gymName, GymStatusEnum status, this.gymDetailsDTO})
      : super(ownerId: ownerId, gymName: gymName, status: status);

  factory ClimbingGymWithDetailsDTO.fromJson(Map<String, dynamic> json) {
    return ClimbingGymWithDetailsDTO(
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: json['status'],
        gymDetailsDTO: GymDetailsDTO.fromJson(json['gymDetailsDTO']));
  }
}
