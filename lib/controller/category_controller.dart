import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/service/api_services.dart';

class CategoryController extends GetxController {
  @override
  void onInit() {
    loadAd();
    getCategory();
    super.onInit();
  }

  Rx<CategoryData> selectedCategory = CategoryData().obs;

  InterstitialAd? interstitialAd;

  loadAd() {
    InterstitialAd.load(
        adUnitId: Constant().getInterstitialAdUnitId().toString(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            interstitialAd = null;
          },
        ));
  }

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
