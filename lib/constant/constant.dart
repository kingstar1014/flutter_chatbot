// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class Constant {
  static String? openAiApiKey = "";

  static String? publicAppSpecificAPIKeysOfAndroid = "";
  static String? publicAppSpecificAPIKeysOfIos = "";
  static String? writerLimit = "3";
  static String? chatLimit = "3";
  static String? imageLimit = "3";
  static bool? isActiveSubscription = false;

  static bool? isAdsEnabled = true;
  static String? bannerAndroidAdsKey = "";
  static String? bannerIosKey = "";
  static String? interstitialAndroidAdsKey = "";
  static String? interstitialIosKey = "";
  static String? rewardAndroidAdsKey = "";
  static String? rewardIosKey = "";
  static String? privacyPolicy = "";
  static String? termsAndCondition = "";
  static String? faqLink = "";
  static String? supportEmail = "";
  static String? appVersion = "";

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter valid email'.tr;
    } else {
      return null;
    }
  }

  static UserModel getUserData() {
    final String user = Preferences.getString(Preferences.user);
    Map<String, dynamic> userMap = jsonDecode(user);
    return UserModel.fromJson(userMap);
  }

  static GuestModel getGuestUser() {
    final String user = Preferences.getString(Preferences.gustUser);
    Map<String, dynamic> userMap = jsonDecode(user);
    return GuestModel.fromJson(userMap);
  }

  Future<UserModel?> getUser() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
      };
      final response = await http.post(Uri.parse(ApiServices.getUser),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log("getUser :: ${response.request}");
      log("getUser :: ${response.body}");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        UserModel userModel = UserModel.fromJson(responseBody);
        Preferences.setString(Preferences.user, jsonEncode(userModel));
        return UserModel.fromJson(responseBody);
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
        getUser();
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<GuestModel?> getGuestUserAPI() async {
    try {
      Map<String, String> bodyParams = {
        'device_id': Preferences.getString(Preferences.deviceId),
      };
      final response = await http.post(Uri.parse(ApiServices.guestLogin),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        GuestModel userModel = GuestModel.fromJson(responseBody);
        Preferences.setString(Preferences.user, jsonEncode(userModel));
        return GuestModel.fromJson(responseBody);
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
        getGuestUserAPI();
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  bool isAdsShow() {
    log("============>");
    log(Constant.isAdsEnabled.toString());
    log(Constant.isActiveSubscription.toString());
    if (Constant.isAdsEnabled == true &&
        Constant.isActiveSubscription == true) {
      return false;
    } else if (Constant.isAdsEnabled == true &&
        Constant.isActiveSubscription == false) {
      return true;
    } else if (Constant.isAdsEnabled == false &&
        Constant.isActiveSubscription == false) {
      return false;
    } else if (Constant.isAdsEnabled == false &&
        Constant.isActiveSubscription == true) {
      return false;
    }
    return false;
  }

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      return const AndroidId().getId(); // unique ID on Android
    }
    return null;
  }

  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return Constant.bannerIosKey;
    } else if (Platform.isAndroid) {
      return Constant.bannerAndroidAdsKey;
    }
    return null;
  }

  String? getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return Constant.interstitialIosKey;
    } else if (Platform.isAndroid) {
      return Constant.interstitialAndroidAdsKey;
    }
    return null;
  }

  String? getRewardAdUnitId() {
    if (Platform.isIOS) {
      return Constant.rewardIosKey;
    } else if (Platform.isAndroid) {
      return Constant.rewardAndroidAdsKey;
    }
    return null;
  }
}
