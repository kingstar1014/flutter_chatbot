import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/splash_screen.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:sizer/sizer.dart';

import 'service/localization_service.dart';
import 'utils/Preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Preferences.initPref();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          translations: LocalizationService(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          title: 'QuicklAI'.tr,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                color: ConstantColors.cardViewColor,
                elevation: 0,
                titleTextStyle:
                    const TextStyle(fontSize: 18, letterSpacing: 1.5)),
            primaryColor: ConstantColors.primary,
            textTheme:
                GoogleFonts.aBeeZeeTextTheme(Theme.of(context).textTheme),
            primaryTextTheme: GoogleFonts.aBeeZeeTextTheme(),
          ),
          builder: EasyLoading.init(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
