import 'package:flutter/material.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPage createState() => _AuthenticationPage();
}

class _AuthenticationPage extends State<AuthenticationPage> {
  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  //final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmailPassword();
    //init();
  }

  // Future init() async {
  //   final name = await UserSecureStorage.getUsername() ?? '';
  //   final birthday = await UserSecureStorage.getBirthday();
  //   final pets = await UserSecureStorage.getPets() ?? [];
  //
  //   setState(() {
  //     this.controllerName.text = name;
  //     this.birthday = birthday;
  //     this.pets = pets;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              Row(
                children: [
                  CustomText(
                    text: "Welcome back to the admin panel.",
                    color: lightGrey,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "abc@domain.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    //hintText: "123",
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
                      Checkbox(value: _isChecked, onChanged: _handleRemeberme),
                      CustomText(
                        text: "Remember Me",
                      ),
                    ],
                  ),
                  CustomText(text: "Forgot password?", color: active)
                ],
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  if(_isChecked) {
                    _handleRemeberme(true);
                  }
                  _handleAuthentication();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: active, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Login",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Do not have admin credentials? ",
                    style: TextStyle(color: lightGrey)),
                TextSpan(
                    text: "Request Credentials! ",
                    style: TextStyle(color: active))
              ]))
            ],
          ),
        ),
      ),
    );
  }

  //handle remember me function
  Future<void> _handleRemeberme(bool value) async {
    _isChecked = value;
    await UserSecureStorage.setRememberMe(value);
    await UserSecureStorage.setEmail(_emailController.text);
    await UserSecureStorage.setPassword(_passwordController.text);

    setState(() {
      _isChecked = value;
    });
  }

  //load email and password
  void _loadUserEmailPassword() async {
    try {
      var _rememberMe = await UserSecureStorage.getRememberMe() ?? false;
      var _email = await UserSecureStorage.getEmail() ?? "";
      var _password = await UserSecureStorage.getPassword() ?? "";
      print(_rememberMe.toString());
      print(_email.toString());
      print(_password.toString());
      if (_rememberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _handleAuthentication() async {
    // login
    CredentialsDTO authData = new CredentialsDTO(username: _emailController.text, password: _passwordController.text);
    var res = await _authenticationEndpoint.authenticate(authData);
    if (res.statusCode == 200) {
      Get.offAllNamed(rootRoute);
    }
    else {
      print('ERRRROR');
    }
  }
}
