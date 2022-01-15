import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/pages/authentication/registration.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'forgot_password.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPage createState() => _AuthenticationPage();
}

class _AuthenticationPage extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();

  //API
  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadUserLoginPassword();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
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
                      Text("Login",
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
                          text: "Welcome back",
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
                        return 'Please enter valid username';
                      }
                      return null;
                    },
                    controller: _loginController,
                    decoration: InputDecoration(
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
                      // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
                      String pattern =
                          r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid password';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: _isChecked, onChanged: (bool value) { setState(() {
                            _isChecked = value;
                          }); },),
                          CustomText(
                            text: "Remember Me",
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              ),
                          child: CustomText(
                              text: "Forgot password?", color: active))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        if (_isChecked) {
                          _handleRemeberme(true);
                        }
                        _handleAuthentication();
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
                        text: "Login",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Register",
                        color: active,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Do not want to create an account?\n",
                            style: TextStyle(color: lightGrey)),
                        TextSpan(
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () async {
                                if (_isChecked) {
                                  _handleRemeberme(true);
                                }
                                _handleAuthenticationAnonim();
                              },
                            text: "Browse anonymously! ",
                            style: TextStyle(color: active))
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //handle remember me function
  Future<void> _handleRemeberme(bool value) async {
    //_isChecked = value;
    await UserSecureStorage.setRememberMe(value);
    await UserSecureStorage.setLogin(_loginController.text.trim());
    await UserSecureStorage.setPassword(_passwordController.text.trim());
    // setState(() {
    //   _isChecked = value;
    // });
  }

  //load email and password
  void _loadUserLoginPassword() async {
    try {
      var _rememberMe = await UserSecureStorage.getRememberMe() ?? false;
      var _username = await UserSecureStorage.getLogin() ?? "";
      var _password = await UserSecureStorage.getPassword() ?? "";
      // print(_rememberMe.toString());
      // print(_username.toString());
      // print(_password.toString());
      if (_rememberMe) {
        setState(() {
          _isChecked = true;
        });
        _loginController.text = _username ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleAuthentication() async {
    // login
    CredentialsDTO authData = new CredentialsDTO(
        username: _loginController.text.trim(),
        password: _passwordController.text.trim());
    var res = await _authenticationEndpoint.authenticate(authData);
    if (res.statusCode == 200) {
      Get.offAllNamed(rootRoute);
      menuController.changeActiveItemTo(overviewPageDisplayName);
    } else {
      print(res.statusCode);
    }
  }

  void _handleAuthenticationAnonim() {
    var res = _authenticationEndpoint.authenticateAnonim();
    if (res) {
      Get.offAllNamed(rootRoute);
      menuController.changeActiveItemTo(overviewPageDisplayName);
    } else {
      EasyLoading.showError('Something went wrong');
    }
  }
}
