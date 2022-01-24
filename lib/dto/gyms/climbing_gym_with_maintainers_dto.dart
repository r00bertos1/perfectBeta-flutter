import 'package:perfectBeta/constants/enums.dart';
import 'climbing_gym_dto.dart';
import 'gym_maintainer_dto.dart';

class ClimbingGymWithMaintainersDTO extends ClimbingGymDTO {
  List<GymMaintainerDTO> maintainerDTO;

  ClimbingGymWithMaintainersDTO(
      {int id,
      int ownerId,
      String gymName,
      GymStatusEnum status,
      this.maintainerDTO})
      : super(ownerId: ownerId, gymName: gymName, status: status);

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "ownerId": this.ownerId,
      "gymName": this.gymName,
      "status": getGymText(this.status),
      //"gymDetailsDTO": this.gymDetailsDTO,
    };
  }

  factory ClimbingGymWithMaintainersDTO.fromJson(Map<String, dynamic> json) {
    var list = json['maintainerDTO'] as List;
    List<GymMaintainerDTO> maintainerList =
        list.map((i) => GymMaintainerDTO.fromJson(i)).toList();

    return ClimbingGymWithMaintainersDTO(
        id: json['id'],
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: getGymEnum(json['status']),
        maintainerDTO: maintainerList);
  }
}
