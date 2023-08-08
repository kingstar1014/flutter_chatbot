import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/otp_controller.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/dashboard.dart';
import 'package:quicklai/utils/Preferences.dart';

class OTPScreen extends StatelessWidget {
  final Map<String, String> bodyParams;

  const OTPScreen({Key? key, required this.bodyParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 15, top: 40),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Form(
                    key: controller.formKey.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('OTP Verification'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600)),
                        Text('You get OTP from your email.'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 50,
                        ),
                        OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 50,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          onChanged: (value) {
                            controller.otp.value = value;
                          },
                          otpFieldStyle: OtpFieldStyle(
                              borderColor: Colors.white,
                              disabledBorderColor: Colors.white,
                              enabledBorderColor: Colors.white,
                              focusBorderColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (controller.formKey.value.currentState!
                                  .validate()) {
                                Map<String, String> finalBodyParams =
                                    bodyParams;
                                finalBodyParams
                                    .addAll({'otp': controller.otp.value});
                                await controller
                                    .signUpAPI(finalBodyParams)
                                    .then((value) {
                                  if (value != null) {
                                    if (value.success == "Success") {
                                      ApiServices.header['accesstoken'] =
                                          value.data!.accesstoken.toString();
                                      Preferences.setBoolean(
                                          Preferences.isFinishOnBoardingKey,
                                          true);
                                      Preferences.setString(
                                          Preferences.user, jsonEncode(value));
                                      Preferences.setString(
                                          Preferences.accessToken,
                                          value.data!.accesstoken.toString());
                                      Preferences.setString(
                                          Preferences.customerId,
                                          value.data!.customerId.toString());
                                      Preferences.setString(Preferences.userId,
                                          value.data!.id.toString());
                                      Preferences.setBoolean(
                                          Preferences.isLogin, true);

                                      Get.offAll(const DashBoard());
                                    } else {
                                      ShowToastDialog.showToast(value.error);
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
                              child: Text('Register now'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
