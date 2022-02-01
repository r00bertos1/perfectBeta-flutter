import 'package:perfectBeta/constants/enums.dart';
import 'climbing_gym_dto.dart';
import 'gym_details_dto.dart';

class ClimbingGymWithDetailsDTO extends ClimbingGymDTO {
  GymDetailsDTO gymDetailsDTO;

  ClimbingGymWithDetailsDTO(
      {int id, int ownerId, String gymName, GymStatusEnum status, this.gymDetailsDTO})
      : super(id: id, ownerId: ownerId, gymName: gymName, status: status);

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "ownerId": this.ownerId,
      "gymName": this.gymName,
      "status": getGymText(this.status),
      "gymDetailsDTO": this.gymDetailsDTO,
    };
  }

  factory ClimbingGymWithDetailsDTO.fromJson(Map<String, dynamic> json) {
    return ClimbingGymWithDetailsDTO(
        id: json['id'],
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: getGymEnum(json['status']),
        gymDetailsDTO: GymDetailsDTO.fromJson(json['gymDetailsDTO']));
  }
}