class GymDetailsDTO {
  String country;
  String city;
  String street;
  String number;
  String description;

  GymDetailsDTO(
      {this.country, this.city, this.street, this.number, this.description});

  factory GymDetailsDTO.fromJson(Map<String, dynamic> json) {
    return GymDetailsDTO(
        country: json['country'],
        city: json['city'],
        street: json['street'],
        number: json['number'],
        description: json['description']);
  }
}
