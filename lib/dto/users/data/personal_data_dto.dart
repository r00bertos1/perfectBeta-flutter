class PersonalDataDTO {
  String name;
  String surname;
  String phoneNumber;
  String language;
  bool gender;

  PersonalDataDTO(
      {this.name, this.surname, this.phoneNumber, this.language, this.gender});

  factory PersonalDataDTO.fromJson(Map<String, dynamic> json) {
    return PersonalDataDTO(
        name: json['name'],
        surname: json['surname'],
        phoneNumber: json['phoneNumber'],
        language: json['language'],
        gender: json['gender']);
  }
}
