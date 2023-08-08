import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/model/onboarding_model.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  List<OnboardingModel> onBoardingList = [
    // OnboardingModel(
    //     'assets/images/intro_1.gif',
    //     'Quickl is intended to boost your productivity by quick access to information.'
    //         .tr,
    //     'Your AI assistant'.tr),
    OnboardingModel(
        'assets/images/writing.json',
        'Quickl understand and response to your messages in a natural way.'.tr,
        'Human-like Conversations'.tr),
    OnboardingModel(
        'assets/images/speaking.json',
        'I can write your essays, emails, code, text and more.'.tr,
        'I can do anything'.tr),
  ];
}
