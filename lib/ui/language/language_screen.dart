import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/language_controller.dart';
import 'package:quicklai/model/language_model.dart';
import 'package:quicklai/service/localization_service.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/utils/Preferences.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LanguageController>(
        init: LanguageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('Change language'.tr), centerTitle: true),
            body: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: controller.languageList.length,
                    itemBuilder: (context, index) {
                      LanguageData languageModel = controller.languageList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            LocalizationService().changeLocale(languageModel.code.toString());
                            Preferences.setString(Preferences.lngCode, languageModel.code.toString());
                          },
                          child: Container(
                            decoration: BoxDecoration(color: ConstantColors.cardViewColor, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: languageModel.photo.toString(),
                                    height: 40,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) => Container(decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10))),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    languageModel.name.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }
}
