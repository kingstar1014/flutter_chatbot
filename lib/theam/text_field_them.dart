import 'package:flutter/material.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:sizer/sizer.dart';

class TextFieldThem {
  const TextFieldThem(Key? key);

  static boxBuildTextField({
    required String hintText,
    required TextEditingController controller,
    IconButton? suffixData,
    String? Function(String?)? validators,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = true,
    EdgeInsets contentPadding = EdgeInsets.zero,
    maxLine = 1,
    bool enabled = true,
    maxLength = 300,
  }) {
    return Sizer(builder: (context, orientation, deviceType) {
      return TextFormField(
          obscureText: !obscureText,
          validator: validators,
          keyboardType: textInputType,
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          maxLines: maxLine,
          maxLength: maxLength,
          enabled: enabled,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              // ignore: unrelated_type_equality_checks
              suffixIcon: suffixData,
              counterText: "",
              fillColor: ConstantColors.cardViewColor,
              filled: true,
              contentPadding: EdgeInsets.all(4.w),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColors.cardViewColor, width: 0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColors.cardViewColor, width: 0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColors.cardViewColor, width: 0.7),
              ),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ConstantColors.cardViewColor, width: 0.7),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: ConstantColors.hintTextColor)));
    });
  }
}
