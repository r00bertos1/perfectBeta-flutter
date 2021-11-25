import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'package:perfectBeta/pages/add_route/widgets/step_progress_view.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

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
  bool _edited = false;

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
            physics: NeverScrollableScrollPhysics(),
            controller: stepController,
            onPageChanged: (i) {
              setState(() {
                _curPage = i + 1;
                print('Value' + stepController.page.toString());
                print('Type' + stepController.page.runtimeType.toString());
              });
            },
            children: <Widget>[
              stepOne(context, _safeAreaSize),
              stepTwo(context, _safeAreaSize),
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
        });
      }
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

  void _submit(pageNumber) {
    setState(() => _submitted = true);
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      widget.onSubmit(routeNameController.value.text);
      _routeName = routeNameController.value.text;
      stepController.animateToPage(
        pageNumber.round() + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
  }

  void _back(pageNumber) {
    _routeName = routeNameController.value.text;
    stepController.animateToPage(
      pageNumber.round() - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  Widget stepOne(BuildContext context, _safeAreaSize) {
    return Container(
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
                                padding: EdgeInsets.only(bottom: 16, top: 8),
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
                                                      ? _safeAreaSize.width
                                                      : _safeAreaSize.width,
                                                  height: ResponsiveWidget
                                                          .isSmallScreen(
                                                              context)
                                                      ? _safeAreaSize.height -
                                                          500
                                                      : 600,
                                                )
                                              : Image.file(_image,
                                                  width: ResponsiveWidget
                                                          .isSmallScreen(
                                                              context)
                                                      ? _safeAreaSize.width
                                                      : _safeAreaSize.width,
                                                  height: ResponsiveWidget
                                                          .isSmallScreen(
                                                              context)
                                                      ? _safeAreaSize.height -
                                                          500
                                                      : 600,
                                                  fit: BoxFit.cover),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 8, top: 16),
                                          child: TextField(
                                            controller: routeNameController,
                                            cursorColor: active,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Put your route name',
                                              errorText: _submitted
                                                  ? _errorText
                                                  : null,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: active, width: 2.0),
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
                                            decoration:
                                                BoxDecoration(color: lightGrey),
                                            width:
                                                ResponsiveWidget.isSmallScreen(
                                                        context)
                                                    ? _safeAreaSize.width
                                                    : _safeAreaSize.width,
                                            height:
                                                ResponsiveWidget.isSmallScreen(
                                                        context)
                                                    ? _safeAreaSize.height - 500
                                                    : 600,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: dark,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Text(
                                              kIsWeb
                                                  ? 'Select photo form filesystem'
                                                  : 'Take a photo or choose from gallery',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          margin: ResponsiveWidget
                              .isSmallScreen(
                              context)
                              ? const EdgeInsets.only(top: 0.0)
                              : const EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                            style: _buttonStyle,
                            onPressed: _image != null
                                ? () => _submit(stepController.page)
                                : null,
                            child: Text('Continue'),
                          ),
                        ),
                      ]);
                })));
  }

  Widget stepTwo(BuildContext context, _safeAreaSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
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
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Available Drivers",
                color: lightGrey,
                weight: FontWeight.bold,
              ),
            ],
          ),
          DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: [
                DataColumn2(
                  label: Text("Name"),
                  size: ColumnSize.L,
                ),
                DataColumn(
                  label: Text('Location'),
                ),
                DataColumn(
                  label: Text('Rating'),
                ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              rows: List<DataRow>.generate(
                  7,
                  (index) => DataRow(cells: [
                        DataCell(CustomText(text: "Adam Nowak")),
                        DataCell(CustomText(text: "łódź")),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              text: "4.5",
                            )
                          ],
                        )),
                        DataCell(Container(
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active, width: .5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: CustomText(
                              text: "Assign Delivery",
                              color: active.withOpacity(.7),
                              weight: FontWeight.bold,
                            ))),
                      ]))),
        ],
      ),
    );
  }
}
