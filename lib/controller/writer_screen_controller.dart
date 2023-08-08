import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/suggestion_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class WriterScreenController extends GetxController {
  RxBool isSelected = false.obs;

  RxString selectedSuggestion = "".obs;

  Rx<TextEditingController> textController = TextEditingController().obs;

  RxList stringList = [].obs;

  RxString writerLimit = "0".obs;

  @override
  void onInit() {
    getArgument();
    getUser();

    super.onInit();
  }

  Rx<CategoryData> categoryData = CategoryData().obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      categoryData.value = argumentData["category"];
      getCategorySuggestion();
    }
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

    log("------->$writerLimit");
    log("------->${Constant.isActiveSubscription}");
  }

  RxList suggestionList = <SuggestionData>[].obs;
  RxBool isLoading = true.obs;

  Future<dynamic> getCategorySuggestion() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${ApiServices.suggestionByCategpry}/${categoryData.value.id}"),
          headers: ApiServices.header);
      log(ApiServices.header.toString());
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        SuggestionModel model = SuggestionModel.fromJson(responseBody);
        suggestionList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        suggestionList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
