import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';


class TextContainerItem extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color containerColor;

  const TextContainerItem({
    Key? key,
    required this.text,
    this.textColor = ColorsManager.textColor,
    this.containerColor = ColorsManager.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration300,
      padding: EdgeInsets.symmetric(
        vertical: 4.rh,
        horizontal: 12.rw,
      ),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: 8.rSp.br,
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyles.medium12.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
