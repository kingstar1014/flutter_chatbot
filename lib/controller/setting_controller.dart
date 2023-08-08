import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

import '../constant/constant.dart';

class SettingController extends GetxController {
  RxString profileImage = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit

    getUser();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      profileImage.value = userModel.value.data!.photo.toString();
    }
  }

  Future<dynamic> uploadPhoto(File image) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiServices.updateProfilePicture),
      );
      request.headers.addAll(ApiServices.header);

      request.files.add(http.MultipartFile.fromBytes(
          'photo', image.readAsBytesSync(),
          filename: image.path.split('/').last));
      request.fields['user_id'] = Preferences.getString(Preferences.userId);

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      log(String.fromCharCodes(responseData));
      Map<String, dynamic> response =
          jsonDecode(String.fromCharCodes(responseData));

      if (res.statusCode == 200) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Uploaded!'.tr);
        return response;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future<bool?> deleteAccount(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.deleteAccount),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.showToast(responseBody['message']);
        ShowToastDialog.closeLoader();
        return true;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return false;
  }
}
