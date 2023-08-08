
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/theam/button_them.dart';
import 'package:quicklai/theam/constant_colors.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final Function() onPressPositive;
  final Function() onPressNegative;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.onPressPositive,
    required this.onPressNegative,
  }) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ButtonThem.buildButton(
                      context,
                      title: 'Yes'.tr,
                      btnHeight: 45,
                      btnWidthRatio: 0.8,
                      btnColor: ConstantColors.primary,
                      txtColor: Colors.white,
                      onPress: widget.onPressPositive,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ButtonThem.buildBorderButton(
                      context,
                      title: 'No'.tr,
                      btnHeight: 45,
                      btnWidthRatio: 0.8,
                      btnColor: Colors.white,
                      txtColor: ConstantColors.primary,
                      btnBorderColor: ConstantColors.primary,
                      onPress: widget.onPressNegative,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
