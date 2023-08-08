import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/main_setting_controller.dart';
import 'package:quicklai/service/notification_service.dart';
import 'package:quicklai/ui/auth/login_screen.dart';
import 'package:quicklai/ui/dashboard.dart';
import 'package:quicklai/ui/on_boarding_screen.dart';
import 'package:quicklai/utils/Preferences.dart';

import 'service/localization_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = '';
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationService.initInfo().then((value) async {
        token = await NotificationService.getToken();
        log(":::::::TOKEN:::::: $token");
        getLanguage();
        Timer(const Duration(seconds: 3), () => redirect());
      });
    });
    super.initState();
  }

  getLanguage() async {
    if (Preferences.getString(Preferences.lngCode).toString().isNotEmpty) {
      LocalizationService()
          .changeLocale(Preferences.getString(Preferences.lngCode).toString());
    }
  }

  redirect() {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
      Get.offAll(const OnBoardingScreen());
    } else if (Preferences.getBoolean(Preferences.isLogin) == false) {
      Get.offAll(const LoginScreen(redirectType: ""));
    } else {
      Get.offAll(const DashBoard());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainSettingController>(
      init: MainSettingController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
