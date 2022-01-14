import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/registration_dto.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPage createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  final _registrationFormKey = GlobalKey<FormState>();

  //API
  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  //bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _registrationFormKey,
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
                      Text("Register Account",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      // Only contains alphanumeric characters, underscore and dot.
                      // Underscore and dot can't be at the end or start of a username (e.g _username / username_ / .username / username.).
                      // Underscore and dot can't be next to each other (e.g user_.name).
                      // Underscore or dot can't be used multiple times in a row (e.g user__name / user..name).
                      // Number of characters must be between 4 to 20.
                      String pattern =
                          r'(^(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$)';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid username (alphanumeric characters, number of characters must be between 4 to 20.';
                      } else if (value.length < 4) {
                        return 'Username must be at least 4 characters long';
                      } else if (value.length > 20) {
                        return 'Username cannot be longer than 20 characters';
                      }
                      return null;
                    },
                    controller: _usernameController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Username",
                        hintText: "Enter your username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address';
                      } else if (value != _emailController.text.trim()) {
                        return 'Email must be same as above';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Confirm email",
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorMaxLines: 4,
                        labelText: "Password",
                        hintText: "Enter your password",
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
                  InkWell(
                    onTap: () async {
                      if (_registrationFormKey.currentState.validate()) {
                        _handleRegistration();
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
                        text: "Register",
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

  Future<void> _handleRegistration() async {
    // login
    RegistrationDTO registerData = new RegistrationDTO(
        login: _usernameController.text.trim(), email: _emailController.text.trim(), password: _passwordController.text.trim());
    var res = await _userEndpoint.registerUser(registerData);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        EasyLoading.showSuccess('User was successfully created! Please verify your email before Login');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
