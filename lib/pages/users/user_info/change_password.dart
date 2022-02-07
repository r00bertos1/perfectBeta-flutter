import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/handlers.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPage createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  final _changePasswordFormKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _changePasswordFormKey,
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
                      Text("Change password",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
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
                      }
                      return null;
                    },
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Current password",
                        hintText: "Enter your password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                      } else if (value == _oldPasswordController.text.trim()) {
                        return 'Password must be different';
                      }
                      return null;
                    },
                    controller: _newPasswordController,
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
                  InkWell(
                    onTap: () async {
                      if (_changePasswordFormKey.currentState.validate()) {
                        handleChangePassword(context, _oldPasswordController.text.trim(), _newPasswordController.text.trim());
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
                        text: "Change password",
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


}
