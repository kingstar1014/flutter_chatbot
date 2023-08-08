import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/reset_password_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/utils/Preferences.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ResetPasswordController>(
        init: ResetPasswordController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar:
                AppBar(title: Text('Change Password'.tr), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: controller.formKey.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Password'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: TextFieldThem.boxBuildTextField(
                          hintText: 'New Password'.tr,
                          controller: controller.passwordController.value,
                          obscureText: false,
                          validators: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return '*required'.tr;
                            }
                          },
                        )),
                    Text(
                      'Confirm new password'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: TextFieldThem.boxBuildTextField(
                          hintText: 'Confirm new password'.tr,
                          controller:
                              controller.conformPasswordController.value,
                          obscureText: false,
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
                          if (controller.formKey.value.currentState!
                              .validate()) {
                            if (controller.passwordController.value.text ==
                                controller
                                    .conformPasswordController.value.text) {
                              Map<String, String> bodyParams = {
                                'user_id':
                                    Preferences.getString(Preferences.userId),
                                'password':
                                    controller.passwordController.value.text,
                              };
                              await controller
                                  .resetPassword(bodyParams)
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    Get.back(result: true);
                                  } else {
                                    ShowToastDialog.showToast(
                                        'Something want wrong...'.tr);
                                  }
                                }
                              });
                            } else {
                              ShowToastDialog.showToast(
                                  "Password doesn't match".tr);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: ConstantColors.primary,
                            shape: const StadiumBorder()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          child: Text('Login'.tr,
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
