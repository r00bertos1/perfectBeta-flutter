import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/registration_dto.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_maintainers_dto.dart';
import 'package:perfectBeta/dto/gyms/gym_maintainer_dto.dart';
import 'package:perfectBeta/dto/users/data/email_dto.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMaintainerToGymPage extends StatefulWidget {
  const AddMaintainerToGymPage({Key key, this.gymId}) : super(key: key);
  final int gymId;

  @override
  _AddMaintainerToGymPage createState() => _AddMaintainerToGymPage();
}

class _AddMaintainerToGymPage extends State<AddMaintainerToGymPage> {
  final _maintainterToGymKey = GlobalKey<FormState>();

  //API
  static ApiClient _client = new ApiClient();
  var _climbingGymEndpoint = new ClimbingGymEndpoint(_client.init());

  final _managerUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _maintainterToGymKey,
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
                Wrap(
                  children: [
                    Text("Add maintainer to gym",
                        softWrap: false,
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
                        text: "Enter manager username below",
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
                    String pattern =
                        r'(^(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid username.';
                    }
                    return null;
                  },
                  controller: _managerUsernameController,
                  decoration: InputDecoration(
                      labelText: "Manager username",
                      hintText: "Enter manager username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if (_maintainterToGymKey.currentState.validate()) {
                      _handleAddMaintainerToGym(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: "Add maintainer",
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

  Future<void> _handleAddMaintainerToGym(context) async {
    try {
      ClimbingGymWithMaintainersDTO res =
          await _climbingGymEndpoint.addMaintainerToGym(
              widget.gymId, _managerUsernameController.text.trim());
      List<GymMaintainerDTO> maintainers = [];
      if (res.maintainerDTO != null) {
        String gymName = res.gymName;
        res.maintainerDTO.forEach((manager) {
          maintainers.add(manager);
        });
        _showMaintainersDialog(context, maintainers, gymName);
        Navigator.of(context).pop();
      } else {
        _managerUsernameController.clear();
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<void> _showMaintainersDialog(context,
      List<GymMaintainerDTO> maintainers, gymName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Maintainers for $gymName'),
          content: SingleChildScrollView(
            child: Container(
              width: 200.0,
              height: 200.0,
              child: DataTable2(
                //columnSpacing: 12,
               // horizontalMargin: 12,
                //minWidth: 600,
                columns: [
                  DataColumn2(
                    label: Text('Manager ID'),
                  ),
                  DataColumn2(
                    label: Text('Active'),
                  ),
                ],
                rows: maintainers
                    .map((manager) => DataRow(cells: [
                          DataCell(
                              CustomText(text: manager.maintainerId.toString())),
                          DataCell(CustomText(text: manager.isActive.toString())),
                        ]))
                    .toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
