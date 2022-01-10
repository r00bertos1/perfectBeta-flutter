
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/registration_dto.dart';
import 'package:perfectBeta/dto/users/data/email_dto.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final _forgotPasswordformKey = GlobalKey<FormState>();

  //API
  static ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _forgotPasswordformKey,
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
                    Text("Request reset password",
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
                        text: "Put your email below. You will receive a message with link to reset your password.",
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
                    } else if (!value.isEmail) {
                      return 'Please enter valid email address';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if (_forgotPasswordformKey.currentState.validate()) {
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
                      text: "Send request",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    // login
    EmailDTO email = new EmailDTO(email: _emailController.text.trim());
    var res = await _userEndpoint.requestResetPassword(email);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        EasyLoading.showSuccess('Password reset instructions have been sent to email!');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
