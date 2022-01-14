class CountryDTO {
  final String name;
  final String code;

  CountryDTO._({this.name, this.code});

  factory CountryDTO.fromJson(Map<String, dynamic> json) {
    return new CountryDTO._(
      name: json['Name'],
      code: json['Code'],
    );
  }
}