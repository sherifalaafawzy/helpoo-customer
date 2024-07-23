import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Configurations/extensions/ui_extention.dart';
import '../Configurations/extensions/size_extension.dart';

import '../Style/theme/colors.dart';
import '../Style/theme/text_styles.dart';

class PrimaryFormField extends StatelessWidget {
  final String validationError;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isPassword;
  final GestureTapCallback? onTap;
  final bool enabled;
  // final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool infiniteLines;
  final bool isValidate;
  final Function(String)? onChange;
  final Function(String)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool centerText;

  final Color textColor;

  final Color disabledTextColor;
  final Color hintTextColor;

  const PrimaryFormField({
    Key? key,
    required this.validationError,
    this.label,
    this.hint,
    this.controller,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.onTap,
    // this.initialValue,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.infiniteLines = false,
    this.isValidate = true,
    this.onChange,
    this.inputFormatters,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.centerText = false,
    this.textColor = ColorsManager.textColor,
    this.disabledTextColor = ColorsManager.darkerGreyColor,
    this.hintTextColor = ColorsManager.darkerGreyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //initialValue: initialValue,
      enabled: enabled,
      onTap: onTap,
      validator: isValidate
          ? (value) {
              if (value!.isEmpty) {
                return validationError;
              }
              return null;
            }
          : null,
      controller: controller,
      obscureText: isPassword,
      maxLines: infiniteLines ? null : 1,
      onChanged: onChange,
      inputFormatters: inputFormatters,

      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: TextStyles.medium14.copyWith(
        color: enabled ? textColor : disabledTextColor,
      ),
      textAlign: centerText ? TextAlign.center : TextAlign.start,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 22.rh,
          horizontal: 8.rw,
        ),
        fillColor: ColorsManager.white,
        filled: true,
        isDense: true,
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintStyle: TextStyles.medium14.copyWith(
          color: hintTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: 15.br,
          borderSide: BorderSide(
            color: ColorsManager.darkGreyColor,
            width: 2.0.rSp,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: 15.br,
          borderSide: BorderSide(
            color: ColorsManager.darkGreyColor,
            width: 2.0.rSp,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: 15.br,
          borderSide: BorderSide(
            color: ColorsManager.darkGreyColor,
            width: 2.0.rSp,
          ),
        ),
      ),
    );
  }
}
