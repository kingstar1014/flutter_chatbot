import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/ai_responce_model.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/reset_limit_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class AiCodeController extends GetxController {
  RxString selectedSuggestion = "".obs;
  Rx<TextEditingController> textController = TextEditingController().obs;
  RxString question = "".obs;
  RxString answer = "".obs;
  RxBool isSelected = false.obs;
  RxList stringList = [].obs;
  RxString writerLimit = "0".obs;

  @override
  void onInit() {
    loadAd();
    getUser();
    super.onInit();
  }

  BannerAd? bannerAd;
  RxBool bannerAdIsLoaded = false.obs;

  loadAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Constant().getBannerAdUnitId().toString(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            bannerAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
        ),
        request: const AdRequest())
      ..load();
  }

  Rx<UserModel> userModel = UserModel().obs;
  Rx<GuestModel> guestUserModel = GuestModel().obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      writerLimit.value = userModel.value.data!.writerLimit.toString();
    } else {
      guestUserModel.value = Constant.getGuestUser();
      writerLimit.value = guestUserModel.value.data!.writerLimit.toString();
    }
  }

  Rx<CategoryData> categoryData = CategoryData().obs;

  getArgument(data) async {
    dynamic argumentData = data;
    if (argumentData != null) {
      question.value = argumentData["pramot"];
      categoryData.value = argumentData["category"];
      sendResponse(question.value);
    }
  }

  Future sendResponse(String message) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);

      Map<String, dynamic> bodyParams = {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {"role": "user", "content": '$message Computer Program code'}
        ],
      };

      final response = await http.post(Uri.parse(ApiServices.completions),
          headers: ApiServices.headerOpenAI, body: jsonEncode(bodyParams));
      log(bodyParams.toString());
      log(response.statusCode.toString());
      log(response.body);
      Map<String, dynamic> responseBody =
          json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        textController.value.clear();
        ShowToastDialog.closeLoader();

        AiResponceModel aiResponceModel =
            AiResponceModel.fromJson(responseBody);
        if (aiResponceModel.choices != null &&
            aiResponceModel.choices!.isNotEmpty) {
          answer.value =
              aiResponceModel.choices!.first.message!.content.toString();

          if (Constant.isActiveSubscription == false) {
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await savePrompt();
              await resetWriterLimit();
            } else {
              await resetGuestWriterLimit();
            }
          } else {
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await savePrompt();
            }
          }
        } else {
          ShowToastDialog.showToast('Resource not found.'.tr);
        }
      } else {
        textController.value.clear();
        Map<String, dynamic> responseBody = json.decode(response.body);

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']['message']);
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
    return null;
  }

  Future savePrompt() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'category_id': '1',
        'category_name': 'AI Code',
        'subject': question.value,
        'answer': answer.value,
      };
      final response = await http.post(Uri.parse(ApiServices.savePromsHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        return true;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
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

  Future<ResetLimitModel?> resetWriterLimit() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'type': 'writer',
      };
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.resetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ResetLimitModel resetLimitModel =
            ResetLimitModel.fromJson(responseBody);
        await Constant().getUser();
        getUser();
        ShowToastDialog.closeLoader();
        return resetLimitModel;
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
    return null;
  }

  Future<ResetLimitModel?> resetGuestWriterLimit() async {
    try {
      Map<String, String> bodyParams = {
        'device_id': Preferences.getString(Preferences.deviceId),
        'type': 'writer',
      };
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.guestResetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ResetLimitModel resetLimitModel =
            ResetLimitModel.fromJson(responseBody);
        await Constant().getGuestUserAPI();
        getUser();
        ShowToastDialog.closeLoader();
        return resetLimitModel;
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
    return null;
  }
}
