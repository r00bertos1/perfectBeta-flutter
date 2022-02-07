import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/lists.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/handlers.dart';
import 'package:perfectBeta/model/users/data/personal_data_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/helpers/country_functions.dart';
import 'package:perfectBeta/pages/users/user_info/user.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main.dart';

class ChangePersonalDataPage extends StatefulWidget {
  const ChangePersonalDataPage({Key key}) : super(key: key);

  @override
  _ChangePersonalDataPage createState() => _ChangePersonalDataPage();
}

class _ChangePersonalDataPage extends State<ChangePersonalDataPage> {
  final _personalDataFormKey = GlobalKey<FormState>();

  //API
  var _userEndpoint = new UserEndpoint(getIt.get());

  int _userId;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  String _country;
  bool _isMan = false;
  String _selectedValue = 'false';
  PhoneNumber _phoneNumber = PhoneNumber();
  String _phoneNumberString = '';

  List<DropdownMenuItem<String>> countries = [];

  @override
  void initState() {
    super.initState();
    _loadPersonalData().then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _personalDataFormKey,
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
                      Text("Personal information",
                          overflow: TextOverflow.ellipsis, style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^[A-Za-zÀ-ÖØ-öø-ÿżźćńółęąśŻŹĆĄŚĘŁÓŃ]{2,20}$)';
                      RegExp regExp = new RegExp(pattern);
                      //if (!nameRegExp.hasMatch(value)) {
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters long';
                      } else if (value.length > 20) {
                        return 'Name cannot be longer than 20 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Name",
                        hintText: "Enter your name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^[A-Za-zÀ-ÖØ-öø-ÿżźćńółęąśŻŹĆĄŚĘŁÓŃ]{2,40}$)';
                      RegExp regExp = new RegExp(pattern);
                      //if (!surnameRegExp.hasMatch(value)) {
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters long';
                      } else if (value.length > 40) {
                        return 'Name cannot be longer than 40 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                    controller: _surnameController,
                    decoration: InputDecoration(
                        labelText: "Surname", hintText: "Enter your surname", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InternationalPhoneNumberInput(
                    initialValue: _phoneNumber,
                    errorMessage: 'Invalid phone number',
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.always,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    spaceBetweenSelectorAndTextField: 0,
                    inputBorder: OutlineInputBorder(),
                    inputDecoration: InputDecoration(
                        labelText: "Phone number",
                        hintText: "Enter your phone number",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                    onInputValidated: (bool value) {},
                    onInputChanged: (PhoneNumber value) {
                      this._phoneNumberString = value.phoneNumber;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: putCountries(),
                      builder: (context, snapshot) {
                        countries = snapshot.data;
                        return DropdownButtonFormField(
                          isExpanded: true,
                          validator: (value) => value == null ? "Select a country" : null,
                          hint: Text(
                            'Select country',
                          ),
                          decoration: InputDecoration(labelText: "Country", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                          onChanged: (value) {
                            setState(() {
                              _country = value;
                            });
                          },
                          value: _country != null ? _country : null,
                          items: countries,
                          //items: countryItems,
                        );
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    validator: (value) => value == null ? "Select a gender" : null,
                    hint: Text(
                      'Select gender',
                    ),
                    decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                        _isMan = _selectedValue.parseBool();
                      });
                    },
                    value: _selectedValue,
                    items: genderItems,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_personalDataFormKey.currentState.validate()) {
                        handleChangePersonalData(
                                _userId, _nameController.text.trim(), _surnameController.text.trim(), _phoneNumberString, _country, _isMan)
                            .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(),
                                  ),
                                ));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Save",
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

  void getPhoneNumber(String phoneNumberString) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberString);

    setState(() {
      this._phoneNumber = number;
    });
  }

  //load personal data
  Future<void> _loadPersonalData() async {
    try {
      UserWithPersonalDataAccessLevelDTO res = await _userEndpoint.getUserPersonalDataAccessLevel();
      if (res.isActive && res.isVerified) {
        _userId = res.id ?? "";
        _nameController.text = res.personalData.name ?? "";
        _surnameController.text = res.personalData.surname ?? "";
        _phoneNumberString = res.personalData.phoneNumber ?? "";
        getPhoneNumber(_phoneNumberString);
        _country = res.personalData.language ?? "";
        _isMan = res.personalData.gender ?? "";
        _selectedValue = '$_isMan';
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}
