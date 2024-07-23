// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Widgets/spacing.dart';


import '../../generated/locale_keys.g.dart';
import '../Style/theme/colors.dart';
import '../Style/theme/text_styles.dart';
import 'load_svg.dart';

class GradientButton extends StatelessWidget {
  String? title;
  double? border;
  final VoidCallback onPressed;
  List<Color>? colors;
  final bool isWithIcon;
  String? icon;

  GradientButton({
    super.key,
    this.title,
    required this.onPressed,
    this.border,
    this.colors,
    this.isWithIcon = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.rh, horizontal: 12.rw),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ??
                [
                  const Color(0xffB53939),
                  const Color(0xffFF0000),
                ],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
          borderRadius: border?.rSp.br ?? 9.rSp.br,
        ),
        child: isWithIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? LocaleKeys.cancel.tr(),
                    style: TextStyles.bold10.copyWith(
                      color: ColorsManager.white,
                    ),
                  ),
                  horizontalSpace(4),
                  LoadSvg(
                    image: icon ?? '',
                    isIcon: true,
                  )
                ],
              )
            : Text(
                title ?? LocaleKeys.cancel.tr(),
                style: TextStyles.bold10.copyWith(
                  color: ColorsManager.white,
                ),
              ),
      ),
    );
  }
}
