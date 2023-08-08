import 'package:quicklai/lang/app_ar.dart';
import 'package:quicklai/lang/app_de.dart';
import 'package:quicklai/lang/app_en.dart';
import 'package:quicklai/lang/app_fr.dart';
import 'package:quicklai/lang/app_hi.dart';
import 'package:quicklai/lang/app_ja.dart';
import 'package:quicklai/lang/app_pt.dart';
import 'package:quicklai/lang/app_ru.dart';
import 'package:quicklai/lang/app_zh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static final locales = [
    const Locale('en'),
    const Locale('fr'),
    const Locale('zh'),
    const Locale('ja'),
    const Locale('hi'),
    const Locale('de'),
    const Locale('pt'),
    const Locale('ru'),
    const Locale('ar'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS,
        'fr': trFR,
        'zh': zhCH,
        'ja': jaJP,
        'hi': hiIN,
        'de': deGR,
        'pt': ptPO,
        'ru': ruRU,
        'ar': arSA,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    Get.updateLocale(Locale(lang));
  }
}
