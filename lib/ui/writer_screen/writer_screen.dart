import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/writer_screen_controller.dart';
import 'package:quicklai/model/suggestion_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/history/history_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/ui/writer_screen/writer_details_screen.dart';
import 'package:quicklai/utils/Preferences.dart';

class WriterScreen extends StatelessWidget {
  const WriterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WriterScreenController>(
      init: WriterScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
            title: Text(controller.categoryData.value.name.toString()),
            centerTitle: true,
            actions: [
              Visibility(
                visible: Preferences.getBoolean(Preferences.isLogin),
                child: InkWell(
                  onTap: () {
                    Get.to(const HistoryScreen(), arguments: {
                      "categoryId": controller.categoryData.value.id.toString(),
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.history),
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: controller.selectedSuggestion.isEmpty,
                    child: TextField(
                      controller: controller.textController.value,
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
                        hintText: 'How can I help you?'.tr,
                        hintStyle: TextStyle(
                            color: ConstantColors.hintTextColor, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  textEditor(controller.selectedSuggestion.value, controller),
                  Visibility(
                    visible: controller.selectedSuggestion.isEmpty,
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: controller.suggestionList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              SuggestionData suggestion =
                                  controller.suggestionList[index];
                              List<String> newArray =
                                  suggestion.name!.split('~');
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    controller.isSelected.value = true;
                                    controller.textController.value.clear();
                                    controller.selectedSuggestion.value =
                                        suggestion.name.toString();
                                    List<String> newArray =
                                        suggestion.name!.split('~');
                                    controller.stringList.addAll(newArray);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: ConstantColors.cardViewColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                            children: List.generate(
                                                newArray.length, (index) {
                                          return newArray[index].startsWith('#')
                                              ? Text(
                                                  newArray[index]
                                                      .replaceAll('#', ""),
                                                  style: TextStyle(
                                                      color: ConstantColors
                                                          .hintTextColor,
                                                      fontSize: 16),
                                                )
                                              : Text(
                                                  newArray[index],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                );
                                        })),
                                      )),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Visibility(
            visible: Constant.isActiveSubscription == true ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
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
                            Get.off(const WriterDetailsScreen(), arguments: {
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
                            Get.off(
                              const WriterDetailsScreen(),
                              arguments: {
                                "pramot": controller.stringList
                                    .join()
                                    .replaceAll('#', ''),
                                "category": controller.categoryData.value,
                              },
                            );
                          }
                        } else {
                          ShowToastDialog.showToast(
                            'Please enter or select value'.tr,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: controller.isSelected.value == false
                                  ? ConstantColors.cardViewColor
                                  : ConstantColors.primary,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Send'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
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
                                style:
                                    TextStyle(color: ConstantColors.orange))),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textEditor(String selectedData, WriterScreenController controller) {
    List<String> newArray = selectedData.split('~');
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              newArray.length,
              (index) {
                return newArray[index].startsWith('#')
                    ? IntrinsicWidth(
                        child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        onChanged: (value) {
                          controller.stringList.removeAt(index);
                          controller.stringList.insert(index, value);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          hintStyle: TextStyle(
                              color: ConstantColors.subTitleTextColor),
                          hintText: newArray[index].replaceAll("#", ''),
                          fillColor: ConstantColors.cardViewColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                        ),
                      ))
                    : IntrinsicWidth(
                        child: Text(
                          newArray[index],
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
