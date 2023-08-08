import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class HistoryController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();

    super.onInit();
  }

  Rx<String?> categoryId = "".obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      categoryId.value = argumentData["categoryId"];
    }
    if (Preferences.getBoolean(Preferences.isLogin)) {
      getHistoryProms();
    }
  }

  RxList historyList = <HistoryData>[].obs;
  RxBool isLoading = true.obs;

  Future<dynamic> getHistoryProms() async {
    try {
      log(categoryId.value.toString());
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'category_id': categoryId.value
      };
      final response = await http.post(Uri.parse(ApiServices.getPromsHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        HistoryModel model = HistoryModel.fromJson(responseBody);
        historyList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        historyList.clear();
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
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
