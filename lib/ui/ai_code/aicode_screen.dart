import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/aicode_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:selectable/selectable.dart';

class AiCodeScreen extends StatelessWidget {
  const AiCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AiCodeController>(
        init: AiCodeController(),
        dispose: (state) {
          state.controller?.bannerAd!.dispose();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('AI Code'.tr), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible:
                          Constant().isAdsShow() && controller.bannerAd != null,
                      child: Center(
                        child: SizedBox(
                            height: controller.bannerAd!.size.height.toDouble(),
                            width: controller.bannerAd!.size.width.toDouble(),
                            child: AdWidget(ad: controller.bannerAd!)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Generate a code on'.tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.textController.value,
                      minLines: 3,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          controller.isSelected.value = true;
                        } else {
                          controller.isSelected.value = false;
                        }
                      },
                      onSubmitted: (value) {
                        controller.selectedSuggestion.value = value;
                      },
                      decoration: InputDecoration(
                        hintMaxLines: 3,
                        hintText:
                            'Enter the details about code you want generate here'
                                .tr,
                        hintStyle: TextStyle(
                            color: ConstantColors.hintTextColor, fontSize: 16),
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
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () async {
                        controller.question.value = '';
                        controller.answer.value = '';
                        FocusScope.of(context).unfocus();
                        log(controller.textController.value.text);
                        log(controller.stringList.join().replaceAll('#', ''));
                        if (controller.textController.value.text.isNotEmpty) {
                          if (controller.writerLimit.value == "0" &&
                              Constant.isActiveSubscription == false) {
                            ShowToastDialog.showToast(
                                'Your free limit is over.Please subscribe to package to get unlimited limit'
                                    .tr);
                            Get.to(const SubscriptionScreen());
                          } else {
                            controller.getArgument({
                              "pramot": controller.textController.value.text,
                              "category": controller.categoryData.value,
                            });
                          }
                        } else if (controller.stringList.isNotEmpty) {
                          if (controller.writerLimit.value == "0" &&
                              Constant.isActiveSubscription == false) {
                            ShowToastDialog.showToast(
                                'Your free limit is over.Please subscribe to package to get unlimited limit'
                                    .tr);
                            Get.to(const SubscriptionScreen());
                          } else {
                            controller.getArgument({
                              "pramot": controller.stringList
                                  .join()
                                  .replaceAll('#', ''),
                              "category": controller.categoryData.value,
                            });
                          }
                        } else {
                          ShowToastDialog.showToast(
                              'Please enter or select value'.tr);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: controller.isSelected.value == false
                                ? ConstantColors.cardViewColor
                                : ConstantColors.primary,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'GENERATE'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 20)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: controller.answer.isNotEmpty,
                        child: chatBubble(context, controller)),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Visibility(
              visible: Constant.isActiveSubscription == true ? false : true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${'You have'.tr} ${controller.writerLimit} ${'free messages left.'.tr}",
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
                        child: Text('Subscribe Now'.tr,
                            style: TextStyle(color: ConstantColors.orange))),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Widget textEditor(String selectedData, WriterDetailsController controller) {
  //   List<String> newArray = selectedData.split('~');
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Wrap(
  //             spacing: 5,
  //             runSpacing: 5,
  //             crossAxisAlignment: WrapCrossAlignment.center,
  //             children: List.generate(newArray.length, (index) {
  //               return newArray[index].startsWith('#')
  //                   ? IntrinsicWidth(
  //                       child: TextField(
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: null,
  //                       style:
  //                           const TextStyle(color: Colors.white, fontSize: 20),
  //                       onChanged: (value) {
  //                         controller.stringList.removeAt(index);
  //                         controller.stringList.insert(index, value);
  //                       },
  //                       decoration: InputDecoration(
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 5, vertical: 5),
  //                         hintStyle: TextStyle(
  //                             color: ConstantColors.subTitleTextColor),
  //                         hintText: newArray[index].replaceAll("#", ''),
  //                         fillColor: ConstantColors.cardViewColor,
  //                         filled: true,
  //                         enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             borderSide:
  //                                 const BorderSide(color: Colors.transparent)),
  //                         focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             borderSide:
  //                                 const BorderSide(color: Colors.transparent)),
  //                         disabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             borderSide:
  //                                 const BorderSide(color: Colors.transparent)),
  //                         border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             borderSide:
  //                                 const BorderSide(color: Colors.transparent)),
  //                       ),
  //                     ))
  //                   : IntrinsicWidth(
  //                       child: Text(
  //                         newArray[index],
  //                         textAlign: TextAlign.start,
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 20),
  //                       ),
  //                     );
  //             })),
  //       ),
  //     ],
  //   );
  // }

  chatBubble(BuildContext context, AiCodeController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                    color: ConstantColors.primary,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Column(
                  children: [
                    DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            speed: const Duration(milliseconds: 10),
                            controller.question.value.replaceFirst('\n\n', ''),
                          ),
                        ],
                        repeatForever: false,
                        totalRepeatCount: 1,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: controller.question.value));
                          ShowToastDialog.showToast('Copy!!'.tr);
                        },
                        child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.copy, color: Colors.white))),
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: controller.answer.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 5),
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: ConstantColors.background,
              //         shape: BoxShape.circle,
              //         border: Border.all(color: Colors.white)),
              //     child: ClipOval(
              //       child: SizedBox.fromSize(
              //         size: const Size.fromRadius(15), // Image radius
              //         child: Padding(
              //           padding: const EdgeInsets.all(5.0),
              //           child: Image.asset('assets/icons/chat_gpt_icon.png'),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: ConstantColors.cardViewColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Selectable(
                        selectWordOnLongPress: true,
                        selectWordOnDoubleTap: true,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                speed: const Duration(milliseconds: 10),
                                controller.answer.value
                                    .replaceFirst('\n\n', ''),
                              ),
                            ],
                            repeatForever: false,
                            totalRepeatCount: 1,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: controller.answer.value
                                    .replaceFirst('\n\n', '')));
                            ShowToastDialog.showToast('Copy!!'.tr);
                          },
                          child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.copy, color: Colors.white))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
