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
import 'package:quicklai/model/characters_model.dart';
import 'package:quicklai/model/chat.dart';
import 'package:quicklai/model/chat_history_model.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/reset_limit_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class ChatBotController extends GetxController {
  final scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  RxBool isBannerLoaded = true.obs;
  RxBool isLoading = true.obs;

  RxList chatList = <Chat>[].obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  RxBool isClickable = false.obs;

  @override
  void onInit() {
    loadAd();
    loadRewardAd();
    getUser();
    getArgument();
    if (Preferences.getBoolean(Preferences.isLogin)) {
      getChat();
    } else {
      isLoading.value = false;
    }
    super.onInit();

    messageController =
        TextEditingController(text: selectedCharacter.value?.prompt).obs;
    if (selectedCharacter.value?.prompt != null) {
      sendResponse(selectedCharacter.value!.prompt!);
    }
  }

  RewardedAd? rewardedAd;

  loadRewardAd() {
    RewardedAd.load(
      adUnitId: Constant().getRewardAdUnitId().toString(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          rewardedAd = null;
          loadAd();
        },
      ),
    );
  }

  BannerAd? bannerAd;
  RxBool bannerAdIsLoaded = false.obs;

  loadAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Constant().getBannerAdUnitId().toString(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            bannerAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();
  }

  Rx<CharactersData?> selectedCharacter = CharactersData().obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      selectedCharacter.value = argumentData["charactersData"];
    }
  }

  RxString chatLimit = "0".obs;
  RxString subsChatLimit = "0".obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<GuestModel> guestUserModel = GuestModel().obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      chatLimit.value = userModel.value.data!.chatLimit.toString();
      subsChatLimit.value = userModel.value.data!.subschatLimit.toString();
    } else {
      guestUserModel.value = Constant.getGuestUser();
      chatLimit.value = guestUserModel.value.data!.chatLimit.toString();
      subsChatLimit.value = "0";
    }
  }

  Future<dynamic> getChat() async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId)
      };
      final response = await http.post(Uri.parse(ApiServices.getChatHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        ChatHistoryModel model = ChatHistoryModel.fromJson(responseBody);
        chatList.value = model.data!;
        Future.delayed(const Duration(milliseconds: 50))
            .then((_) => scrollDown());
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        chatList.clear();
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

  Future saveChat(String chat, String msg) async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'chat': chat,
        'msg': msg,
      };
      final response = await http.post(Uri.parse(ApiServices.saveChatHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.request.toString());
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

  Future sendResponse(String message) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);

      Map<String, dynamic> bodyParams = {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {"role": "user", "content": message}
        ],
      };
      final response = await http.post(Uri.parse(ApiServices.completions),
          headers: ApiServices.headerOpenAI, body: jsonEncode(bodyParams));
      log(response.statusCode.toString());
      log(response.body);

      Map<String, dynamic> responseBody =
          json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();

        AiResponceModel aiResponceModel =
            AiResponceModel.fromJson(responseBody);
        if (aiResponceModel.choices != null &&
            aiResponceModel.choices!.isNotEmpty) {
          Chat chat = Chat(
              msg: aiResponceModel.choices!.first.message!.content.toString(),
              chat: "1");
          chatList.add(chat);
          messageController.value.clear();

          if (Constant.isActiveSubscription == false) {
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await resetChatLimit();
              await saveChat("0", message);
              await saveChat("1",
                  aiResponceModel.choices!.first.message!.content.toString());
            } else {
              await resetGuestChatLimit();
            }
          } else {
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await saveChat("1",
                  aiResponceModel.choices!.first.message!.content.toString());
            }
          }

          Future.delayed(const Duration(milliseconds: 50))
              .then((_) => scrollDown());
        } else {
          ShowToastDialog.showToast('Resource not found.'.tr);
        }
      } else {
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

  Future<ResetLimitModel?> resetChatLimit() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'type': 'chat',
      };
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.resetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.request.toString());
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

  Future<ResetLimitModel?> resetGuestChatLimit() async {
    try {
      Map<String, String> bodyParams = {
        'device_id': Preferences.getString(Preferences.deviceId),
        'type': 'chat',
      };
      ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.guestResetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.request.toString());
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

  Future<dynamic> increaseLimit() async {
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
      };

      log(bodyParams.toString());
      final response = await http.post(
          Uri.parse(ApiServices.adsSeenLimitIncrease),
          headers: ApiServices.authHeader,
          body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['message']);
        if (Preferences.getBoolean(Preferences.isLogin)) {
          await Constant().getUser();
        } else {
          await Constant().getGuestUserAPI();
        }
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
