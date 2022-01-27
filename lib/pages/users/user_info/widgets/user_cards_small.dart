import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/users/data/password_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/authentication/registration.dart';
import 'package:perfectBeta/pages/users/user_info/change_password.dart';
import 'package:perfectBeta/pages/users/user_info/change_personal_data.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../change_email.dart';
import 'function_card_small.dart';

class UserCardsSmallScreen extends StatelessWidget {
  final _passKey = GlobalKey<FormState>();
  //API
  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: 400,
      child: Column(
        children: [
          FunctionCardSmall(
            title: "Edit personal information",
            icon: Icons.info,
            onTap: () =>
                //     Navigator.push(
                //   context, //PasswordChangePage
                //   MaterialPageRoute(builder: (context) => ChangePersonalDataPage()),
                // ),
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePersonalDataPage(),
              ),
            ),
          ),
          SizedBox(
            height: _width / 64,
          ),
          FunctionCardSmall(
            title: "Change password",
            icon: Icons.password,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            ),
          ),
          SizedBox(
            height: _width / 64,
          ),
          FunctionCardSmall(
            title: "Change email address",
            icon: Icons.email,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeEmailPage()),
            ),
          ),
          SizedBox(
            height: _width / 64,
          ),
          FunctionCardSmall(
            alignment: Alignment.bottomCenter,
            title: "Delete account",
            icon: Icons.remove_circle,
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                title: const Text('Delete account'),
                content: Form(
                  key: _passKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Your account will be removed. Are you sure?'),
                      TextFormField(
                          validator: (value) {
                            // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
                            String pattern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$)';
                            RegExp regExp = new RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              return 'Please enter your account password';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Please enter your account password';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorMaxLines: 4,
                              labelText: "Password",
                              hintText: "Enter your password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(text: 'No', weight: FontWeight.w300, color: dark),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_passKey.currentState.validate()) {
                        Navigator.pop(context);
                        _handleUserDelete(context);
                      }
                    },
                    child: CustomText(text: 'Yes, delete!', color: error),
                  ),
                ],
              ),
            ),
            isError: true,
          ),
        ],
      ),
    );
  }

  Future<void> _handleUserDelete(context) async {
    UserWithPersonalDataAccessLevelDTO userData = await _userEndpoint.getUserPersonalDataAccessLevel();

    PasswordDTO password = new PasswordDTO(password: _passwordController.text.trim());
    _passwordController.clear();
    var res = await _userEndpoint.deleteUser(userData.id, password);
    if (res != null) {
      if (res.statusCode == 200) {
        Get.offAllNamed(authenticationPageRoute);
        // menuController.changeActiveItemTo(
        //     overviewPageDisplayName);
      }
    } else {
      EasyLoading.showError('Error' + res.statusMessage);
    }
  }
}
