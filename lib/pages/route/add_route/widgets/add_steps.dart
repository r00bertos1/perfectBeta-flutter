import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/pages/route/add_route/model/converted_image.dart';
import 'dart:io';
import 'package:perfectBeta/pages/route/add_route/util/steps_params.dart';
import 'package:perfectBeta/pages/route/add_route/widgets/step_progress_view.dart';
import 'package:http/http.dart' as http;

final uploadImageURL =
    'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';

class AddSteps extends StatefulWidget {
  const AddSteps({Key key}) : super(key: key);

  @override
  _AddStepsState createState() => _AddStepsState();
}

class _AddStepsState extends State<AddSteps> {
  Size safeAreaSize;
  int currentStep = 0;
  bool complete = false;
  bool received = false;

  var _image;
  var _imageFile;
  String _imagePath = '';

  var imageFile;
  String _routeName;
  bool _submitted = false;
  final ImagePicker _picker = ImagePicker();

  String imagePathTest =
      '/data/user/0/com.pl.ftims.ias.perfectbeta/cache/image_picker1161768634626818162.jpg';

  dynamic _pickImageError;

  //Textfield controller
  final routeNameController = TextEditingController();
  @override
  void dispose() {
    routeNameController.dispose();
    super.dispose();
  }

  next() {
    currentStep + 1 != getSteps().length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  Future<List<ConvertedImage>> _future;
  // @override
  // void initState() {
  //   _future = convertImage(imagePathTest);
  // }
  @override
  Widget build(BuildContext context) {
    var mediaQD = MediaQuery.of(context);
    safeAreaSize = mediaQD.size;
    return Theme(
        data: Theme.of(context).copyWith(
            //colorScheme: ColorScheme.light(background: lightGrey)
            ),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (currentStep == 0) {
              //_submit(_imagePath);
              setState(() => currentStep += 1);
            } else if (isLastStep) {
              print('Completed');
            } else {
              setState(() => currentStep += 1);
            }
          },
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep -= 1),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep = currentStep == getSteps().length - 1;
            return Container(
              margin: ResponsiveWidget.isSmallScreen(context)
                  ? const EdgeInsets.only(top: 0.0)
                  : const EdgeInsets.only(top: 20.0),
              child: currentStep == 0
                  ? _image != null
                      ? ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text('Continue'),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          child: Text('Continue'),
                        )
                  : isLastStep
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text('Back'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text('Finish'),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text('Back'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text('Continue'),
                              ),
                            ),
                          ],
                        ),
            );
          },
        ));
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep <= 0 ? StepState.indexed : StepState.complete,
            isActive: currentStep >= 0,
            title: Text(currentStep == 0 ? "Add Photo" : ""),
            content: Container(
                alignment: Alignment.center,
                constraints: ResponsiveWidget.isSmallScreen(context)
                    ? BoxConstraints.expand(height: 450)
                    : BoxConstraints.expand(),
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
                                        color: active.withOpacity(.4),
                                        width: .5),
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
                                                              ? safeAreaSize
                                                                  .width
                                                              : safeAreaSize
                                                                  .width,
                                                          height: ResponsiveWidget
                                                                  .isSmallScreen(
                                                                      context)
                                                              ? safeAreaSize
                                                                      .height -
                                                                  500
                                                              : 600,
                                                        )
                                                      : Image.file(_image,
                                                          width: ResponsiveWidget
                                                                  .isSmallScreen(
                                                                      context)
                                                              ? safeAreaSize
                                                                  .width
                                                              : safeAreaSize
                                                                  .width,
                                                          height: ResponsiveWidget
                                                                  .isSmallScreen(
                                                                      context)
                                                              ? safeAreaSize
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
                                                        ? safeAreaSize.width
                                                        : safeAreaSize.width,
                                                    height: ResponsiveWidget
                                                            .isSmallScreen(
                                                                context)
                                                        ? safeAreaSize.height -
                                                            500
                                                        : 600,
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                      color: dark,
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: kIsWeb
                                                        ? Text(
                                                            'Select photo form filesystem')
                                                        : Text(
                                                            'Take a photo or choose from gallery'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ]);
                        })))),
        Step(
            state: currentStep <= 1 ? StepState.indexed : StepState.complete,
            isActive: currentStep >= 1,
            title: Text(currentStep == 1 ? "Verify holds" : ""),
            content: Container(
              alignment: Alignment.center,
              constraints: ResponsiveWidget.isSmallScreen(context)
                  ? BoxConstraints.expand(height: 450)
                  : BoxConstraints.expand(),
              child: Container(
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
                          text: "Holds",
                          color: lightGrey,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: (_future == null) ? buildColumn() : buildFutureBuilder(),

                        // FutureBuilder<void>(
                        //   future: retriveLostData(),
                        //   builder: (BuildContext context,
                        //       AsyncSnapshot<void> snapshot) {
                        //     switch (snapshot.connectionState) {
                        //       case ConnectionState.none:
                        //       case ConnectionState.waiting:
                        //         return const Text('Picked an image');
                        //       case ConnectionState.done:
                        //         return _buildHoldsTable();
                        //       default:
                        //         return const Text('Picked an image');
                        //     }
                        //   },
                          // builder: (context, snapshot) {
                          //   // if (snapshot.connectionState != ConnectionState.done) {
                          //   //   // return: show loading widget
                          //   // }
                          //   print(snapshot.connectionState);
                          //
                          //   if (snapshot.connectionState == ConnectionState.waiting) {
                          //     return CircularProgressIndicator();
                          //   }
                          //   if (snapshot.hasError) {
                          //     return const Text('Error');
                          //   }
                          //   if (!snapshot.hasData) {
                          //     return const Text('Error');
                          //   }
                          //   var dataToShow = snapshot.data;
                          //
                          //   return ListView.builder(
                          //       itemCount: dataToShow == null ? 0 : dataToShow.length,
                          //       itemBuilder: (context, index) {
                          //         final item = dataToShow[index];
                          //         return Card(
                          //           child: ListTile(
                          //             title: Text(dataToShow[index].x1.toString()),
                          //             subtitle: Text(dataToShow[index].x2.toString()),
                          //           ),
                          //         );
                          //       });
                          // }

                          // switch (snapshot.connectionState) {
                          //   case ConnectionState.waiting:
                          //     return Text('Loading....');
                          //   default:
                          //     if (snapshot.hasError)
                          //       return Text('Error: ${snapshot.error}');
                          //     else
                          //       return Text('Result: ${snapshot.data}');
                          // }
                          // if (snapshot.hasData) {
                          //   List<ConvertedImage> holdsData = snapshot.data ?? [];
                          //   return Text(holdsData.toString());
                          // return ListView.builder(
                          // itemCount: users.length,
                          // itemBuilder: (context, index) {
                          // User user = users[index];
                          // return new ListTile(
                          // leading: CircleAvatar(
                          // backgroundImage: AssetImage(user.profilePicture),
                          // ),
                          // trailing: user.icon,
                          // title: new Text(user.name),
                          // onTap: () {
                          // Navigator.push(context,
                          // new MaterialPageRoute(builder: (context) => new Home()));
                          // },
                          // );
                          // });
                          // } else if (snapshot.hasError) {
                          //   return Text("${snapshot.error}");
                          // }
                          //
                          // // By default, show a loading spinner.
                          // return CircularProgressIndicator();
                        )
                  ],
                ),
              ),
            )),
        Step(
            state: currentStep <= 2 ? StepState.indexed : StepState.complete,
            isActive: currentStep >= 2,
            title: Text(currentStep == 2 ? "Complete" : ""),
            content: Container()),
      ];

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              _future = convertImage(_imagePath);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
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

  void _submit(imagePath) async {
    setState(() => _submitted = true);
    print(imagePath);
    convertImage(imagePath);

    //if (_errorText == null) {
    // notify the parent widget via the onSubmit callback
    //widget.onSubmit(routeNameController.value.text);
    //_routeName = routeNameController.value.text;

    // if (kIsWeb) {
    //   widget.onDataChange(_imagePath);
    // } else {
    //   widget.onDataChange(_imagePath);
    // }

    //widget.onDataChange(widget.currentPage + 1);
    // widget.stepController.animateToPage(
    //   pageNumber.round() + 1,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.linear,
    // );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => StepTwo(
    //         safeAreaSize: widget.safeAreaSize,
    //         currentPage: widget.currentPage,
    //         onDataChange: widget.onDataChange,
    //         imagePath: _imagePath),
    //   ),
    //);
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
          _imageFile = image;
        });
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
          _imageFile = image;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  //Future functions

  Future<List<ConvertedImage>> convertImage(imagePath) async {
    var uri = Uri.parse(uploadImageURL);

    var request = http.MultipartRequest('POST', uri)
      ..fields['image'] = imagePath;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      // 'Authorization':'your token'
    });


    // var response = await request.send();
    // if (response.statusCode == 200) {
    //
    //   List jsonResponse = json.decode(response.body);
    //   return jsonResponse
    //       .map((item) => new ConvertedImage.fromJson(item))
    //       .toList();
    // } else {
    //   throw Exception('Failed to create album, code:' + response.statusCode.toString() + 'body' + response.body);
    // }

    // final response = await http.post(
    //   uri,
    //   headers: <String, String>{
    //     'Access-Control-Allow-Origin': '*',
    //     'Access-Control-Allow-Credentials': 'true',
    //     'Content-Type': 'multipart/form-data',
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'image': imagePath,
    //   }),
    // );
    //
    // if (response.statusCode == 201) {
    //   List jsonResponse = json.decode(response.body);
    //         return jsonResponse
    //             .map((item) => new ConvertedImage.fromJson(item))
    //             .toList();
    // } else {
    //   throw Exception('Failed to create album, code:' + response.statusCode.toString() + 'body' + response.body);
    // }


    // Map<String, String> headers = {
    //   "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    //   "Access-Control-Allow-Credentials":
    //       "true", // Required for cookies, authorization headers with HTTPS
    // };
    // var request = new http.MultipartRequest("POST", uri);
    // request.headers.addAll(headers);
    //
    // //Constructor
    // // var multipartFile = new http.MultipartFile('image',
    // //     File(imagePath).readAsBytes().asStream(), File(imagePath).lengthSync());
    // // request.files.add(multipartFile);
    //
    // //Path
    // request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    // print('Sending Multipart file from path');
    //
    // //Bytes
    // // request.files.add(http.MultipartFile.fromBytes(
    // //     'image', File(imagePath).readAsBytesSync(),));
    //
    // request
    //     .send()
    //     .then((result) {
    //   http.Response.fromStream(result).then((response) {
    //     if (response.statusCode == 200) {
    //       print("Uploaded! ");
    //       print('response.body ' + response.body);
    //       List jsonResponse = json.decode(response.body);
    //       return jsonResponse
    //           .map((item) => new ConvertedImage.fromJson(item))
    //           .toList();
    //     } else {
    //       print(response.statusCode);
    //       print(response.body);
    //       return <ConvertedImage>[];
    //     }
    //     //return <ConvertedImage>[];
    //     //return ConvertedImage.fromJson(jsonDecode(response.body));
    //   });
    // })
    // .catchError((err) => print('error : ' + err.toString()))
    // .whenComplete(() {received = true;});
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  FutureBuilder<List<ConvertedImage>> buildFutureBuilder() {
    return FutureBuilder<List<ConvertedImage>>(
        future: _future,
        builder: (context, snapshot) {
          // if (snapshot.connectionState != ConnectionState.done) {
          //   // return: show loading widget
          // }
          print(snapshot.connectionState);
          if (snapshot.hasData) {
            var dataToShow = snapshot.data;

            return ListView.builder(
                itemCount: dataToShow == null ? 0 : dataToShow.length,
                itemBuilder: (context, index) {
                  final item = dataToShow[index];
                  return Card(
                    child: ListTile(
                      title: Text(dataToShow[index].x1.toString()),
                      subtitle: Text(dataToShow[index].x2.toString()),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return CircularProgressIndicator();
          // }
          // if (snapshot.hasError) {
          //   return const Text('Error');
          // }
          // if (!snapshot.hasData) {
          //   return const Text('Error');
          // }
          // var dataToShow = snapshot.data;
          //
          // return ListView.builder(
          //     itemCount: dataToShow == null ? 0 : dataToShow.length,
          //     itemBuilder: (context, index) {
          //       final item = dataToShow[index];
          //       return Card(
          //         child: ListTile(
          //           title: Text(dataToShow[index].x1.toString()),
          //           subtitle: Text(dataToShow[index].x2.toString()),
          //         ),
          //       );
          //     });
          // switch (snapshot.connectionState) {
          //   case ConnectionState.waiting:
          //     return Text('Loading....');
          //   default:
          //     if (snapshot.hasError)
          //       return Text('Error: ${snapshot.error}');
          //     else
          //       return Text('Result: ${snapshot.data}');
          // }
          // if (snapshot.hasData) {
          //   List<ConvertedImage> holdsData = snapshot.data ?? [];
          //   return Text(holdsData.toString());
          // return ListView.builder(
          // itemCount: users.length,
          // itemBuilder: (context, index) {
          // User user = users[index];
          // return new ListTile(
          // leading: CircleAvatar(
          // backgroundImage: AssetImage(user.profilePicture),
          // ),
          // trailing: user.icon,
          // title: new Text(user.name),
          // onTap: () {
          // Navigator.push(context,
          // new MaterialPageRoute(builder: (context) => new Home()));
          // },
          // );
          // });
          // } else if (snapshot.hasError) {
          //   return Text("${snapshot.error}");
          // }
          //
          // // By default, show a loading spinner.
          // return CircularProgressIndicator();
        });
  }

  // Widget _buildHoldsTable() {
  //   if (_imageFile != null) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           buildFutureBuilder(_imageFile.path),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               var res = await convertImage(_imageFile.path);
  //               print(res);
  //               print(received);
  //             },
  //             child: const Text('Upload'),
  //           )
  //         ],
  //       ),
  //     );
  //   } else {
  //     return const Text(
  //       'You have not yet picked an image.',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }
}
