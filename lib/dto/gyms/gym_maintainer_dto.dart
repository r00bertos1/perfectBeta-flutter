class GymMaintainerDTO {
  int maintainerId;
  int gymId;
  bool isActive;

  GymMaintainerDTO({this.maintainerId, this.gymId, this.isActive});

  factory GymMaintainerDTO.fromJson(Map<String, dynamic> json) {
    return GymMaintainerDTO(
        maintainerId: json['maintainerId'],
        gymId: json['gymId'],
        isActive: json['isActive']);
  }
}
