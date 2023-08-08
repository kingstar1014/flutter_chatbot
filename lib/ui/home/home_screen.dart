import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/controller/home_controller.dart';
import 'package:quicklai/model/banner_model.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/history/history_details_screen.dart';
import 'package:quicklai/ui/history/history_screen.dart';
import 'package:quicklai/ui/writer_screen/writer_screen.dart';
import 'package:sizer/sizer.dart';

import '../../widget/custom_alert_dialog.dart';
//

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _controller =
      PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return Scaffold(
              backgroundColor: ConstantColors.background,
              appBar: AppBar(
                backgroundColor: ConstantColors.cardViewColor,
                title: Text(
                  'Future AI',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierColor: Colors.black26,
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            title: "Watch Video to increase your limit",
                            onPressNegative: () {
                              Get.back();
                            },
                            onPressPositive: () {
                              Get.back();
                              if (controller.rewardedAd == null) {
                                debugPrint(
                                    'Warning: attempt to show rewarded before loaded.');
                                return;
                              }
                              controller.rewardedAd!.fullScreenContentCallback =
                                  FullScreenContentCallback(
                                onAdShowedFullScreenContent: (RewardedAd ad) =>
                                    debugPrint(
                                        'ad onAdShowedFullScreenContent.'),
                                onAdDismissedFullScreenContent:
                                    (RewardedAd ad) {
                                  debugPrint(
                                      '$ad onAdDismissedFullScreenContent.');
                                  ad.dispose();
                                  controller.increaseLimit();
                                  controller.loadRewardAd();
                                },
                                onAdFailedToShowFullScreenContent:
                                    (RewardedAd ad, AdError error) {
                                  debugPrint(
                                      '$ad onAdFailedToShowFullScreenContent: $error');
                                  ad.dispose();
                                  controller.loadRewardAd();
                                },
                              );

                              controller.rewardedAd!.setImmersiveMode(true);
                              controller.rewardedAd!.show(onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem reward) {
                                debugPrint(
                                    '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
                              });
                              controller.rewardedAd = null;
                            },
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.slow_motion_video_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3),
                          Text("Free Credits")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isBannerLoading.value == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Visibility(
                            visible: controller.bannerList.isNotEmpty,
                            child: SizedBox(
                              height: 24.w,
                              child: PageView.builder(
                                padEnds: false,
                                itemCount: controller.bannerList.length,
                                scrollDirection: Axis.horizontal,
                                controller: _controller,
                                itemBuilder: (context, index) {
                                  BannerData bannerModel =
                                      controller.bannerList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: CachedNetworkImage(
                                      imageUrl: bannerModel.photo.toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      color: Colors.black.withOpacity(0.5),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive()),
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    // ignore: unnecessary_null_comparison
                    // if (controller.topCategoryList.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 0.5.w, vertical: 0.5.w),
                    //     child: SizedBox(
                    //       height: 12.w,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 6),
                    //             child: GestureDetector(
                    //               onTap: () async {
                    //                 Get.to(const AiCodeScreen());
                    //               },
                    //               child: Container(
                    //                 height: 12.w,
                    //                 width: MediaQuery.of(context).size.width *
                    //                     0.45,
                    //                 decoration: BoxDecoration(
                    //                   color: ConstantColors.cardViewColor,
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(20)),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Image.asset(
                    //                         controller
                    //                                 .topCategoryList[0].icon ??
                    //                             "",
                    //                         fit: BoxFit.fill,
                    //                         width: 7.w,
                    //                         height: 7.w),
                    //                     SizedBox(width: 4.w),
                    //                     Text(
                    //                         controller.topCategoryList[0].name
                    //                                 ?.tr ??
                    //                             "",
                    //                         style: TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 10.sp)),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 6),
                    //             child: GestureDetector(
                    //               onTap: () async {
                    //                 Get.to(const AstrologyScreen());
                    //               },
                    //               child: Container(
                    //                 height: 12.w,
                    //                 width: MediaQuery.of(context).size.width *
                    //                     0.45,
                    //                 decoration: BoxDecoration(
                    //                   color: ConstantColors.cardViewColor,
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(20)),
                    //                 ),
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 26, vertical: 8),
                    //                   child: Row(
                    //                     children: [
                    //                       Image.asset(
                    //                           controller.topCategoryList[1]
                    //                                   .icon ??
                    //                               "",
                    //                           fit: BoxFit.fill,
                    //                           width: 7.w,
                    //                           height: 7.w),
                    //                       SizedBox(width: 4.w),
                    //                       Text(
                    //                           controller.topCategoryList[1].name
                    //                                   ?.tr ??
                    //                               "",
                    //                           style: TextStyle(
                    //                               color: Colors.white,
                    //                               fontSize: 10.sp)),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    SizedBox(height: 1.5.h),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         'Explore',
                    //         style: TextStyle(
                    //           fontSize: 12.sp,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           letterSpacing: 1.5,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.historyList.isEmpty
                            ? Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    // childAspectRatio: (20.h / 21.h),
                                    childAspectRatio: 1,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemCount: controller.categoryList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    CategoryData categoryData =
                                        controller.categoryList[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.5.w, vertical: 0.5.w),
                                      child: InkWell(
                                        onTap: () async {
                                          if (Constant().isAdsShow() &&
                                              controller.interstitialAd !=
                                                  null) {
                                            if (index % 2 == 0) {
                                              controller.interstitialAd!
                                                      .fullScreenContentCallback =
                                                  FullScreenContentCallback(
                                                onAdShowedFullScreenContent:
                                                    (InterstitialAd ad) =>
                                                        debugPrint(
                                                            'ad onAdShowedFullScreenContent.'),
                                                onAdDismissedFullScreenContent:
                                                    (InterstitialAd ad) {
                                                  debugPrint(
                                                      '$ad onAdDismissedFullScreenContent.');
                                                  ad.dispose();
                                                  controller.loadAd();
                                                  Get.to(const WriterScreen(),
                                                      arguments: {
                                                        "category":
                                                            categoryData,
                                                      });
                                                },
                                                onAdFailedToShowFullScreenContent:
                                                    (InterstitialAd ad,
                                                        AdError error) {
                                                  debugPrint(
                                                      '$ad onAdFailedToShowFullScreenContent: $error');
                                                  ad.dispose();
                                                  Get.to(const WriterScreen(),
                                                      arguments: {
                                                        "category":
                                                            categoryData,
                                                      });
                                                },
                                              );
                                              controller.interstitialAd!.show();
                                              controller.interstitialAd = null;
                                            } else {
                                              Get.to(
                                                const WriterScreen(),
                                                arguments: {
                                                  "category": categoryData,
                                                },
                                              );
                                            }
                                          } else {
                                            Get.to(
                                              const WriterScreen(),
                                              arguments: {
                                                "category": categoryData,
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ConstantColors.cardViewColor,
                                            border: Border.all(
                                              color:
                                                  ConstantColors.cardViewColor,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  decoration: const BoxDecoration(
                                                      // color: ConstantColors
                                                      //     .background,
                                                      // shape: BoxShape.circle,
                                                      ),
                                                  child: SizedBox.fromSize(
                                                    size: Size.fromRadius(
                                                        10.w), // Image radius
                                                    child: CachedNetworkImage(
                                                      imageUrl: categoryData
                                                          .photo
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    categoryData.name
                                                        .toString()
                                                        .tr,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    categoryData.description ??
                                                        '',
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(
                                height: 32.w,
                                child: ListView.builder(
                                  itemCount: controller.categoryList.length >= 9
                                      ? 9
                                      : controller.categoryList.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    CategoryData categoryData =
                                        controller.categoryList[index];
                                    return SizedBox(
                                      width: 32.w,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        child: InkWell(
                                          onTap: () async {
                                            if (Constant().isAdsShow()) {
                                              if (index % 2 == 0) {
                                                if (controller.interstitialAd ==
                                                    null) {
                                                  debugPrint(
                                                      'Warning: attempt to show interstitial before loaded.');
                                                  return;
                                                }
                                                controller.interstitialAd!
                                                        .fullScreenContentCallback =
                                                    FullScreenContentCallback(
                                                  onAdShowedFullScreenContent:
                                                      (InterstitialAd ad) =>
                                                          debugPrint(
                                                              'ad onAdShowedFullScreenContent.'),
                                                  onAdDismissedFullScreenContent:
                                                      (InterstitialAd ad) {
                                                    debugPrint(
                                                        '$ad onAdDismissedFullScreenContent.');
                                                    ad.dispose();
                                                    controller.loadAd();
                                                    Get.to(const WriterScreen(),
                                                        arguments: {
                                                          "category":
                                                              categoryData,
                                                        });
                                                  },
                                                  onAdFailedToShowFullScreenContent:
                                                      (InterstitialAd ad,
                                                          AdError error) {
                                                    debugPrint(
                                                        '$ad onAdFailedToShowFullScreenContent: $error');
                                                    ad.dispose();
                                                    Get.to(const WriterScreen(),
                                                        arguments: {
                                                          "category":
                                                              categoryData,
                                                        });
                                                  },
                                                );
                                                controller.interstitialAd!
                                                    .show();
                                                controller.interstitialAd =
                                                    null;
                                              } else {
                                                Get.to(const WriterScreen(),
                                                    arguments: {
                                                      "category": categoryData,
                                                    });
                                              }
                                            } else {
                                              Get.to(const WriterScreen(),
                                                  arguments: {
                                                    "category": categoryData,
                                                  });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  ConstantColors.cardViewColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: ConstantColors
                                                            .background,
                                                        shape: BoxShape.circle),
                                                    child: ClipOval(
                                                      child: SizedBox.fromSize(
                                                        size: Size.fromRadius(9
                                                            .w), // Image radius
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0.w),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  categoryData
                                                                      .photo
                                                                      .toString(),
                                                              fit: BoxFit.cover,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Center(
                                                                child: CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.w),
                                                    child: Text(
                                                      categoryData.name
                                                          .toString()
                                                          .tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    SizedBox(
                      height: 2.w,
                    ),
                    controller.isHistoryLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.historyList.isEmpty
                            ? Container()
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Recently Prompt'.tr,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(const HistoryScreen(),
                                                arguments: {
                                                  "categoryId": "0",
                                                });
                                          },
                                          child: Text(
                                            'View All'.tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () =>
                                            controller.getHistoryProms(),
                                        child: ListView.builder(
                                          itemCount: controller
                                                      .historyList.length >=
                                                  10
                                              ? 10
                                              : controller.historyList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            HistoryData historyData =
                                                controller.historyList[index];
                                            return InkWell(
                                              onTap: () {
                                                Get.to(HistoryDetailsScreen(
                                                    historyData: historyData));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: const BoxDecoration(
                                                          color:
                                                              Color(0xff2D2938),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: ConstantColors
                                                                      .background,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: ClipOval(
                                                                child: SizedBox
                                                                    .fromSize(
                                                                  size: const Size
                                                                          .fromRadius(
                                                                      20), // Image radius
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: historyData
                                                                            .categoryPhoto
                                                                            .toString(),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                downloadProgress) =>
                                                                            Center(
                                                                          child:
                                                                              CircularProgressIndicator(value: downloadProgress.progress),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              historyData
                                                                  .categoryName
                                                                  .toString()
                                                                  .tr,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: ConstantColors
                                                              .cardViewColor,
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              historyData
                                                                  .subject
                                                                  .toString(),
                                                              maxLines: 2,
                                                              // textDirection:
                                                              //     TextDirection
                                                              //         .ltr,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              historyData.answer
                                                                  .toString()
                                                                  .replaceFirst(
                                                                      '\n\n',
                                                                      ''),
                                                              maxLines: 2,
                                                              // textDirection:
                                                              //     TextDirection
                                                              //         .ltr,
                                                              // textAlign: Preferences
                                                              //             .localLNG ==
                                                              //         'English'
                                                              //     ? TextAlign
                                                              //         .start
                                                              //     : TextAlign
                                                              //         .end,
                                                              style: TextStyle(
                                                                  color: ConstantColors
                                                                      .subTitleTextColor,
                                                                  letterSpacing:
                                                                      1.5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
