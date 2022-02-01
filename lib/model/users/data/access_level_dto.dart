class AccessLevelDTO {
  String accessLevel;
  bool isActive;

  AccessLevelDTO({this.accessLevel, this.isActive});

  factory AccessLevelDTO.fromJson(Map<String, dynamic> json) {
    return AccessLevelDTO(
        accessLevel: json['accessLevel'], isActive: json['isActive']);
  }
}
