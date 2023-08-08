import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quicklai/controller/on_boarding_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/auth/login_screen.dart';
import 'package:quicklai/utils/Preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.selectedPageIndex,
                        itemCount: controller.onBoardingList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                controller.onBoardingList[index].heading
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                controller.onBoardingList[index].title
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, letterSpacing: 1),
                              ),
                              Expanded(
                                child: Center(
                                  child: Lottie.asset(
                                    controller.onBoardingList[index].imageAsset
                                        .toString(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onBoardingList.length,
                    (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: controller.selectedPageIndex.value == index
                            ? 28
                            : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.selectedPageIndex.value == index
                              ? ConstantColors.orange
                              : const Color(0xffD4D5E0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Preferences.setBoolean(
                          Preferences.isFinishOnBoardingKey, true);
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
                          horizontal: 20.0, vertical: 12),
                      child: Text('Skip'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
