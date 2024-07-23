import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Models/companies/corporate_company_model.dart';
import 'package:helpooappclient/Pages/Packages/Widgets/utils.dart';
import 'package:helpooappclient/Widgets/custom_network_image.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/online_image_viewer.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

class AuthPackageItem extends StatelessWidget {
  final bool isHelpooPackage;
  final int index;
  final bool isEndMargin;
  final PackagesScreenBloc? packagesScreenBloc;
  final bool isFromCorporate;
  final ({int? discountPercent, int? discountFees})? discount;

  const AuthPackageItem(
      {super.key,
      this.isHelpooPackage = false,
      required this.index,
      this.isEndMargin = false,
      required this.packagesScreenBloc,
      this.discount,
      this.isFromCorporate = false});

  @override
  Widget build(BuildContext context) {
    final package = packagesScreenBloc?.helpooPackages[index];
    final corporateCompany = packagesScreenBloc?.corporateCompany;
    return BlocBuilder<PackagesScreenBloc, PackagesScreenState>(
      builder: (context, state) {
        bool isSelectedPackage =
            isHelpooPackage && packagesScreenBloc?.selectedPackage == index;

        num? price = 0;

        if (isHelpooPackage) {
          bool isPrecentage = packagesScreenBloc!.isPromoPackageActive &&
              (packagesScreenBloc!.fetchedPromos[0].percentage != null &&
                  packagesScreenBloc!.fetchedPromos[0].percentage != 0);
          price = packagesScreenBloc!.isPromoPackageActive
              ? isPrecentage
                  ? (packagesScreenBloc!.helpooPackages[index].fees!.toInt() -
                      ((packagesScreenBloc!.helpooPackages[index].fees!
                                  .toInt() *
                              packagesScreenBloc!.fetchedPromos[0].percentage!
                                  .toInt()) /
                          100))
                  : packagesScreenBloc!.helpooPackages[index].fees!.toInt() -
                      packagesScreenBloc!.fetchedPromos[0].feesDiscount!.toInt()
              : packagesScreenBloc?.helpooPackages[index].fees!.toInt();
        }

        return Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            AnimatedContainer(
              duration: duration300,
              padding: EdgeInsetsDirectional.only(
                start: 10.rw,
                end: 10.rw,
                top: 10.rh,
                bottom: 10.rh,
              ),
              margin: EdgeInsetsDirectional.only(
                //  start: 10.rw,
                end: isEndMargin ? 12.rw : 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: 14.rSp.br,
                border: isSelectedPackage
                    ? Border.all(
                        color: ColorsManager.mainColor.withOpacity(0.7),
                        width: 1.5.rw,
                      )
                    : null,
                boxShadow: primaryShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)),
                    child: CircleAvatar(
                        radius: 10,
                        backgroundColor: isSelectedPackage
                            ? ColorsManager.primaryGreen
                            : Colors.transparent),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  _buildVendorImage(package, corporateCompany),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isHelpooPackage
                                  ? packagesScreenBloc
                                          ?.helpooPackages[index].name ??
                                      ''
                                  : packagesScreenBloc
                                          ?.myPackages[index].name ??
                                      '',
                              style: isHelpooPackage
                                  ? TextStyles.bold15.copyWith(
                                      color: ColorsManager.mainColor,
                                    )
                                  : TextStyles.bold12,
                            ),
                            SizedBox(width: 5.rw),
                            if (packagesScreenBloc
                                    ?.helpooPackages[index].dealName !=
                                '')
                              Text(
                                "(${"${packagesScreenBloc?.helpooPackages[index].dealName}"})",
                                style: TextStyles.medium13,
                              )
                          ],
                        ),
                        verticalSpace10,
                        if (isHelpooPackage) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((packagesScreenBloc?.isPromoPackageActive ??
                                      false) ||
                                  discount != null)
                                Text(
                                  '${packagesScreenBloc?.helpooPackages[index].fees!.toInt()} ${LocaleKeys.lePerYear.tr()} ',
                                  style: TextStyles.medium10.copyWith(
                                    color: ColorsManager.mainColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (discount != null)
                                    Text(
                                      '${_calcPrice(package!.fees!.toInt())}  - ${packagesScreenBloc?.helpooPackages[index].numberOfCars == 1 ? LocaleKeys.oneCar.tr() : packagesScreenBloc?.helpooPackages[index].numberOfCars == 2 ? LocaleKeys.twoCars.tr() : '${packagesScreenBloc?.helpooPackages[index].numberOfCars} ${LocaleKeys.cars.tr()} '}',
                                      style: TextStyles.medium12,
                                    ),
                                  if (discount == null)
                                    Text(
                                      '${price?.toInt() ?? '0'} ${LocaleKeys.le.tr()}  - ${packagesScreenBloc?.helpooPackages[index].numberOfCars == 1 ? LocaleKeys.oneCar.tr() : packagesScreenBloc?.helpooPackages[index].numberOfCars == 2 ? LocaleKeys.twoCars.tr() : '${packagesScreenBloc?.helpooPackages[index].numberOfCars} ${LocaleKeys.cars.tr()} '}',
                                      style: TextStyles.medium12,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          InkWell(
                            onTap: () {
                              // TODO : Navigate to package details
                              packagesScreenBloc
                                      ?.selectedPackageToDisplayDetails =
                                  packagesScreenBloc!.myPackages[index];
                              // context.pushNamed(PageRouteName.packageDetails);
                              Navigator.of(context).push(MaterialPageRoute(
                                //  settings: settings,
                                builder: (context) => BlocProvider(
                                  create: (context) => PackagesScreenBloc(),
                                  child: PackageDetails(
                                    package:
                                        packagesScreenBloc?.myPackages[index],
                                  ),
                                ),
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      LocaleKeys.details.tr(),
                                      style: TextStyles.bold12.copyWith(
                                        color: ColorsManager.mainColor,
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: ColorsManager.mainColor,
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    )
                                  ],
                                ),
                                /*Padding(
                                  padding: const EdgeInsets.only(top:5.0),
                                  child: Icon(
                                    EasyLocalization.of(context)!.currentLocale?.countryCode?.compareTo('en')==0?
                                    Icons.arrow_back:Icons.arrow_forward_outlined,
                                    color: ColorsManager.mainColor,
                                    size: 16.rSp,
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: isHelpooPackage
                        ? InkWell(
                            onTap: () {
                              // TODO : Navigate to package details
                              packagesScreenBloc
                                      ?.selectedPackageToDisplayDetails =
                                  packagesScreenBloc!.helpooPackages[index];

                              Navigator.of(context).push(MaterialPageRoute(
                                //settings: settings,
                                builder: (context) => BlocProvider(
                                  create: (context) => PackagesScreenBloc(),
                                  child: PackageDetails(
                                      package: packagesScreenBloc
                                          ?.helpooPackages[index]),
                                ),
                              ));
                              //context.pushNamed(PageRouteName.packageDetails);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Text(
                                //   LocaleKeys.details.tr(),
                                //   style: TextStyles.bold12.copyWith(
                                //     color: ColorsManager.mainColor,
                                //   ),
                                // ),
                                Icon(
                                  Icons.info,
                                  color: ColorsManager.mainColor,
                                  size: 30.rSp,
                                ),
                              ],
                            ),
                          )
                        : Visibility(
                            visible: packagesScreenBloc
                                    ?.myPackages[index].assignedCars !=
                                packagesScreenBloc
                                    ?.myPackages[index].numberOfCars,
                            child: PrimaryButton(
                              width: 70.rw,
                              height: 26.rh,
                              radius: 8.rSp,
                              text: LocaleKeys.activate.tr(),
                              textStyle: TextStyles.bold12
                                  .copyWith(color: Colors.white),
                              onPressed: () {
                                // TODO : Activate Package onPressed
                                packagesScreenBloc
                                        ?.selectedPackageToDisplayDetails =
                                    packagesScreenBloc!.myPackages[index];
                                // context.pushNamed(PageRouteName.packageActivationPage);
                                Navigator.of(context).push(MaterialPageRoute(
                                  //settings: settings,
                                  builder: (context) => BlocProvider(
                                    create: (context) => PackagesScreenBloc(),
                                    child: PackageActivationPage(
                                        package: packagesScreenBloc
                                            ?.myPackages[index]),
                                  ),
                                ));
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),

            ///* Package Logo
            // AnimatedContainer(
            //   duration: duration300,
            //   padding: EdgeInsets.all(6.rSp),
            //   height: isSelectedPackage ? 55.rSp : 50.rSp,
            //   width: isSelectedPackage ? 55.rSp : 50.rSp,
            //   alignment: AlignmentDirectional.center,
            //   decoration: BoxDecoration(
            //     color: ColorsManager.greyColor,
            //     shape: BoxShape.circle,
            //     border: isSelectedPackage
            //         ? Border.all(
            //       color: ColorsManager.mainColor.withOpacity(0.7),
            //       width: 1.5.rw,
            //     )
            //         : null,
            //   ),
            //   child: _getPackageLogo(),
            // ),
          ],
        );
      },
    );
  }

  num _calcPrice(int fees) {
    return switch (discount) {
      (discountFees: null, discountPercent: int discountPercent) =>
        fees - ((fees * discountPercent) / 100),
      (discountFees: int discountFees, discountPercent: null) =>
        fees - discountFees,
      _ => fees
    };
  }

  Widget _buildVendorImage(
      Package? package, CorporateCompany? corporateCompany) {
    String? photoPath = corporateCompany?.photo ?? package?.photo;
    // if (corporateCompany?.photo == null) return SizedBox.shrink();
    print(photoPath);
    print(isFromCorporate);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomNetworkImage(
        path: photoPath ?? '',
        height: 70.rh,
        width: 70.rh,
      ),
    );
  }

  ///* get logo for package
  Widget _getPackageLogo() {
    if (isHelpooPackage) {
      /* if (packagesScreenBloc.isPromoPackageActive)
      {
        //   printMeLog('image : $imagesBaseUrl${appBloc.fetchedPromos[0].corporateCompany?.photo ?? ''}');
        return Image.network(
          '$imagesBaseUrl${packagesScreenBloc?.fetchedPromos[0].corporateCompany?.photo ?? ''}',
          errorBuilder: (context, error, stackTrace) =>
              const LoadSvg(image: AssetsImages.checkIcon),
        );
      } else */
      {
        return const LoadSvg(image: AssetsImages.checkIcon);
      }
    } else {
      return InterActiveOnlineImage(
        imgUrl: Utils.getCompanyLogoForPackage(
          package: packagesScreenBloc!.myPackages[index],
        ),
        errorBuilder: (context, error, stackTrace) =>
            const LoadSvg(image: AssetsImages.checkIcon),
      );
    }
  }
}
