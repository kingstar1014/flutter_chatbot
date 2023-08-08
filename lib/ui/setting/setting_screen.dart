import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/setting_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/responsive.dart';
import 'package:quicklai/ui/auth/login_screen.dart';
import 'package:quicklai/ui/language/language_screen.dart';
import 'package:quicklai/ui/profile_update/profile_update_screen.dart';
import 'package:quicklai/ui/reset_password/reset_password_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SettingController>(
        init: SettingController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(
              title: Text('QuicklAI'.tr),
              centerTitle: true,
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Center(
              //         child: Text(
              //       "V ${Constant.appVersion.toString()}",
              //       style: const TextStyle(fontWeight: FontWeight.w600),
              //     )),
              //   )
              // ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: controller.profileImage.isEmpty
                                ? Icon(
                                    CupertinoIcons.person,
                                    size: 120,
                                    color: ConstantColors.subTitleTextColor,
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        controller.profileImage.toString(),
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                        ),
                        Preferences.getBoolean(Preferences.isLogin)
                            ? InkWell(
                                onTap: () =>
                                    buildBottomSheet(context, controller),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 80),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                            'assets/icons/ic_camera.svg',
                                            height: 22,
                                            semanticsLabel: 'Acme Logo'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Preferences.getBoolean(Preferences.isLogin)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  controller.userModel.value.data!.name
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              Text(
                                  controller.userModel.value.data!.email
                                      .toString(),
                                  style: TextStyle(
                                      color: ConstantColors.hintTextColor,
                                      fontSize: 16)),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              Get.off(const LoginScreen(
                                redirectType: "",
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: ConstantColors.primary,
                                shape: const StadiumBorder()),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10),
                              child: Text('Login'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: Preferences.getBoolean(Preferences.isLogin),
                      child: InkWell(
                        onTap: () async {
                          await Get.to(const ProfileUpdateScreen());
                          controller.getUser();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: ConstantColors.cardViewColor,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: ConstantColors.background,
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                        height: 20,
                                        width: 20,
                                        'assets/icons/ic_user.svg',
                                        semanticsLabel: 'Acme Logo'.tr),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Profile'.tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const SubscriptionScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_subscription.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Manage Subscriptions'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    InkWell(
                      onTap: () async {
                        final uri =
                            Uri.parse(Constant.termsAndCondition.toString());
                        if (!await launchUrl(uri)) {
                          throw Exception('Could not launch $uri');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_privacy_policy.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Terms & Conditions".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     final uri = Uri.parse(Constant.faqLink.toString());
                    //     if (!await launchUrl(uri)) {
                    //       throw Exception('Could not launch $uri');
                    //     }
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: ConstantColors.cardViewColor,
                    //         shape: BoxShape.rectangle,
                    //         borderRadius:
                    //             const BorderRadius.all(Radius.circular(10))),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 10, horizontal: 10),
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             decoration: BoxDecoration(
                    //                 color: ConstantColors.background,
                    //                 shape: BoxShape.rectangle,
                    //                 borderRadius: const BorderRadius.all(
                    //                     Radius.circular(10))),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(10.0),
                    //               child: SvgPicture.asset(
                    //                   height: 20,
                    //                   width: 20,
                    //                   'assets/icons/ic_faq.svg',
                    //                   semanticsLabel: 'Acme Logo'.tr),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(
                    //             "FAQs".tr,
                    //             style: const TextStyle(color: Colors.white),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    InkWell(
                      onTap: () async {
                        final Uri params = Uri(
                          scheme: 'mailto',
                          path: Constant.supportEmail,
                          query: 'subject=&body=', //add subject and body here
                        );

                        if (await launchUrl(params)) {
                          await launchUrl(params);
                        } else {
                          throw 'Could not launch $params';
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_support.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Customer Support'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Preferences.getBoolean(Preferences.isLogin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const ResetPasswordScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ConstantColors.cardViewColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ConstantColors.background,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(Icons.password_sharp,
                                            size: 20, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Forgot Password'.tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        LaunchReview.launch(
                          androidAppId: "com.app.quicklai",
                          iOSAppId: "com.app.quicklai",
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_rate.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Rate App'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        share();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_share.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Share With Friends".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        final uri =
                            Uri.parse(Constant.privacyPolicy.toString());
                        if (!await launchUrl(uri)) {
                          throw Exception('Could not launch $uri');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_privacy_policy.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Privacy Policy'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.to(const LanguageScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Change language'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Preferences.getBoolean(Preferences.isLogin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              deleteDialog(context, controller);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ConstantColors.cardViewColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ConstantColors.background,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Delete Account".tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        Preferences.clearSharPreference();
                        Purchases.logOut();
                        await FirebaseAuth.instance.signOut();

                        Get.off(const LoginScreen(
                          redirectType: "",
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.cardViewColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ConstantColors.background,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                      height: 20,
                                      width: 20,
                                      'assets/icons/ic_logout.svg',
                                      semanticsLabel: 'Acme Logo'.tr),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                Preferences.getBoolean(Preferences.isLogin)
                                    ? 'Logout'.tr
                                    : 'Login'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  buildBottomSheet(BuildContext context, SettingController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Responsive.height(22, context),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Please Select'.tr,
                      style: TextStyle(
                        color: const Color(0XFF333333).withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile1(controller,
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text('Camera'.tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile1(controller,
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  deleteDialog(BuildContext context, SettingController controller) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'.tr),
            content: Text('Do you really want to delete?'.tr),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    //action code for "Yes" button
                    Map<String, String> bodyParams = {
                      'user_id': Preferences.getString(Preferences.userId)
                    };
                    controller.deleteAccount(bodyParams).then((value) {
                      if (value == true) {
                        Preferences.clearSharPreference();
                        Get.off(const LoginScreen(
                          redirectType: "",
                        ));
                      }
                    });
                  },
                  child: Text('Yes'.tr)),
              TextButton(
                onPressed: () {
                  Get.back(); //close Dialog
                },
                child: Text('Close'.tr),
              )
            ],
          );
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile1(SettingController controller,
      {required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      controller.uploadPhoto(File(image.path)).then((value) async {
        if (value != null) {
          if (value["success"] == "Success") {
            controller.userModel.value.data!.photo = value['data']['photo'];
            Preferences.setString(Preferences.user,
                jsonEncode(controller.userModel.value.toJson()));
            ShowToastDialog.showToast("Upload successfully!");
            controller.profileImage.value = value['data']['photo'];
          } else {
            ShowToastDialog.showToast(value['error']);
          }
        }
      });
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'QuicklAi'.tr,
        text:
            'This is an AI chat app by the developer OpenAI.Get the instant and smart answers with AI chat! AI Assistant: Essay / Email writer / Paragraph / Advertiser / Answer interview / Images etc..',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.app.quicklai',
        chooserTitle: 'QuicklAi'.tr);
  }
}
