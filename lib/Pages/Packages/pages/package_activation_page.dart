import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../Widgets/add_car_to_package_button.dart';
import '../Widgets/cars_added_to_package_circle.dart';
import '../Widgets/utils.dart';
import '../packages_screen_bloc.dart';

class PackageActivationPage extends StatefulWidget {
  const PackageActivationPage({Key? key,required this.package}) : super(key: key);
  final Package? package;

  @override
  State<PackageActivationPage> createState() => _PackageActivationPageState();
}

class _PackageActivationPageState extends State<PackageActivationPage> {
  PackagesScreenBloc? packagesScreenBloc;

  @override
  void initState() {
    super.initState();
    packagesScreenBloc = context.read<PackagesScreenBloc>();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      horizontalPadding: 0,
      appBarTitle: LocaleKeys.packageActivation.tr(),
      body: BlocConsumer<PackagesScreenBloc, PackagesScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
        //  Package package = packagesScreenBloc!.selectedPackageToDisplayDetails;
          return SingleChildScrollView(
            child: AnimatedContainer(
              duration: duration500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.package?.name??'',
                                style: TextStyles.bold18,
                              ),
                              Text(
                                "${LocaleKeys.packageWillBeActiveAfter.tr()} ${Utils.getHoursPerDays( widget.package?.activateAfterDays ?? 0)} ${LocaleKeys.hour.tr()}",
                                style: TextStyles.medium10.copyWith(
                                  color: ColorsManager.red,
                                ),
                              ),
                              Text(
                                LocaleKeys.youCanAddCar.tr(),
                                style: TextStyles.medium12,
                              ),
                            ],
                          ),
                        ),
                        CarsAddedToPackageCircle(
                          addedCars:  widget.package?.assignedCars ?? 0,
                          totalCars:  widget.package?.numberOfCars ?? 0,
                        ),
                      ],
                    ),
                  ),
                  verticalSpace20,

                  ///* List of cars
                  ...List.generate(
                    widget.package?.numberOfCars! ==  widget.package?.assignedCars! ? 0 :  widget.package!.numberOfCars! -  widget.package!.assignedCars!,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      margin: EdgeInsets.only(
                        bottom: 16.rSp,
                        right: 12.rSp,
                        left: 12.rSp,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorsManager.gray10,
                        boxShadow: primaryShadow,
                      ),
                      child: Row(
                        children: [
                          const LoadSvg(image: AssetsImages.checkIcon),
                          horizontalSpace6,
                          Expanded(
                            child: Column(
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
                                    /*    appBloc.isFromPackageScreen = true;
                                        appBloc.selectedBottomNavBarIndex = 0;
                                        navigatorKey.currentContext!.pushNamedAndRemoveUntil(Routes.bottomNavBarScreen);
                                    */
                                      },
                                    ),
                                    horizontalSpace30,
                                    AddCarToPackageButton(
                                      buttonText: LocaleKeys.addCar.tr(),
                                      onTap: () {
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
