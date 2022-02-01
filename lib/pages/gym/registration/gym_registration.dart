import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main.dart';
import 'edit_gym_details_after_registration.dart';

class GymRegistrationPage extends StatefulWidget {
  const GymRegistrationPage({Key key}) : super(key: key);

  @override
  _GymRegistrationPage createState() => _GymRegistrationPage();
}

class _GymRegistrationPage extends State<GymRegistrationPage> {
  final _gymRegistrationFormKey = GlobalKey<FormState>();

  //API
  var _climbingGymEndpoint = new ClimbingGymEndpoint(getIt.get());

  final _gymNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _gymRegistrationFormKey,
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
                    Text("Register new gym",
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
                        text: "Enter your gym name.",
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
                    String pattern = r'(^[^<>%\$#@!%&*;{}.]{2,40}$)';
                    RegExp regExp = new RegExp(pattern);
                    //if (!nameRegExp.hasMatch(value)) {
                    if (value.length < 2) {
                      return 'Gym name must be at least 2 characters long';
                    } else if (value.length > 40) {
                      return 'Gym name cannot be longer than 40 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid name';
                    }
                    return null;
                  },
                  controller: _gymNameController,
                  decoration: InputDecoration(
                      labelText: "Gym name",
                      hintText: "Enter your gym name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if (_gymRegistrationFormKey.currentState.validate()) {
                      _handleGymRegistration();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: "Continue",
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

  Future<void> _handleGymRegistration() async {
    // login
    String _gymName = _gymNameController.text.trim();
    ClimbingGymWithDetailsDTO res = await _climbingGymEndpoint.registerNewGym(_gymName);
    try {
      if (res.gymName == _gymName) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditGymDetailsAfterRegistration(gymData: res),
          ),
        );
        EasyLoading.showSuccess(
            'Gym ${res.gymName} created! You can now add more informations to your gym');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
