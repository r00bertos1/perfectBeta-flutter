import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/model/gyms/gym_details_dto.dart';
import 'package:perfectBeta/helpers/country_functions.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../../main.dart';

class EditGymDetailsPage extends StatefulWidget {
  const EditGymDetailsPage({Key key, this.gym, this.gymId}) : super(key: key);
  final ClimbingGymWithDetailsDTO gym;
  final int gymId;

  @override
  _EditGymDetailsPageState createState() => _EditGymDetailsPageState();
}

class _EditGymDetailsPageState extends State<EditGymDetailsPage> {
  final _editGymDataFormKey = GlobalKey<FormState>();

  //API
  var _climbingGymEndpoint = new ClimbingGymEndpoint(getIt.get());

  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _country;
  List<DropdownMenuItem<String>> countries = [];

  @override
  void initState() {
    _loadGymData();
    super.initState();
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
            key: _editGymDataFormKey,
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
                      Text("Edit gym details",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^[^<>%\$#@!%&*;{}]{0,40}$)';
                      RegExp regExp = new RegExp(pattern);
                      //if (!nameRegExp.hasMatch(value)) {
                      if (value.length > 40) {
                        return 'City name cannot be longer than 40 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid city name';
                      }
                      return null;
                    },
                    controller: _cityController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "City",
                        hintText: "Enter city name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^[^<>%\$#@!%&*;{}]{0,60}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (value.length > 60) {
                        return 'Street name cannot be longer than 60 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid street name';
                      }
                      return null;
                    },
                    controller: _streetController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Street",
                        hintText: "Enter street name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r"(^[A-Za-z0-9'\.\-\s\,]{0,8}$)";
                      RegExp regExp = new RegExp(pattern);
                      //if (!nameRegExp.hasMatch(value)) {
                      if (value.length > 8) {
                        return 'Number cannot be longer than 8 digits';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    controller: _numberController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Number",
                        hintText: "Enter street number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                        validator: (value) =>
                        value == null ? "Select a country" : null,
                        hint: Text(
                          'Select country',
                        ),
                        decoration: InputDecoration(
                            labelText: "Country",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onChanged: (value) {
                          setState(() {
                            _country = value;
                          });
                        },
                        value: _country != null ? _country : null,
                        items: countries,
                        //items: countryItems,
                      );
                    }
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^[^<>%\$#@!%&*;{}]{0,300}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (value.length > 300) {
                        return 'Description cannot be longer than 300 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return "Description cannot have special characters (eg. \$#@!% )";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        errorMaxLines: 4,
                        labelText: "Description",
                        hintText: "Enter gym description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      if (_editGymDataFormKey.currentState.validate()) {
                        _handlePersonalDataChange(widget.gym.id);
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

  Future<void> _handlePersonalDataChange(gymId) async {
    GymDetailsDTO gymData = new GymDetailsDTO(
        country: _country,
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        description: _descriptionController.text.trim());
    var res = await _climbingGymEndpoint.editGymDetails(gymId, gymData);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        //menuController.changeActiveItemTo(overviewPageDisplayName);

        EasyLoading.showSuccess(
            'Done!');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  void _loadGymData() {
    try {
      if (widget.gym != null) {
        _country = widget.gym.gymDetailsDTO.country ?? "";
        _cityController.text = widget.gym.gymDetailsDTO.city ?? "";
        _streetController.text = widget.gym.gymDetailsDTO.street ?? "";
        _numberController.text = widget.gym.gymDetailsDTO.number ?? "";
        _descriptionController.text =  widget.gym.gymDetailsDTO.description ?? "";
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