import 'package:perfectBeta/constants/enums.dart';

class ClimbingGymDTO { //content
  int id;
  int ownerId;
  String gymName;
  GymStatusEnum status;

  ClimbingGymDTO({this.id, this.ownerId, this.gymName, this.status});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "ownerId": this.ownerId,
      "gymName": this.gymName,
      "status": getGymText(this.status),
    };
  }

  factory ClimbingGymDTO.fromJson(Map<String, dynamic> json) {
    return ClimbingGymDTO(
        id: json['id'],
        ownerId: json['ownerId'],
        gymName: json['gymName'],
        status: getGymEnum(json['status'])
    );
  }

}

String getGymText(GymStatusEnum gymStatus) {
  switch(gymStatus) {
    case GymStatusEnum.UNVERIFIED:
      return "UNVERIFIED";
    case GymStatusEnum.VERIFIED:
      return "VERIFIED";
    case GymStatusEnum.CLOSED:
      return "CLOSED";
  }
}

GymStatusEnum getGymEnum(String gymStatus) {
  for (GymStatusEnum gym in GymStatusEnum.values) {
    if (gymStatus == getGymText(gym))
      return gym;
  }
  return GymStatusEnum.UNVERIFIED;
}