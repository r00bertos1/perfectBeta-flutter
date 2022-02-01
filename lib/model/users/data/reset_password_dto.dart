class ResetPasswordDTO {
  String newPassword;
  String newPasswordConfirmation;

  ResetPasswordDTO(
      {this.newPassword, this.newPasswordConfirmation});

  factory ResetPasswordDTO.fromJson(Map<String, dynamic> json) {
    return ResetPasswordDTO(
        newPassword: json['newPassword'],
        newPasswordConfirmation: json['newPasswordConfirmation']);
  }
}