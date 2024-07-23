import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/spacing.dart';



class AddCarToPackageButton extends StatelessWidget {
  final String buttonText;
  final Function() onTap;

  const AddCarToPackageButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: 8.rSp.br,
          color: ColorsManager.mainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonText,
              style: TextStyles.medium12.copyWith(color: Colors.white),
            ),
            horizontalSpace20,
            const LoadSvg(
              image: AssetsImages.plus,
              isIcon: true,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
