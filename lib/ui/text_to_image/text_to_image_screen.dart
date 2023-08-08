import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/text_to_image_controller.dart';
import 'package:quicklai/model/image_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/ui/text_to_image/full_screen.dart';
import 'package:quicklai/widget/custom_alert_dialog.dart';

class TextToImageScreen extends StatelessWidget {
  const TextToImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<TextToImageController>(
        init: TextToImageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('Quickl Image'.tr), actions: [
              InkWell(
                onTap: () {
                  showDialog(
                    barrierColor: Colors.black26,
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: "Watch Video to increase your limit",
                        onPressNegative: () {
                          Get.back();
                        },
                        onPressPositive: () {
                          Get.back();
                          if (controller.rewardedAd == null) {
                            print(
                                'Warning: attempt to show rewarded before loaded.');
                            return;
                          }
                          controller.rewardedAd!.fullScreenContentCallback =
                              FullScreenContentCallback(
                            onAdShowedFullScreenContent: (RewardedAd ad) =>
                                print('ad onAdShowedFullScreenContent.'),
                            onAdDismissedFullScreenContent: (RewardedAd ad) {
                              print('$ad onAdDismissedFullScreenContent.');
                              ad.dispose();
                              controller.increaseLimit();
                              controller.loadRewardAd();
                            },
                            onAdFailedToShowFullScreenContent:
                                (RewardedAd ad, AdError error) {
                              print(
                                  '$ad onAdFailedToShowFullScreenContent: $error');
                              ad.dispose();
                              controller.loadRewardAd();
                            },
                          );

                          controller.rewardedAd!.setImmersiveMode(true);
                          controller.rewardedAd!.show(onUserEarnedReward:
                              (AdWithoutView ad, RewardItem reward) {
                            print(
                                '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
                          });
                          controller.rewardedAd = null;
                        },
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: Column(
                    children: [
                      Icon(
                        Icons.slow_motion_video_outlined,
                        color: ConstantColors.primary,
                      ),
                      const Text("Reward ads")
                    ],
                  ),
                ),
              )
            ]),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.bannerAdIsLoaded.value &&
                        Constant().isAdsShow() &&
                        controller.bannerAd != null,
                    child: Center(
                      child: SizedBox(
                          height: controller.bannerAd!.size.height.toDouble(),
                          width: controller.bannerAd!.size.width.toDouble(),
                          child: AdWidget(ad: controller.bannerAd!)),
                    ),
                  ),
                  Text(
                    'Enter Prompt'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: TextField(
                      controller: controller.textController.value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ex.Travel ....'.tr,
                        hintStyle:
                            TextStyle(color: ConstantColors.hintTextColor),
                        suffixIcon: InkWell(
                          onTap: (() async {
                            FocusScope.of(context).unfocus();
                            if (controller.selectedImageOption.isEmpty) {
                              ShowToastDialog.showToast(
                                  'Please select Size'.tr);
                            } else {
                              if (controller.imageLimit.value == "0" &&
                                  Constant.isActiveSubscription == false) {
                                ShowToastDialog.showToast(
                                    "Your free limit is over.Please subscribe to package to get unlimited limit."
                                        .tr);
                                Get.to(const SubscriptionScreen());
                              } else {
                                if (Constant().isAdsShow() &&
                                    controller.interstitialAd != null) {
                                  controller.interstitialAd!
                                          .fullScreenContentCallback =
                                      FullScreenContentCallback(
                                    onAdShowedFullScreenContent:
                                        (InterstitialAd ad) => print(
                                            'ad onAdShowedFullScreenContent.'),
                                    onAdDismissedFullScreenContent:
                                        (InterstitialAd ad) {
                                      print(
                                          '$ad onAdDismissedFullScreenContent.');
                                      ad.dispose();
                                      controller.loadAd();
                                      controller.sendImageResponse(
                                          controller.textController.value.text);
                                    },
                                    onAdFailedToShowFullScreenContent:
                                        (InterstitialAd ad, AdError error) {
                                      print(
                                          '$ad onAdFailedToShowFullScreenContent: $error');
                                      ad.dispose();
                                      controller.sendImageResponse(
                                          controller.textController.value.text);
                                    },
                                  );
                                  controller.interstitialAd!.show();
                                  controller.interstitialAd = null;
                                } else {
                                  controller.sendImageResponse(
                                      controller.textController.value.text);
                                }
                              }
                            }
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ConstantColors.primary),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: ConstantColors.cardViewColor,
                        contentPadding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors.cardViewColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors.cardViewColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedImageOption.value = "256x256";
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.selectedImageOption.value ==
                                        "256x256"
                                    ? ConstantColors.primary
                                    : ConstantColors.cardViewColor,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: Text(
                                "256x256".tr,
                                style: TextStyle(
                                    color:
                                        controller.selectedImageOption.value ==
                                                "256x256"
                                            ? Colors.white
                                            : ConstantColors.hintTextColor),
                              )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedImageOption.value = "512x512";
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.selectedImageOption.value ==
                                        "512x512"
                                    ? ConstantColors.primary
                                    : ConstantColors.cardViewColor,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: Text(
                                "512x512".tr,
                                style: TextStyle(
                                    color:
                                        controller.selectedImageOption.value ==
                                                "512x512"
                                            ? Colors.white
                                            : ConstantColors.hintTextColor),
                              )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedImageOption.value = "1024x024";
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.selectedImageOption.value ==
                                        "1024x024"
                                    ? ConstantColors.primary
                                    : ConstantColors.cardViewColor,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: Text(
                                "1024x024".tr,
                                style: TextStyle(
                                    color:
                                        controller.selectedImageOption.value ==
                                                "1024x024"
                                            ? Colors.white
                                            : ConstantColors.hintTextColor),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:
                        Constant.isActiveSubscription == true ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "${'You have'.tr} ${controller.imageLimit} ${'free images left.'.tr}",
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset('assets/icons/ic_subscription_icon.png',
                              width: 18),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(const SubscriptionScreen());
                              },
                              child: Text("Subscribe Now".tr,
                                  style:
                                      TextStyle(color: ConstantColors.orange))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GridView.builder(
                        itemCount: controller.imageList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (MediaQuery.of(context).size.width *
                              0.99 /
                              MediaQuery.of(context).size.width *
                              0.99),
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          ImageData data = controller.imageList[index];
                          return InkWell(
                            onTap: () {
                              Get.to(ImageView(
                                index: index,
                                imageList: controller.imageList,
                              ));
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: data.url.toString(),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
