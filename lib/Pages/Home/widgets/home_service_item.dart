import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

class HomeServiceItem extends StatelessWidget {
  final String image;
  final String title;
  final String titleOnImage;
  final bool isLoading;
  final Function() onTap;

  const HomeServiceItem({
    super.key,
    required this.image,
    required this.isLoading,
    required this.title,
    required this.titleOnImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.rh, horizontal: 10.rw),
        decoration: BoxDecoration(
          borderRadius: 20.rSp.br,
          color: Colors.grey.shade200,
        ),
        child: Column(
          children: [
            /* LoadAssetImage(
              image: image,
              width: 250.rw,
              height: 200.rh,
              fit: BoxFit.fill,
            ),*/
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      ColorsManager.primaryGreen.withOpacity(0.5),
                      // Adjust grey overlay color and opacity
                      BlendMode.darken, // Adjust blending mode as needed
                    ),
                    child: LoadAssetImage(
                      image: image,
                      extension: titleOnImage.isEmpty ? "png" : "jpg",
                      width: 250.rw,
                      height: 200.rh,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 10,
                  child: Container(
                    width: 200.rw,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      titleOnImage,
                      style: TextStyles.bold28.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.rSp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace6,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.bold16,
                ),
                horizontalSpace30,
                PrimaryButton(
                  isLoading: isLoading,
                  width: 100.rw,
                  height: 36.rh,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  textStyle: TextStyles.semiBold20.copyWith(
                    color: ColorsManager.mainColor,
                  ),
                  text: LocaleKeys.request.tr(),
                  onPressed: onTap,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
