import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/pages/add_route/model/converted_image.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:perfectBeta/pages/add_route/widgets/step_one.dart';
import 'package:perfectBeta/pages/add_route/widgets/step_progress_view.dart';
import 'package:perfectBeta/pages/add_route/widgets/step_two.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

enum ImageSourceType { gallery, camera }
final uploadImageURL =
    'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';



class AddImagePage extends StatefulWidget {
  const AddImagePage({Key key, @required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  _AddImagePage createState() => _AddImagePage();
}

class _AddImagePage extends State<AddImagePage> {
  // PageController stepController = PageController(
  //   initialPage: 0,
  //   keepPage: true,
  // );

  //Util variables
  Size safeAreaSize;
  int _curPage = 1;

  //Variables STEP 1

  //Main variables
  var convertedImage;
  String _routeName;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String imagePath;

  Future<List<ConvertedImage>> _convertedImage;

  void onDataChange(int newData) {
    setState(() => _curPage = newData);
  }

  Widget build(BuildContext context) {
    var mediaQD = MediaQuery.of(context);
    safeAreaSize = mediaQD.size;
    return Scaffold(
        body: StepOne(safeAreaSize: safeAreaSize, currentPage: _curPage, onDataChange: onDataChange),
    // body: Column(
    //   children: <Widget>[
    //     Container(
    //         height: ResponsiveWidget.isSmallScreen(context) ? 100 : 150,
    //         child: _getStepProgress()),
    //     Expanded(
    //       child:
    //           StepOne(safeAreaSize: safeAreaSize, currentPage: _curPage, onDataChange: onDataChange),
    );
  }


  // StepProgressView _getStepProgress() {
  //   return StepProgressView(
  //     _stepsText,
  //     _curPage,
  //     _stepProgressViewHeight,
  //     safeAreaSize.width,
  //     _stepCircleRadius,
  //     _activeColor,
  //     _inactiveColor,
  //     _headerStyle,
  //     _stepStyle,
  //     decoration: BoxDecoration(color: light),
  //   );
  // }

  // void _handleURLButtonPress(BuildContext context, var type) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  // }

  // void _back(pageNumber) {
  //   _routeName = routeNameController.value.text;
  //   stepController.animateToPage(
  //     pageNumber.round() - 1,
  //     duration: Duration(milliseconds: 500),
  //     curve: Curves.linear,
  //   );
  // }
}
