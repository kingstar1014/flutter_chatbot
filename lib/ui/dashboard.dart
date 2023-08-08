import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/controller/dashboard_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/chat_bot/chat_bot_screen.dart';
import 'package:quicklai/ui/chat_bot/select_character_screen.dart';
import 'package:quicklai/ui/home/home_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:sizer/sizer.dart';

import 'setting/setting_screen.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<DashBoardController>(
        init: DashBoardController(),
        initState: (state) {
          if (Constant.isActiveSubscription == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(context);
            });
          }
        },
        builder: (controller) {
          return Scaffold(
              backgroundColor: ConstantColors.background,
              body: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.index.value == 0
                      ? HomeScreen()
                      : controller.index.value == 2
                          ? const ChatBotScreen(
                              isFromHome: true,
                            )
                          : SettingScreen(),
              bottomNavigationBar: ConvexAppBar(
                initialActiveIndex: controller.index.value,
                backgroundColor: ConstantColors.cardViewColor,
                activeColor: ConstantColors.primary,
                color: Colors.white,
                height: 55,
                curveSize: 90,
                onTabNotify: (index) {
                  if (index == 1) {
                    Get.to(const SelectCharacterScreen(),
                        transition: Transition.downToUp);
                    // Get.to(const ChatBotScreen());
                    return false;
                  }
                  return true;
                },
                items: [
                  TabItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(18),
                        child: SvgPicture.asset('assets/icons/ic_home.svg',
                            semanticsLabel: 'Acme Logo'.tr),
                      ),
                      icon: SvgPicture.asset('assets/icons/ic_home.svg',
                          semanticsLabel: 'Acme Logo'.tr),
                      title: 'AI Writer'),
                  TabItem(
                      activeIcon: Padding(
                        padding: EdgeInsets.all(18.w),
                        child: SvgPicture.asset('assets/icons/ic_chat.svg',
                            semanticsLabel: 'Acme Logo'.tr),
                      ),
                      icon: SvgPicture.asset('assets/icons/ic_chat.svg',
                          semanticsLabel: 'Acme Logo'.tr),
                      title: 'Chat'.tr),
                  TabItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(18),
                        child: SvgPicture.asset('assets/icons/ic_chat.svg',
                            semanticsLabel: 'Acme Logo'.tr),
                      ),
                      icon: SvgPicture.asset('assets/icons/ic_chat.svg',
                          semanticsLabel: 'Acme Logo'.tr),
                      title: 'AI Chat'),
                  TabItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.all(18),
                        child: SvgPicture.asset('assets/icons/ic_setting.svg',
                            semanticsLabel: 'Acme Logo'.tr),
                      ),
                      icon: SvgPicture.asset('assets/icons/ic_setting.svg',
                          semanticsLabel: 'Acme Logo'.tr),
                      title: 'Settings'.tr),
                ],
                onTap: (index) {
                  controller.index.value = index;
                },
              ));
        },
      );
    });
  }

  showDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const FractionallySizedBox(
              heightFactor: 0.99, child: SubscriptionScreen());
        });
  }
}
