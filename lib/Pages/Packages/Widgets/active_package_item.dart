import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/Packages/pages/package_details_page.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/custom_network_image.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

import 'package:helpooappclient/Models/companies/corporate_company_model.dart';

import 'package_details.dart';
import 'utils.dart';

class ActivePackageItem extends StatelessWidget {
  final Package package;

  const ActivePackageItem({
    super.key,
    required this.package,
  });

  Widget _verticalSpace() => SizedBox(
        height: 8.rh,
      );

  @override
  Widget build(BuildContext context) {
    final corporateCompany = package.usedPromosPackages!.isNotEmpty
        ? package.usedPromosPackages![0].packagePromoCode?.corporateCompany
        : null;
    return Stack(clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10,30,10,10),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: ColorsManager.gray10,
            borderRadius: 8.rSp.br,
            boxShadow: primaryShadow,
          ),
          child: Row(
            children: [
              _buildVendorImage(corporateCompany),
              SizedBox(
                width: 12.rw,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.activated.tr(),
                    style: TextStyles.bold12.copyWith(
                      color: ColorsManager.mainColor,
                    ),
                  ),
                  _verticalSpace(),
                  _buildText(corporateCompany),
                  _verticalSpace(),
                  Visibility(
                    visible: package.assignedCars != package.numberOfCars,
                    child: PrimaryButton(
                      text: LocaleKeys.addCar.tr(),
                      textStyle: TextStyles.medium11.copyWith(
                        color: Colors.white,
                      ),
                      width: 100.rw,
                      height: 30.rh,
                      onPressed: () {
                        NavigationService.navigatorKey.currentContext!.pushNamed(
                            PageRouteName.addCarOrSelectCarPackage,
                            arguments: {
                              "selectedAddedPackage": package,
                              "addedCars": package.assignedCars ?? 0,
                              "totalCars": package.numberOfCars ?? 0,
                            });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              horizontalSpace6,
              Column(
                children: [
                  Text(
                    LocaleKeys.carsAddedToPackage.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyles.medium10,
                  ),
                  _verticalSpace(),
                  Text(
                    '${package.assignedCars ?? 0}/${package.numberOfCars ?? 0}',
                    style: TextStyles.bold16,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(top:0,left: 0,child: GestureDetector(onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PackageDetailsPage(package: package),));
        },child: Center(child: Container(height: 27.5,padding: EdgeInsets.symmetric(horizontal: 20),decoration: BoxDecoration(color: ColorsManager.mainColor,borderRadius: BorderRadius.only(topLeft: Radius.circular(7.5))),child: Center(child: Text(LocaleKeys.details.tr(),style: TextStyle(color: Colors.white),))))))
      ],
    );
  }

  Widget _buildVendorImage(CorporateCompany? corporateCompany) {
    String? photoPath = corporateCompany?.photo ?? package.photo;
    // if (corporateCompany?.photo == null) return SizedBox.shrink();
    return CustomNetworkImage(
      path: photoPath ?? '',
      height: 50.rh,
      width: 50.rh,
    );
  }

  Widget _buildText(corporateCompany) {
    if (corporateCompany != null)
      return Text(
        '${package.name} ${LocaleKeys.offeredBy.tr()} ${corporateCompany.name}',
        style: TextStyles.bold14,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      );
    return Text(
      '${package.name}',
      style: TextStyles.bold14,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}
