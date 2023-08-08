import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/banner_model.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/model/category_suggestion_model.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class HomeController extends GetxController {
  RxList<CategorySuggestionModel> topCategoryList =
      <CategorySuggestionModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    loadRewardAd();
    loadAd();
    super.onInit();
  }

  InterstitialAd? interstitialAd;

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
        ));
  }

  loadAd() {
    InterstitialAd.load(
        adUnitId: Constant().getInterstitialAdUnitId().toString(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAd = null;
          },
        ));
  }

  getNewCategory() {
    topCategoryList.add(CategorySuggestionModel(
        id: 0, name: 'AI Code', icon: 'assets/images/ai.png'));
    topCategoryList.add(CategorySuggestionModel(
        id: 0, name: 'Astrology', icon: 'assets/images/astrologyIcon.png'));
  }

  getData() async {
    await getBanner().then((value) => getCategory());
    await getNewCategory();

    if (Preferences.getBoolean(Preferences.isLogin)) {
      await getHistoryProms();
    } else {
      isHistoryLoading.value = false;
    }
  }

  Rx<CategoryData> selectedCategory = CategoryData().obs;

  RxList categoryList = <CategoryData>[].obs;
  RxBool isLoading = true.obs;

  Future<dynamic> getCategory() async {
    try {
      final response = await http.get(Uri.parse(ApiServices.categories),
          headers: ApiServices.authHeader);
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        CategoryModel model = CategoryModel.fromJson(responseBody);
        categoryList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        categoryList.clear();
        isLoading.value = false;
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
        getCategory();
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

  RxList bannerList = <BannerData>[].obs;
  RxBool isBannerLoading = true.obs;

  Future<dynamic> getBanner() async {
    try {
      final response = await http.get(Uri.parse(ApiServices.banners),
          headers: ApiServices.authHeader);
      log("banners :: ${response.request}");
      log("banners :: ${response.body}");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isBannerLoading.value = false;
        BannerModel model = BannerModel.fromJson(responseBody);
        bannerList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        bannerList.clear();
        isBannerLoading.value = false;
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
        getBanner();
      } else {
        isBannerLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isBannerLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isBannerLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isBannerLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  RxList historyList = <HistoryData>[].obs;
  RxBool isHistoryLoading = true.obs;

  Future<dynamic> getHistoryProms() async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'category_id': "0"
      };
      final response = await http.post(Uri.parse(ApiServices.getPromsHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isHistoryLoading.value = false;
        HistoryModel model = HistoryModel.fromJson(responseBody);
        historyList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        historyList.clear();
        isHistoryLoading.value = false;
      } else {
        isHistoryLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isHistoryLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isHistoryLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isHistoryLoading.value = false;
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
