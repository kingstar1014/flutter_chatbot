// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/chat_bot_controller.dart';
import 'package:quicklai/controller/setting_controller.dart';
import 'package:quicklai/model/chat.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/widget/custom_alert_dialog.dart';
import 'package:selectable/selectable.dart';

class ChatBotScreen extends StatelessWidget {
  final bool isFromHome;

  const ChatBotScreen({
    Key? key,
    this.isFromHome = false,
  }) : super(key: key);
  



  @override
  Widget build(BuildContext context) {
    return GetX<ChatBotController>(
      init: ChatBotController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(title: Text('Future AI'.tr), actions: [
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
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Column(
                    children: [
                      Visibility(
                        visible: controller.bannerAdIsLoaded.value &&
                            Constant().isAdsShow() &&
                            controller.bannerAd != null,
                        child: Center(
                          child: SizedBox(
                              height:
                                  controller.bannerAd!.size.height.toDouble(),
                              width: controller.bannerAd!.size.width.toDouble(),
                              child: AdWidget(ad: controller.bannerAd!)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListView.builder(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: controller.chatList.length,
                            itemBuilder: (context, index) {
                              Chat chatItem = controller.chatList[index];
                              return chatBubble(context, chatItem, controller);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          controller: controller.messageController.value,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.isClickable.value = true;
                            } else {
                              controller.isClickable.value = false;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your message...'.tr,
                            hintStyle:
                                TextStyle(color: ConstantColors.hintTextColor),
                            suffixIcon: InkWell(
                              onTap: (() async {
                                FocusScope.of(context).unfocus();

                                if (controller.chatLimit.value == "0" &&
                                    Constant.isActiveSubscription == false) {
                                  ShowToastDialog.showToast(
                                      "Your free limit is over.Please subscribe to package to get unlimited limit"
                                          .tr);
                                  Get.to(const SubscriptionScreen());
                                } else if (controller.subsChatLimit.value !=
                                        "0" &&
                                    Constant.isActiveSubscription == true) {
                                  if (controller.messageController.value.text
                                      .isNotEmpty) {
                                    Chat chat = Chat(
                                        msg: controller
                                            .messageController.value.text,
                                        chat: "0");
                                    controller.chatList.add(chat);

                                    controller.sendResponse(controller
                                        .messageController.value.text);
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter message".tr);
                                  }
                                } else {
                                  if (controller.messageController.value.text
                                      .isNotEmpty) {
                                    Chat chat = Chat(
                                        msg: controller
                                            .messageController.value.text,
                                        chat: "0");
                                    controller.chatList.add(chat);

                                    controller.sendResponse(controller
                                        .messageController.value.text);
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter message".tr);
                                  }
                                }
                              }),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          controller.isClickable.value == false
                                              ? ConstantColors.cardViewColor
                                              : ConstantColors.primary),
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
                              borderSide: BorderSide(
                                  color: ConstantColors.cardViewColor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ConstantColors.cardViewColor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          bottomNavigationBar: Visibility(
            visible: Constant.isActiveSubscription == true ? false : true,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: isFromHome ? 40 : 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '${'You have'.tr} ${controller.chatLimit} ${'free messages left'.tr}',
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
                    child: Text(
                      'Subscribe Now'.tr,
                      style: TextStyle(color: ConstantColors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatBubble(
      BuildContext context, Chat chatItem, ChatBotController controller) {
    final bool isSender = chatItem.chat == "0";
    


    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: !isSender,
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              decoration: BoxDecoration(
                color: ConstantColors
                    .backgroundRemodified, // Green color for the sender's avatar
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(15),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: controller.selectedCharacter.value!.photo
                            .toString(),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: isSender
                  ? Colors.white
                  : Colors
                      .blueAccent, // Blue color for the bot's message bubble
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: isSender ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    isSender ? Radius.circular(0) : Radius.circular(10),
              ),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: isSender
                    ? Colors.black
                    : Colors.white, // White text color for the bot's message
              ),
              child: chatItem.chat == "1"
                  ? Selectable(
                      selectWordOnLongPress: true,
                      selectWordOnDoubleTap: true,
                      child: Text(chatItem.msg!.replaceFirst('\n\n', '')),
                    )
                  : Text(chatItem.msg!.replaceFirst('\n\n', '')),
            ),
          ),
        ),
        Visibility(
          visible: isSender,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.blue.shade800, // Blue color for the sender's avatar
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(15),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GetBuilder<SettingController>(
                    init: SettingController(),
                    builder: (controllerSettings) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: controllerSettings.profileImage.isEmpty
                            ? Image.asset(
                                'assets/images/profile_placeholder.png')
                            : CachedNetworkImage(
                                imageUrl:
                                    controllerSettings.profileImage.toString(),
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
