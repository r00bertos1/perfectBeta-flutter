class ChangePasswordDTO {
  String newPassword;
  String oldPassword;

  ChangePasswordDTO(
      {this.newPassword, this.oldPassword});

  Map<String, dynamic> toJson() => {
    'newPassword': newPassword,
    'oldPassword': oldPassword,
  };

  factory ChangePasswordDTO.fromJson(Map<String, dynamic> json) {
    return ChangePasswordDTO(
        newPassword: json['newPassword'],
        oldPassword: json['oldPassword']);
  }
}