import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/handlers.dart';
import 'package:perfectBeta/pages/users/user_info/change_password.dart';
import 'package:perfectBeta/pages/users/user_info/change_personal_data.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../change_email.dart';
import 'function_card_small.dart';

class UserCardsSmallScreen extends StatelessWidget {
  final _passKey = GlobalKey<FormState>();

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
            onTap: () =>
              // Get.toNamed(changeEmailPageRoute),
              // navigationController.navigateTo(changeEmailPageRoute)}
            Navigator.push(
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
                        handleDeleteUser(_passwordController);
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
}
