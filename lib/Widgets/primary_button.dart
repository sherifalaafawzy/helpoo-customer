import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Configurations/extensions/ui_extention.dart';

import '../Style/theme/colors.dart';
import '../Style/theme/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isIconButton;
  final IconData? icon;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? radius;
  final TextStyle? textStyle;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isIconButton = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.width,
    this.height,
    this.horizontalPadding,
    this.verticalPadding,
    this.radius,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoading();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 0.0,
        vertical: verticalPadding ?? 0.0,
      ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 54.0,
        child: ElevatedButton(
          onPressed: isDisabled
              ? null
              : () {
                  if (!isLoading) {
                    onPressed();
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: backgroundColor ??
                (isDisabled || isLoading
                    ? ColorsManager.darkGreyColor
                    : ColorsManager.mainColor),
            shape: RoundedRectangleBorder(
              borderRadius: (radius ?? 30).br,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading && isIconButton)
                const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              if (isIconButton) const Spacer(),
              Text(
                text,
                style: textStyle ??
                    TextStyles.medium22.copyWith(
                      color: ColorsManager.white,
                    ),
              ),
              if (isLoading && !isIconButton)
                const SizedBox(
                  width: 4,
                ),
              if (isLoading && !isIconButton)
                const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              if (isIconButton) const Spacer(),
              if (isIconButton)
                Icon(
                  icon,
                  color: ColorsManager.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: 150.br,
        color: backgroundColor ?? ColorsManager.mainColor,
      ),
      child: const CupertinoActivityIndicator(color: Colors.white),
    );
  }
}
