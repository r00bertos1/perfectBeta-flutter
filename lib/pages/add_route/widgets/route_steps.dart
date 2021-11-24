import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'image_from_gallery_ex.dart';
import 'package:perfectBeta/pages/add_route/widgets/step_progress_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum ImageSourceType { gallery, camera }

class AddImagePage extends StatefulWidget {
  const AddImagePage({Key key, @required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  _AddImagePage createState() => _AddImagePage();
}

class _AddImagePage extends State<AddImagePage> {
  //Main variables
  var _image;
  var imageFile;
  var _imagePath;
  String _routeName;

  //Util variables
  Size _safeAreaSize;
  int _curPage = 1;
  bool _submitted = false;

  //Image picker variables
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  //CONTROLLERS
  final routeNameController = TextEditingController();
  @override
  void dispose() {
    routeNameController.dispose();
    super.dispose();
  }

  PageController stepController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  //Steps
  final _stepsText = ["Add photo", "Verify holds", "Step 3"];
  final _stepCircleRadius = 10.0;
  final _stepProgressViewHeight = 150.0;
  final _stepProgressViewHeightMobile = 50.0;
  Color _activeColor = active;
  Color _inactiveColor = Colors.grey;
  TextStyle _headerStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle _stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: active,
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ));

  Widget build(BuildContext context) {
    var mediaQD = MediaQuery.of(context);
    _safeAreaSize = mediaQD.size;
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
            height: ResponsiveWidget.isSmallScreen(context) ? 100 : 150,
            child: _getStepProgress()),
        Expanded(
          child: PageView(
            controller: stepController,
            onPageChanged: (i) {
              setState(() {
                _curPage = i + 1;
              });
            },
            children: <Widget>[
              Container(
                  constraints: const BoxConstraints.expand(),
                  child: Container(
                      //color: active,
                      alignment: Alignment.center,
                      child: ValueListenableBuilder(
                          valueListenable: routeNameController,
                          builder: (context, TextEditingValue value, __) {
                            return ListView(
                                //shrinkWrap: true,
                                padding: const EdgeInsets.all(0.0),
                                children: [
                                  Card(
                                    child: Column(
                                      children: <Widget>[
                                        _image != null
                                            ? Column(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showPicker(context);
                                                    },
                                                    child: kIsWeb
                                                        ? Image.network(_imagePath,
                                                            width: ResponsiveWidget.isSmallScreen(context)
                                                                ? _safeAreaSize
                                                                    .width
                                                                : _safeAreaSize
                                                                    .width,
                                                            height: ResponsiveWidget.isSmallScreen(context)
                                                                ? _safeAreaSize
                                                                        .height -
                                                                    500
                                                                : 600,
                                                            fit: BoxFit.cover)
                                                        : Image.file(_image,
                                                            width: ResponsiveWidget.isSmallScreen(context)
                                                                ? _safeAreaSize
                                                                    .width
                                                                : _safeAreaSize
                                                                    .width,
                                                            height: ResponsiveWidget
                                                                    .isSmallScreen(
                                                                        context)
                                                                ? _safeAreaSize.height - 500
                                                                : 600,
                                                            fit: BoxFit.cover),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 16),
                                                    child: TextField(
                                                      controller:
                                                          routeNameController,
                                                      cursorColor: active,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Put your route name',
                                                        errorText: _submitted
                                                            ? _errorText
                                                            : null,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: active,
                                                                  width: 2.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                          ? _safeAreaSize.width
                                                          : _safeAreaSize.width,
                                                      height: ResponsiveWidget
                                                              .isSmallScreen(
                                                                  context)
                                                          ? _safeAreaSize
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
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 16),
                                                      child: Text(
                                                          'Take a photo or choose from gallery'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      style: _buttonStyle,
                                      onPressed: _image != null &&
                                              routeNameController
                                                  .value.text.isNotEmpty &&
                                              routeNameController
                                                      .value.text.length >=
                                                  4
                                          ? _submit
                                          : null,
                                      child: Text('Continue'),
                                    ),
                                  ),
                                ]);
                          }))),
              Container(
                constraints: const BoxConstraints.expand(),
                child: Container(
                    color: active,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Card(
                              child: Column(
                            children: <Widget>[
                              _image != null
                                  ? Image.file(
                                      _image,
                                      width: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? _safeAreaSize.width
                                          : _safeAreaSize.width,
                                      height: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? _safeAreaSize.height - 500
                                          : 600,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      decoration:
                                          BoxDecoration(color: lightGrey),
                                      width: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? _safeAreaSize.width
                                          : _safeAreaSize.width,
                                      height: 300,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: dark,
                                      ),
                                    ),
                            ],
                          )),
                        ),
                      ],
                    )),
              ),
              Container(
                color: lightGrey,
              ),
            ],
          ),
        )
      ],
    ));
  }

  StepProgressView _getStepProgress() {
    return StepProgressView(
      _stepsText,
      _curPage,
      _stepProgressViewHeight,
      _safeAreaSize.width,
      _stepCircleRadius,
      _activeColor,
      _inactiveColor,
      _headerStyle,
      _stepStyle,
      decoration: BoxDecoration(color: light),
    );
  }

  // void _handleURLButtonPress(BuildContext context, var type) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  // }

  Future<File> _fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    //NOT WORKING IN WEB
    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future _imgFromSource(type) async {
    try {
      var source = type == ImageSourceType.camera
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile image = await _picker.pickImage(
          source: source,
          imageQuality: 100,
          preferredCameraDevice: CameraDevice.front);
      setState(() {
        // if (kIsWeb) {
        //   //File file = Image.network(image.path) as File;
        //   //File file = html.File(image.path.codeUnits, image.path) as File;
        //   //_image = File(Image.network(image.path));
        //   File file = await _fileFromImageUrl(image.path);
        //   _image = file;
        // } else {
          _image = File(image.path);
       // }
        // File file = File(image.path);
        // _image = file;
        //_image = html.File(image.path.codeUnits, image.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
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
                              title: new Text('Web link'),
                              onTap: () {
                                _imagePath = 'https://picsum.photos/250?image=9';
                                _image = _imagePath;
                                Navigator.of(context).pop();
                              }),
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

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      widget.onSubmit(routeNameController.value.text);
      _routeName = routeNameController.value.text;
      stepController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
