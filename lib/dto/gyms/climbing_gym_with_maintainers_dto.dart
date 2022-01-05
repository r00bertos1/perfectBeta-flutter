import 'package:perfectBeta/constants/enums.dart';
import 'climbing_gym_dto.dart';
import 'gym_maintainer_dto.dart';

class ClimbingGymWithMaintainersDTO extends ClimbingGymDTO {
  List<GymMaintainerDTO> maintainerDTO;

  ClimbingGymWithMaintainersDTO(
      {int ownerId, String gymName, GymStatusEnum status, this.maintainerDTO})
      : super(ownerId: ownerId, gymName: gymName, status: status);

  factory ClimbingGymWithMaintainersDTO.fromJson(Map<String, dynamic> json) {
    var list = json['maintainerDTO'] as List;
    List<GymMaintainerDTO> maintainerList = list.map((i) => GymMaintainerDTO.fromJson(i)).toList();

    return ClimbingGymWithMaintainersDTO(
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: json['status'],
        maintainerDTO: maintainerList);
  }
}
