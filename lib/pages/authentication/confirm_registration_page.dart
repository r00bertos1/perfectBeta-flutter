
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

class ConfirmRegistrationPage extends StatefulWidget {
  const ConfirmRegistrationPage({Key key}) : super(key: key);

  @override
  _ConfirmRegistrationPage createState() => _ConfirmRegistrationPage();
}

class _ConfirmRegistrationPage extends State<ConfirmRegistrationPage> {
  final _codeFormKey = GlobalKey<FormState>();

  //API
  static ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());

  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _codeFormKey,
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
                    Text("Verify account",
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
                        text: "Paste code from email provided during registration into box below to activate your account.",
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
                    if (_codeFormKey.currentState.validate()) {
                      _handleVerifyUser();
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
                      text: "Verify account",
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

  Future<void> _handleVerifyUser() async {
    var res = await _userEndpoint.verifyUser(_codeController.text);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        EasyLoading.showSuccess('Account verified!\n You can now log in');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
