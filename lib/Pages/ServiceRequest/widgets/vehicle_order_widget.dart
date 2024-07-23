import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';


class VehicleOrderWidget extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onPressed;
  const VehicleOrderWidget({super.key, required this.image, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.rh,
        horizontal: 12.rw,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.darkGreyColor,
        borderRadius: 10.rSp.br,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          LoadSvg(
            image: image,
          ),
          horizontalSpace6,
          Text(
            title,
            style: TextStyles.bold10.copyWith(
              color: ColorsManager.black,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onPressed,
            child: Container(
              // height: 24.rh,
              // width: 53.rw,
              padding: EdgeInsets.symmetric(
                vertical: 3.rh,
                horizontal: 9.rw,
              ),
              decoration: BoxDecoration(
                color: ColorsManager.mainColor,
                borderRadius: 9.rSp.br,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                LocaleKeys.request.tr(),
                style: TextStyles.bold14.copyWith(
                  color: ColorsManager.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
