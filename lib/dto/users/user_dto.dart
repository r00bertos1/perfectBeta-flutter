class UserDTO {
  String login;
  String email;
  bool isActive;
  bool isVerified;

  UserDTO({this.login, this.email, this.isActive, this.isVerified});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
        login: json['login'],
        email: json['email'],
        isActive: json['isActive'],
        isVerified: json['isVerified']);
  }
}