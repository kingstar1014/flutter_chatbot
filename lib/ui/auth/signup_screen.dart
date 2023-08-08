import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/signup_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/ui/auth/otp_screen.dart';

class SignupScreen extends StatelessWidget {
  final String? redirectType;
  final String token;

  const SignupScreen(
      {Key? key, required this.token, required this.redirectType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: ConstantColors.background,
            body: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Form(
                    key: controller.formKey.value,
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),
                          const Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          Text('Create to you new account.'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(height: 50),
                          Text(
                            'Full Name'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: TextFieldThem.boxBuildTextField(
                                hintText: 'Full Name'.tr,
                                controller: controller.fullNameController.value,
                                validators: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return '*required'.tr;
                                  }
                                },
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Email Id'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: TextFieldThem.boxBuildTextField(
                                hintText: 'Email Id'.tr,
                                controller: controller.emailController.value,
                                validators: (p0) =>
                                    Constant().validateEmail(p0),
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'password'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: TextFieldThem.boxBuildTextField(
                                suffixData: IconButton(
                                  onPressed: () {
                                    controller.passwordVisible.value =
                                        !controller.passwordVisible.value;
                                    // ignore: invalid_use_of_protected_member
                                    controller.refresh();
                                  },
                                  icon: Icon(
                                    controller.passwordVisible.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                hintText: 'password'.tr,
                                obscureText: controller.passwordVisible.value,
                                controller: controller.passwordController.value,
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
                                      .sendOtp(bodyParams)
                                      .then((value) {
                                    if (value != null) {
                                      if (value == true) {
                                        Map<String, String> redirectBodyParams =
                                            {
                                          'name': controller
                                              .fullNameController.value.text,
                                          'email': controller
                                              .emailController.value.text,
                                          'password': controller
                                              .passwordController.value.text,
                                          'fcmtoken': token
                                        };
                                        Get.to(OTPScreen(
                                          bodyParams: redirectBodyParams,
                                        ));
                                      } else {
                                        ShowToastDialog.showToast(
                                            "Something want wrong".tr);
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
                                child: Text(
                                  'Register now'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 15, top: 40),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
