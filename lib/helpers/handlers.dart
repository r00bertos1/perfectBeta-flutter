import 'package:perfectBeta/service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/model/auth/registration_dto.dart';
import 'package:perfectBeta/model/users/data/change_password_dto.dart';
import 'package:perfectBeta/model/users/data/email_dto.dart';
import 'package:perfectBeta/model/users/data/password_dto.dart';
import 'package:perfectBeta/model/users/data/personal_data_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/users/user_info/confirm_change_email.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';
import '../main.dart';
import 'package:flutter/cupertino.dart';

//API
var _routeEndpoint = new RouteEndpoint(getIt.get());
var _cloudEndpoint = new CloudEndpoint(getIt.get());
var _userEndpoint = new UserEndpoint(getIt.get());
var _managerEndpoint = new ManagerEndpoint(getIt.get());

Future<bool> handleAddFavourite(int routeId, bool added) async {
  if (added) {
    var res = await _routeEndpoint.removeRouteFromFavourites(routeId);
    if (res != null) {
      if (res.statusCode == 200) {
        return true;
      }
    }
    return false;
  } else {
    var res = await _routeEndpoint.addRouteToFavourites(routeId);
    if (res != null) {
      if (res.statusCode == 200) {
        return true;
      }
    }
    return false;
  }
}

void handleAddRoute(BuildContext context, int gymId) {
  menuController.changeActiveItemTo(addRoutePageDisplayName);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddRoutePage(gymId: gymId),
    ),
  );
}

Future<bool> handleRouteDelete(BuildContext context, int gymId, int routeId) async {
  try {
    var res = await _routeEndpoint.deleteRoute(gymId, routeId);
    if (res.statusCode == 200) {
      EasyLoading.showSuccess('Route removed!');
      Navigator.pop(context);
      return true;
    }
    return false;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<bool> handleFavouriteRouteDelete(BuildContext context, int routeId) async {
  try {
    var res = await _routeEndpoint.removeRouteFromFavourites(routeId);
    if (res.statusCode == 200) {
      EasyLoading.showSuccess('Route removed!');
      return true;
    }
    return false;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<String>> handleImagesUpload(files) async {
  try {
    List<String> linksList = [];
    var res = await _cloudEndpoint.uploadFile(files);
    if (res != null) {
      if (res.statusCode == 200) {
        linksList = (jsonDecode(res.data) as List<dynamic>).cast<String>();
      }
    }
    return linksList;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<void> handleResetPassword(BuildContext context, String code, String email) async {
  var res = await _userEndpoint.confirmChangeEmail(code, email);
  try {
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      EasyLoading.showSuccess('Email has been changed!');
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<void> handlePasswordChange(BuildContext context, String oldPassword, String newPassword) async {
  ChangePasswordDTO passwordData = new ChangePasswordDTO(oldPassword: oldPassword, newPassword: newPassword);
  var res = await _userEndpoint.changePassword(passwordData);
  try {
    if (res.statusCode == 200) {
      var _rememberMe = await UserSecureStorage.getRememberMe() ?? false;
      if (_rememberMe) {
        await UserSecureStorage.setPassword(newPassword);
      }
      Navigator.of(context).pop();
      EasyLoading.showSuccess('Password was successfully changed!');
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<void> handlePersonalDataChange(int userId, String name, String surname, String phoneNumber, String country, bool gender) async {
  PersonalDataDTO personalData = new PersonalDataDTO(name: name, surname: surname, phoneNumber: phoneNumber, language: country, gender: gender);
  var res = await _userEndpoint.updatePersonalData(userId, personalData);
  try {
    if (res.statusCode == 200) {
      EasyLoading.showSuccess('Personal information updated!');
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<void> handleChangeEmail(BuildContext context, String emailString) async {
  EmailDTO email = new EmailDTO(email: emailString);
  var res = await _userEndpoint.requestChangeEmail(email);
  try {
    if (res.statusCode == 200) {
      //Get.off(ConfirmChangeEmail(email: email), routeName: changeEmailPageRoute);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmChangeEmail(email: email),
        ),
      );
      EasyLoading.showSuccess('Email change instructions have been sent to current email!');
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<void> handleUserDelete(TextEditingController passwordController) async {
  UserWithPersonalDataAccessLevelDTO userData = await _userEndpoint.getUserPersonalDataAccessLevel();
  PasswordDTO password = new PasswordDTO(password: passwordController.text.trim());
  passwordController.clear();
  var res = await _userEndpoint.deleteUser(userData.id, password);
  if (res != null) {
    if (res.statusCode == 200) {
      Get.offAllNamed(authenticationPageRoute);
      // menuController.changeActiveItemTo(
      //     overviewPageDisplayName);
    }
  } else {
    EasyLoading.showError('Error' + res.statusMessage);
  }
}

Future<void> handleRegistration({BuildContext context, String username, String email, String password}) async {
  // login
  RegistrationDTO registerData = new RegistrationDTO(
      login: username, email: email, password: password);
  var res = await _managerEndpoint.registerManager(registerData);
  try {
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      EasyLoading.showSuccess('New manager was successfully created!');
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}
