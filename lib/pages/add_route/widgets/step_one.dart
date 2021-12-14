import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/add_route/widgets/step_two.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/pages/add_route/model/converted_image.dart';
import 'dart:io';
import 'package:perfectBeta/pages/add_route/util/steps_params.dart';
import 'package:perfectBeta/pages/add_route/widgets/step_progress_view.dart';
import 'package:http/http.dart' as http;

enum ImageSourceType { gallery, camera }
final uploadImageURL =
    'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';

class StepOne extends StatefulWidget {
  final Size safeAreaSize;
  final int currentPage;
  // final PageController stepController;
  final Function(int) onDataChange;
  const StepOne(
      {Key key,
      @required this.safeAreaSize,
      @required this.currentPage,
      @required this.onDataChange})
      : super(key: key);

  @override
  _StepOne createState() => _StepOne();
}

class _StepOne extends State<StepOne> {
  var _image;
  var imageFile;
  String _routeName;
  bool _submitted = false;
  //Future<List<ConvertedImage>> _convertedImage;
  //List<ConvertedImage> imageHolds;
  final ImagePicker _picker = ImagePicker();
  var _imagePath;
  var _pickedImage;
  dynamic _pickImageError;

  //Textfield controller
  final routeNameController = TextEditingController();
  @override
  void dispose() {
    routeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          height: ResponsiveWidget.isSmallScreen(context) ? 100 : 150,
          child: _getStepProgress()),
      Expanded(
          child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints.expand(),
              child: Container(
                  child: ValueListenableBuilder(
                      valueListenable: routeNameController,
                      builder: (context, TextEditingValue value, __) {
                        return ListView(
                            //shrinkWrap: true,
                            padding: const EdgeInsets.all(0.0),
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: active.withOpacity(.4), width: .5),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 6),
                                        color: lightGrey.withOpacity(.1),
                                        blurRadius: 12)
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.only(bottom: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 16, top: 8),
                                      child: CustomText(
                                        text: 'Add your climbing wall photo',
                                        color: lightGrey,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    _image != null
                                        ? Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  _showPicker(context);
                                                },
                                                child: kIsWeb
                                                    ? Container(
                                                        child: _image,
                                                        width: ResponsiveWidget
                                                                .isSmallScreen(
                                                                    context)
                                                            ? widget
                                                                .safeAreaSize
                                                                .width
                                                            : widget
                                                                .safeAreaSize
                                                                .width,
                                                        height: ResponsiveWidget
                                                                .isSmallScreen(
                                                                    context)
                                                            ? widget.safeAreaSize
                                                                    .height -
                                                                500
                                                            : 600,
                                                      )
                                                    : Image.file(_image,
                                                        width: ResponsiveWidget
                                                                .isSmallScreen(
                                                                    context)
                                                            ? widget
                                                                .safeAreaSize
                                                                .width
                                                            : widget
                                                                .safeAreaSize
                                                                .width,
                                                        height: ResponsiveWidget
                                                                .isSmallScreen(
                                                                    context)
                                                            ? widget.safeAreaSize
                                                                    .height -
                                                                500
                                                            : 600,
                                                        fit: BoxFit.cover),
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.only(
                                              //       bottom: 8, top: 16),
                                              //   child: TextField(
                                              //     controller: routeNameController,
                                              //     cursorColor: active,
                                              //     decoration: InputDecoration(
                                              //       border: OutlineInputBorder(),
                                              //       hintText: 'Put your route name',
                                              //       errorText: _submitted
                                              //           ? _errorText
                                              //           : null,
                                              //       focusedBorder: OutlineInputBorder(
                                              //         borderSide: BorderSide(
                                              //             color: active, width: 2.0),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: lightGrey),
                                                  width: ResponsiveWidget
                                                          .isSmallScreen(
                                                              context)
                                                      ? widget
                                                          .safeAreaSize.width
                                                      : widget
                                                          .safeAreaSize.width,
                                                  height: ResponsiveWidget
                                                          .isSmallScreen(
                                                              context)
                                                      ? widget.safeAreaSize
                                                              .height -
                                                          500
                                                      : 600,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: dark,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: kIsWeb ? Text('Select photo form filesystem')
                                                        : Text('Take a photo or choose from gallery'),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: ResponsiveWidget.isSmallScreen(context)
                                    ? const EdgeInsets.only(top: 0.0)
                                    : const EdgeInsets.only(top: 20.0),
                                child: ElevatedButton(
                                  onPressed:
                                      _image != null ? () => _submit() : null,
                                  // onPressed: _image != null
                                  //     ? () async {_submit(widget.stepController.page);}
                                  //     : null,
                                  child: Text('Continue'),
                                ),
                              ),
                            ]);
                      }))))
    ]);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
                child: kIsWeb
                    ? Wrap(
                        children: <Widget>[
                          ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('File system'),
                              onTap: () {
                                _imgFromSource(ImageSourceType.gallery);
                                Navigator.of(context).pop();
                              })
                        ],
                      )
                    : Wrap(
                        children: <Widget>[
                          ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Photo Library'),
                              onTap: () {
                                _imgFromSource(ImageSourceType.gallery);
                                Navigator.of(context).pop();
                              }),
                          ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () {
                              _imgFromSource(ImageSourceType.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )),
          );
        });
  }

  String get _errorText {
    final text = routeNameController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  void _submit() async {
    setState(() => _submitted = true);
    //if (_errorText == null) {
    // notify the parent widget via the onSubmit callback
    //widget.onSubmit(routeNameController.value.text);
    _routeName = routeNameController.value.text;
    //Variables STEP 2
    // if (kIsWeb) {
    //   widget.onDataChange(_imagePath);
    // } else {
    //   widget.onDataChange(_imagePath);
    // }
    widget.onDataChange(widget.currentPage + 1);
    // widget.stepController.animateToPage(
    //   pageNumber.round() + 1,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.linear,
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StepTwo(
            safeAreaSize: widget.safeAreaSize,
            currentPage: widget.currentPage,
            onDataChange: widget.onDataChange,
            imagePath: _imagePath),
      ),
    );
    //print(_image.runtimeType);
    //imageHolds = await convertImage(_image);

    // setState(() {
    //   state = res;
    //   print(res);
    // });
    // }
  }

  Future _imgFromSource(type) async {
    try {
      if (kIsWeb) {
        var source = type == ImageSourceType.camera
            ? ImageSource.camera
            : ImageSource.gallery;
        XFile image = await _picker.pickImage(
            source: source,
            imageQuality: 100,
            preferredCameraDevice: CameraDevice.front);
        setState(() {
          _image = Image.network(image.path);
          _imagePath = image.path;
          //_pickedImage = File(image.path);
          //var bytes = image.readAsBytes();
        });
        //Solution 2
        // final image =
        //     (await ImagePickerWeb.getImage(outputType: ImageType.widget))
        //         as Image;
        //
        // if (image != null) {
        //   setState(() {
        //     _image = image;
        //     print(_image.toString());
        //   });
        // };
      } else {
        var source = type == ImageSourceType.camera
            ? ImageSource.camera
            : ImageSource.gallery;
        XFile image = await _picker.pickImage(
            source: source,
            imageQuality: 100,
            preferredCameraDevice: CameraDevice.front);
        setState(() {
          _image = File(image.path);
          _imagePath = image.path;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // Future<List<ConvertedImage>> convertImage(image) async {
  //   var uri = Uri.parse(uploadImageURL);
  //   Map<String, String> headers = {
  //     "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  //     "Access-Control-Allow-Credentials":
  //     "true", // Required for cookies, authorization headers with HTTPS
  //   };
  //
  //   var request = new http.MultipartRequest("POST", uri);
  //   request.headers.addAll(headers);
  //   var multipartFile = new http.MultipartFile(
  //       'image', image.readAsBytes().asStream(), await image.length(),
  //       filename: _routeName);
  //
  //   request.files.add(multipartFile);
  //   request
  //       .send()
  //       .then((result) async {
  //     http.Response.fromStream(result).then((response) {
  //       if (response.statusCode == 200) {
  //         print("Uploaded! ");
  //         print('response.body ' + response.body);
  //       } else {
  //         print(response.statusCode);
  //         throw Exception('Failed to send an image.');
  //       }
  //       List jsonResponse = json.decode(response.body);
  //       return jsonResponse
  //           .map((item) => new ConvertedImage.fromJson(item))
  //           .toList();
  //       //return ConvertedImage.fromJson(jsonDecode(response.body));
  //     });
  //   })
  //       .catchError((err) => print('error : ' + err.toString()))
  //       .whenComplete(() {});
  // }
  StepProgressView _getStepProgress() {
    return StepProgressView(
      StepsParams.stepsText,
      widget.currentPage,
      StepsParams.stepProgressViewHeight,
      widget.safeAreaSize.width,
      StepsParams.stepCircleRadius,
      StepsParams.activeColor,
      StepsParams.inactiveColor,
      StepsParams.headerStyle,
      StepsParams.stepStyle,
      decoration: BoxDecoration(color: light),
    );
  }
}
