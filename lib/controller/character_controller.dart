import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/characters_model.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class CharacterController extends GetxController {
  @override
  void onInit() {
    loadAd();
    getCharacter();
    getUser();
    super.onInit();
  }

  RewardedAd? rewardedAd;

  loadAd() {
    RewardedAd.load(
        adUnitId: Constant().getRewardAdUnitId().toString(),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('$ad loaded.');
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            rewardedAd = null;
            loadAd();
          },
        ));
  }

  RxList charactesList = <CharactersData>[].obs;
  RxBool isLoading = true.obs;
  Rx<CharactersData?> selectedCharacter = CharactersData().obs;

  Future<dynamic> getCharacter() async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_type':
            Preferences.getBoolean(Preferences.isLogin) ? "app" : "guest",
        'user_id': Preferences.getBoolean(Preferences.isLogin)
            ? Preferences.getString(Preferences.userId)
            : "",
        'device_id': Preferences.getBoolean(Preferences.isLogin) == false
            ? Preferences.getString(Preferences.deviceId)
            : ""
      };

      final response = await http.post(Uri.parse(ApiServices.characters),
          headers: ApiServices.authHeader, body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        CharactersModel model = CharactersModel.fromJson(responseBody);
        charactesList.value = model.data!;
        isLoading.value = false;

        final bool productIsInList = charactesList.any((product) =>
            product.name ==
            Preferences.getString(Preferences.selectedCharacters));
        if (productIsInList) {
          selectedCharacter.value = charactesList.firstWhere((product) =>
              product.name ==
              Preferences.getString(Preferences.selectedCharacters));
        } else {
          selectedCharacter.value = charactesList.first;
        }
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        charactesList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      debugPrint("======>${e.message}");
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      debugPrint("======>${e.message}");
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      debugPrint("======>${e.toString()}");
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Rx<UserModel> userModel = UserModel().obs;
  Rx<GuestModel> guestUserModel = GuestModel().obs;

  RxString chatLimit = "0".obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      chatLimit.value = userModel.value.data!.chatLimit.toString();
    } else {
      guestUserModel.value = Constant.getGuestUser();
      chatLimit.value = guestUserModel.value.data!.chatLimit.toString();
    }
  }

  Future<dynamic> unlockCharacter(String characterDd) async {
    ShowToastDialog.showToast("Please wait");
    try {
      Map<String, dynamic> bodyParams = {
        'user_type':
            Preferences.getBoolean(Preferences.isLogin) ? "app" : "guest",
        'user_id': Preferences.getBoolean(Preferences.isLogin)
            ? Preferences.getString(Preferences.userId)
            : "",
        'device_id': Preferences.getBoolean(Preferences.isLogin) == false
            ? Preferences.getString(Preferences.deviceId)
            : "",
        'character_id': characterDd
      };

      log(bodyParams.toString());
      final response = await http.post(
          Uri.parse(ApiServices.adsSeenUnlockCharacter),
          headers: ApiServices.authHeader,
          body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['message']);
        getCharacter();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['message']);
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        ShowToastDialog.closeLoader();
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
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
