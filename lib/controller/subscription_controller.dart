import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/subscription_model.dart';
import 'package:quicklai/service/api_services.dart';

class SubscriptionController extends GetxController {
  Rx<SubscriptionData> selectedSubscription = SubscriptionData().obs;

  @override
  void onInit() {
    getSubscription();
    super.onInit();
  }

  getSubscription() async {
    await getSubscriptionModel();
  }

  RxList subscriptionList = <SubscriptionData>[].obs;
  RxBool isLoading = true.obs;

  Future<dynamic> getSubscriptionModel() async {
    try {
      final response = await http
          .get(Uri.parse(ApiServices.subscriptions),
              headers: ApiServices.authHeader)
          .timeout(const Duration(seconds: 200));
      log("subscriptions :: ${ApiServices.authHeader}");
      log("subscriptions :: ${response.request.toString()}");
      log("subscriptions :: ${response.body}");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        SubscriptionModel model = SubscriptionModel.fromJson(responseBody);
        subscriptionList.value = model.data!;
        selectedSubscription.value = model.data!.first;
        isLoading.value = false;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        subscriptionList.clear();
        isLoading.value = false;
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
        getSubscriptionModel();
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
      }
    } on TimeoutException {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.message.toString());
    } on SocketException {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.message.toString());
    } on Error {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      // ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future sendSubscriptionData(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(
          Uri.parse(ApiServices.createUserSubscription),
          headers: ApiServices.header,
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.showToast('Subscription successfully.'.tr);
        ShowToastDialog.closeLoader();
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
