import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/customer_subscription_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/utils/Preferences.dart';

class DashBoardController extends GetxController {
  RxInt index = 0.obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUser();
    super.onInit();
  }

  getUser() async {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      await Constant().getUser();
      getCustomer();
    } else {
      await Constant().getGuestUserAPI();
    }

    isLoading.value = false;
  }

  getCustomer() async {
    try {
      await Purchases.logIn(Preferences.getString(Preferences.customerId));

      UserModel user = Constant.getUserData();
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      Purchases.setEmail(user.data!.email.toString());
      Purchases.setPhoneNumber(user.data!.photo.toString());
      Purchases.setDisplayName(user.data!.name.toString());

      // access latest customerInfo
      log(jsonEncode(customerInfo.toJson()));
      CustomerSubscriptionModel customerSubscriptionModel =
          CustomerSubscriptionModel.fromJson(customerInfo.toJson());

      Constant.isActiveSubscription =
          customerSubscriptionModel.entitlements!.active!.toJson().isNotEmpty;
      log(":------>${customerSubscriptionModel.entitlements!.active!.toJson().isNotEmpty}");
    } on PlatformException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    }
  }
}
