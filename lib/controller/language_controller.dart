import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/language_model.dart';
import 'package:quicklai/service/api_services.dart';

class LanguageController extends GetxController {
  RxList languageList = <LanguageData>[].obs;

  @override
  void onInit() {
    getLanguage();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  Future<dynamic> getLanguage() async {
    try {
      final response = await http.get(Uri.parse(ApiServices.languages), headers: ApiServices.authHeader);
      log(ApiServices.authHeader.toString());
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        LanguageModel model = LanguageModel.fromJson(responseBody);
        languageList.value = model.data!;
        isLoading.value = false;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        languageList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast('Something want wrong. Please try again later'.tr);
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
