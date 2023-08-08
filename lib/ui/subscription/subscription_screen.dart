import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/subscription_controller.dart';
import 'package:quicklai/model/customer_subscription_model.dart';
import 'package:quicklai/model/subscription_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/auth/login_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<SubscriptionController>(
          init: SubscriptionController(),
          builder: (controller) {
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/icons/ic_close.svg',
                                    width: 5.w, semanticsLabel: 'Acme Logo'),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Lottie.asset(
                            width: 60.w,
                            height: 40.h,
                            'assets/images/writing.json',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose your plan!'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: controller.subscriptionList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  SubscriptionData subscriptionData =
                                      controller.subscriptionList[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        controller.selectedSubscription.value =
                                            subscriptionData;
                                      },
                                      child: Obx(
                                        () => Container(
                                          decoration: controller
                                                      .selectedSubscription
                                                      .value ==
                                                  subscriptionData
                                              ? const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/subscrption_item.png'),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)))
                                              : BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    subscriptionData.discount !=
                                                                null &&
                                                            subscriptionData
                                                                    .discount !=
                                                                "0"
                                                        ? 10
                                                        : 22,
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        subscriptionData.name
                                                            .toString()
                                                            .tr,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Text(
                                                      "\$${subscriptionData.price.toString()}",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: subscriptionData
                                                              .discount !=
                                                          null &&
                                                      subscriptionData
                                                              .discount !=
                                                          "0",
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 3),
                                                          child: Text(
                                                            "${'Save'.tr} ${subscriptionData.discount}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_right.svg',
                              width: 2.w,
                              height: 2.h,
                              semanticsLabel: 'Acme Logo',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${'High Word Limit'.tr} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                        text: 'for Questions & Answers'.tr,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/ic_right.svg',
                                width: 2.w,
                                height: 2.h,
                                semanticsLabel: 'Acme Logo'.tr),
                            const SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${'Unlimited'.tr} ',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                  TextSpan(
                                      text: 'Questions & Answers'.tr,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/ic_right.svg',
                                width: 2.w,
                                height: 2.h,
                                semanticsLabel: 'Acme Logo'.tr),
                            const SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${'Ads Free'.tr} ',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                  TextSpan(
                                      text: 'experience'.tr,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            if (Preferences.getBoolean(Preferences.isLogin)) {
                              await initPlatformState(controller,
                                  controller.selectedSubscription.value);
                            } else {
                              Get.off(const LoginScreen(
                                redirectType: "subscription",
                              ));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: ConstantColors.primary,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "Continue".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse(
                                    Constant.privacyPolicy.toString());
                                if (!await launchUrl(uri)) {
                                  throw Exception('Could not launch $uri');
                                }
                              },
                              child: Text("Privacy policy".tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse(
                                    Constant.termsAndCondition.toString());
                                if (!await launchUrl(uri)) {
                                  throw Exception('Could not launch $uri');
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  child: Text("Terms & Conditions".tr,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${'Subscription will be charged to your payment method through your'.tr} ${Platform.isAndroid ? "Google play Belling account".tr : "iTunes Billing account".tr}. ${'your subscription will automatically renew unless canceled at least 24 hours before the end of current period.Mange your subscription in account setting after purchase'.tr}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Future<void> initPlatformState(SubscriptionController controller,
      SubscriptionData subscriptionData) async {
    try {
      if (Platform.isAndroid) {
        await Purchases.purchaseProduct(
                subscriptionData.androidSubscriptionKey.toString())
            .then((value) async {
          log("-------->");
          log(value.toJson().toString());
          CustomerInfo customerInfo = value;
          CustomerSubscriptionModel customerSubscriptionModel =
              CustomerSubscriptionModel.fromJson(customerInfo.toJson());
          Constant.isActiveSubscription = customerSubscriptionModel
              .entitlements!.active!
              .toJson()
              .isNotEmpty;

          if (Constant.isActiveSubscription == true) {
            Map<String, String> bodyParams = {
              'user_id': Preferences.getString(Preferences.userId),
              'subscription_id': subscriptionData.id.toString(),
              'transaction_details':
                  jsonEncode(customerSubscriptionModel.toJson()),
            };
            await controller.sendSubscriptionData(bodyParams);
          }
        });
      } else if (Platform.isIOS) {
        await Purchases.purchaseProduct(
                subscriptionData.iosSubscriptionKey.toString())
            .then((value) async {
          log("-------->");
          log(value.toJson().toString());
          CustomerInfo customerInfo = value;
          CustomerSubscriptionModel customerSubscriptionModel =
              CustomerSubscriptionModel.fromJson(customerInfo.toJson());
          Constant.isActiveSubscription = customerSubscriptionModel
              .entitlements!.active!
              .toJson()
              .isNotEmpty;

          if (Constant.isActiveSubscription == true) {
            Map<String, String> bodyParams = {
              'user_id': Preferences.getString(Preferences.userId),
              'subscription_id': subscriptionData.id.toString(),
              'transaction_details':
                  jsonEncode(customerSubscriptionModel.toJson()),
            };
            await controller.sendSubscriptionData(bodyParams);
          }
        });
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast(e.message.toString().tr);
      // Error fetching customer info
    }
  }
}
