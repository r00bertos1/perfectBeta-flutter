import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../../main.dart';

class EditRouteDetailsPage extends StatefulWidget {
  const EditRouteDetailsPage({Key key, this.routeData}) : super(key: key);
  final RouteDTO routeData;

  @override
  _EditRouteDetailsPageState createState() => _EditRouteDetailsPageState();
}

class _EditRouteDetailsPageState extends State<EditRouteDetailsPage> {

  final _editRouteDetailsFormKey = GlobalKey<FormState>();

  //API
  var _routeEndpoint = new RouteEndpoint(getIt.get());

  final _routeNameController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRouteDetails();
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
            key: _editRouteDetailsFormKey,
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
                      Text("Edit route details",
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
                      String pattern = r'(^[A-Za-z??-????-????-??????????????????????????????????????0-9\s]{2,50}$)';
                      RegExp regExp = new RegExp(pattern);
                      //if (!nameRegExp.hasMatch(value)) {
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters long';
                      } else if (value.length > 50) {
                        return 'Name cannot be longer than 50 characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter valid route name (no special characters)';
                      }
                      return null;
                    },
                    controller: _routeNameController,
                    decoration: InputDecoration(
                        errorMaxLines: 3,
                        labelText: "Route Name",
                        hintText: "Enter route name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'(^(\d[abc][+-]|\d[abc]|\d[+-]|\d){0,1}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter valid difficulty in Fontainebleau grading system, eg. 5, 5+, 6a, 6c+';
                      }
                      return null;
                    },
                    controller: _difficultyController,
                    decoration: InputDecoration(
                      errorMaxLines: 3,
                        labelText: "Difficulty",
                        hintText: "Enter route difficulty",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
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
                        errorMaxLines: 3,
                        labelText: "Description",
                        hintText: "Enter gym description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_editRouteDetailsFormKey.currentState.validate()) {
                        _handleRouteDetailsChange();
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

  void _loadRouteDetails() {
    _routeNameController.text = widget.routeData.routeName;
    _difficultyController.text = widget.routeData.difficulty;
    _descriptionController.text = widget.routeData.description;
  }

  Future<void> _handleRouteDetailsChange() async {
    RouteDTO routeData = new RouteDTO(
        id: widget.routeData.id,
        routeName: _routeNameController.text.trim(),
        difficulty: _difficultyController.text.trim(),
        description: _descriptionController.text.trim(),
        climbingGymId: widget.routeData.climbingGymId,
        holdsDetails: widget.routeData.holdsDetails,
        //photos:
        );
    var res = await _routeEndpoint.editRouteDetails(widget.routeData.climbingGymId, widget.routeData.id, routeData);
    try {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        EasyLoading.showSuccess('Route Details updated!');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
