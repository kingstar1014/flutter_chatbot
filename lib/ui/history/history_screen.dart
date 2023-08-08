import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/history_controller.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/history/history_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HistoryController>(
        init: HistoryController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('History'.tr), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.historyList.isEmpty
                      ? Center(
                          child: Text("No record found".tr,
                              style: TextStyle(
                                  color: ConstantColors.subTitleTextColor)),
                        )
                      : ListView.builder(
                          itemCount: controller.historyList.length,
                          itemBuilder: (context, index) {
                            HistoryData historyData =
                                controller.historyList[index];
                            return InkWell(
                              onTap: () {
                                Get.to(HistoryDetailsScreen(
                                  historyData: historyData,
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                          color: Color(0xff2D2938),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      ConstantColors.background,
                                                  shape: BoxShape.circle),
                                              child: ClipOval(
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(
                                                      20), // Image radius
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: historyData
                                                            .categoryPhoto
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
                                                      )),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              historyData.categoryName
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: ConstantColors.cardViewColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              historyData.subject.toString(),
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              historyData.answer
                                                  .toString()
                                                  .replaceFirst('\n\n', ''),
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: ConstantColors
                                                      .subTitleTextColor,
                                                  letterSpacing: 1.5),
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
          );
        });
  }
}
