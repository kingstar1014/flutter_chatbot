import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/forgot_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ForgotController>(
        init: ForgotController(),
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
                        Text('Forgot Password'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(
                          height: 50,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Email Id'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: TextFieldThem.boxBuildTextField(
                              hintText: 'Email Id'.tr,
                              controller: controller.emailController.value,
                              validators: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return '*required'.tr;
                                }
                              },
                            )),
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
                                Map<String, String> bodyParams = {
                                  'email':
                                      controller.emailController.value.text,
                                };
                                await controller
                                    .forgotPassword(bodyParams)
                                    .then((value) {
                                  if (value == true) {
                                    Get.back();
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
                              child: Text('Forgot Password'.tr,
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
