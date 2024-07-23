import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Models/packages/package_model.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Models/cars/my_cars.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Packages/Widgets/add_car_to_package_button.dart';

class AddCarOrSelectCarCard extends StatefulWidget {
  AddCarOrSelectCarCard({
    Key? key,
    required this.selectedPackage,
    this.isFromPayment = false,
  }) : super(key: key);
  final Package? selectedPackage;
  final bool isFromPayment;
  @override
  State<AddCarOrSelectCarCard> createState() => _AddCarOrSelectCarCardState();
}

class _AddCarOrSelectCarCardState extends State<AddCarOrSelectCarCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.only(bottom: 10),
        padding: EdgeInsetsDirectional.only(
          top: 10.rSp,
          bottom: 14.rSp,
          end: 10.rSp,
          start: 10.rSp,
        ),
        decoration: BoxDecoration(
          borderRadius: 20.rSp.br,
          color: ColorsManager.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              //width: 40.rw,
              height: 35.rh,
              decoration: BoxDecoration(
                color: ColorsManager.lightGreyColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LoadAssetImage(
                  image: AssetsImages.carVector,
                  width: 30.rw,
                  height: 30.rh,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            horizontalSpace4,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.chooseCarOrMore.tr(),
                  style: TextStyles.medium12,
                ),
                verticalSpace6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddCarToPackageButton(
                      buttonText: LocaleKeys.myCars.tr(),
                      onTap: () {
                        NavigationService.navigatorKey.currentContext!
                            .pushNamed(
                          PageRouteName.selectCarForAddItToPackage,
                          arguments: {
                            "selectedAddedPackage": widget.selectedPackage,
                            "isFromPayment": widget.isFromPayment,
                          },
                        );
                      },
                    ),
                    horizontalSpace30,
                    AddCarToPackageButton(
                      buttonText: LocaleKeys.addCar.tr(),
                      onTap: () {
                        print(widget.selectedPackage?.name ?? 'no no no');
                        NavigationService.navigatorKey.currentContext!
                            .pushNamed(PageRouteName.addCarScreen, arguments: {
                          "myCarModel": MyCarModel(),
                          "activateCarValue": false,
                          "addCarToPackageValue": false,
                          "isAddCorporateCarValue": false,
                          "isAddNewCarToPackageValue": true,
                          "editCarValue": false,
                          "selectedAddedPackage": widget.selectedPackage,
                          "isFromPayment": widget.isFromPayment,
                        });
                        /*  appBloc.handleAddCarIntro(
                              activateCarValue: false,
                              addCarToPackageValue: false,
                              isAddCorporateCarValue: false,
                              isAddNewCarToPackageValue: true,
                              editCarValue: false);
                            
                          appBloc.selectedCar = MyCarModel();
                          appBloc.selectedAddedPackage = package;
                          navigatorKey.currentContext!.pushNamedAndRemoveUntil(Routes.addCarScreen);*/
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
