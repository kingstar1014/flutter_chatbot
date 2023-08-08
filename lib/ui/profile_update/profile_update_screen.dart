import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/profile_updation_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/utils/Preferences.dart';

class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileUpdationController>(
        init: ProfileUpdationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('Profile'.tr), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: controller.formKey.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full name'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: TextFieldThem.boxBuildTextField(
                          hintText: 'Full name'.tr,
                          controller: controller.nameController.value,
                          validators: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return '*required'.tr;
                            }
                          },
                        )),
                    Text(
                      'Email Id'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: TextFieldThem.boxBuildTextField(
                          hintText: 'Email Id'.tr,
                          controller: controller.emailController.value,
                          enabled: false,
                          validators: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return '*required'.tr;
                            }
                          },
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (controller.formKey.value.currentState!
                              .validate()) {
                            Map<String, String> bodyParams = {
                              'name': controller.nameController.value.text,
                              'email': controller.emailController.value.text,
                              'user_id':
                                  Preferences.getString(Preferences.userId),
                            };
                            await controller
                                .updateProfile(bodyParams)
                                .then((value) {
                              if (value != null) {
                                if (value == true) {
                                  controller.userModel.value.data!.name =
                                      controller.nameController.value.text;
                                  Preferences.setString(
                                      Preferences.user,
                                      jsonEncode(
                                          controller.userModel.value.toJson()));
                                  Get.back();
                                } else {
                                  ShowToastDialog.showToast(
                                      "Something want wrong...".tr);
                                }
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: ConstantColors.primary,
                            shape: const StadiumBorder()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          child: Text('Update Profile'.tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
