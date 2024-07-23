import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../generated/locale_keys.g.dart';

class CarsAddedToPackageCircle extends StatelessWidget {
  final int totalCars;
  final int addedCars;

  const CarsAddedToPackageCircle({
    super.key,
    required this.totalCars,
    required this.addedCars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: ColorsManager.darkGreyColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.carsAddedToPackage.tr(),
            textAlign: TextAlign.center,
            style: TextStyles.medium10,
          ),
          Text(
            '$addedCars/$totalCars',
            style: TextStyles.bold16,
          ),
        ],
      ),
    );
  }
}
