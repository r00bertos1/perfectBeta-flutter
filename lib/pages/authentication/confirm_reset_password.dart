import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/auth/registration_dto.dart';
import 'package:perfectBeta/model/users/data/reset_password_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class ConfirmForgotPassword extends StatefulWidget {
  const ConfirmForgotPassword({Key key}) : super(key: key);

  @override
  _ConfirmForgotPassword createState() => _ConfirmForgotPassword();
}

class _ConfirmForgotPassword extends State<ConfirmForgotPassword> {
  final _confirmForgotPasswordFormKey = GlobalKey<FormState>();

  //API
  var _userEndpoint = new UserEndpoint(getIt.get());

  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _confirmForgotPasswordFormKey,
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.asset("assets/icons/logo.png"),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text("Reset Password",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: [
                        CustomText(
                          text: "Paste code from sent to your email address into box below to account reset password.",
                          overflow: TextOverflow.visible,
                          color: lightGrey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern =
                          r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid password (minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character)';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      } else if (value.length > 32) {
                        return 'Password cannot be longer than 32 characters';
                      } else if (value == _passwordController.text.trim()) {
                        return 'Password must be different';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "New password",
                        hintText: "Enter new password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value != _passwordController.text.trim()) {
                        return 'Password must be same as above';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Enter your password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                    String pattern = r'^[a-zA-Z0-9]+$';
                    RegExp regExp = new RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter code';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please valid code';
                    }
                    return null;
                    },
                    controller: _codeController,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Code",
                        hintText: "Enter your code",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_confirmForgotPasswordFormKey.currentState.validate()) {
                        _handleResetPassword();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: active,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Reset password",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    ResetPasswordDTO resetPasswordDTO = new ResetPasswordDTO(newPassword: _passwordController.text.trim() ,newPasswordConfirmation: _passwordController.text.trim());
    var res = await _userEndpoint.confirmResetPassword(_codeController.text, resetPasswordDTO);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        EasyLoading.showSuccess('Password has been reset!\n You can now log in');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
