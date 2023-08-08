import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/setting_model.dart';
import 'package:quicklai/service/api_services.dart';

class MainSettingController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getSettingsData();
    super.onInit();
  }

  Future<SettingModel?> getSettingsData() async {
    try {
      final response = await http.get(
        Uri.parse(ApiServices.settings),
        headers: ApiServices.authHeader,
      );

      Map<String, dynamic> responseBody = json.decode(response.body);
      log("::::::::::::REWARD::::::::::::::::");
      log(response.request.toString());
      log(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        SettingModel model = SettingModel.fromJson(responseBody);

        Constant.writerLimit = model.data!.writerLimit;
        Constant.chatLimit = model.data!.chatLimit;
        Constant.imageLimit = model.data!.imageLimit;
        Constant.publicAppSpecificAPIKeysOfAndroid =
            model.data!.apikeyAndroidRevenuecat;
        Constant.publicAppSpecificAPIKeysOfIos =
            model.data!.apikeyIosRevenuecat;

        Constant.isAdsEnabled =
            model.data!.addIsEnabled == "yes" ? true : false;
        Constant.bannerIosKey = model.data!.iosBannerId;
        Constant.bannerAndroidAdsKey = model.data!.androidBannerId;
        Constant.interstitialIosKey = model.data!.iosInterstitialId;
        Constant.interstitialAndroidAdsKey = model.data!.androidInterstitialId;

        Constant.rewardIosKey = model.data!
            .androidRewardAdsId; //"ca-app-pub-3940256099942544/1712485313";
        Constant.rewardAndroidAdsKey = model
            .data!.iosRewardAdsId; //"ca-app-pub-3940256099942544/5224354917";

        Constant.privacyPolicy = model.data!.privacyPolicy;
        Constant.termsAndCondition = model.data!.termsAndConditions;
        Constant.supportEmail = model.data!.supportEmail;
        Constant.faqLink = model.data!.faq;
        Constant.openAiApiKey = model.data!.openaiApiKey;
        Constant.appVersion = model.data!.appVersion;

        await initPlatformState();
        isLoading.value = false;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
        isLoading.value = false;
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        isLoading.value = false;
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<void> initPlatformState() async {
    PurchasesConfiguration? configuration = PurchasesConfiguration(
      Platform.isAndroid
          ? Constant.publicAppSpecificAPIKeysOfAndroid.toString()
          : Constant.publicAppSpecificAPIKeysOfIos.toString(),
    );
    log(configuration.apiKey);
    await Purchases.configure(configuration);
  }
}
