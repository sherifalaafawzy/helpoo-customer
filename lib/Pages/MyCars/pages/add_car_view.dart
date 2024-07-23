import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/MyCars/my_cars_bloc.dart';
import 'package:helpooappclient/Pages/MyCars/pages/shooting_in_my_cars.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/other_service/other_service_view.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/primary_form_field.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import 'dart:io' as io;
import '../widgets/myPackagesForAddCar.dart';
import '../widgets/plate_number_widget.dart';
import '../widgets/primary_drop_down_card.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({
    this.selectedAddedPackage,
    this.isFromPayment = false,
    Key? key,
  }) : super(key: key);
  final Package? selectedAddedPackage;
  final bool isFromPayment;
  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  MyCarsBloc? myCarsBloc;

  GlobalKey<FormFieldState> manufecterKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> modelKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> yearKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> colorKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    myCarsBloc = context.read<MyCarsBloc>();
    //   if (userRoleName == "Client") myCarsBloc!.getMyPackages();
    //   if (!myCarsBloc!.isAddNewCarToPackage)
    myCarsBloc!.selectedAddedPackage = Package();
    if (userRoleName == "Client") {
      myCarsBloc!.getMyPackages();
    }
    if (widget.selectedAddedPackage != null) {
      myCarsBloc!.selectedAddedPackage = widget.selectedAddedPackage!;
    }
    myCarsBloc!.getAllManufactures();
    myCarsBloc!.licensesBase64.clear();
    myCarsBloc!.licensesPathes.clear();
    myCarsBloc!.isTakeLicenseImages = false;
    myCarsBloc!.add(HandleIntroEvent(context: context));


    // myCarsBloc!.initCameraController();
  }

  @override
  Widget build(BuildContext context) {
    print((myCarsBloc!.isAddCorporateCar));
    print(myCarsBloc?.licensesBase64.length);
    return BlocConsumer<MyCarsBloc, MyCarsState>(
      listener: (context, state) {
        if (state is SubscribeCarToPackageSuccessState) {
          NavigationService.navigatorKey.currentContext!
              .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
          if (state.isInsurancePackage)
            HelpooInAppNotification.showSuccessMessage(
                message: LocaleKeys.carAddedToPackageSuccessfully.tr());
          else
            _showDialog(context);
        }
        if (state is SubscribeCarToPackageErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        if (state is ActivateCarSuccessState) {
          HelpooInAppNotification.showSuccessMessage(
              message: LocaleKeys.carActivatedSuccessfully.tr());
//          myCarsBloc!.isHomeScreenRoute = true;

          NavigationService.navigatorKey.currentContext!
              .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        }
        if (state is ActivateCarErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        if (state is AddCarSuccessState) {
          if (myCarsBloc!.isAddCorporateCar ||
              myCarsBloc!.isAddCarServiceRequest) {
            print('myCarsBloc?.selectedCar.id');
            print(state.selectedCar?.id);
            final selectedServices = (ModalRoute.of(context)?.settings.arguments
                as Map)['selectedServices'];
            if (selectedServices?['wench'] == true)
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(arguments: state.selectedCar),
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => WenchServiceBloc(),
                      child: ServiceRequestWenchMapsPage(
                        isNewReq: true,
                      ),
                    );
                  },
                ),
              );
            else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(arguments: state.selectedCar),
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => WenchServiceBloc(),
                      child: OtherRequestsPage(
                        otherServices: selectedServices,
                        isNewReq: true,
                      ),
                    );
                  },
                ),
              );
            }
          } else if (myCarsBloc!.isAddNewCarToPackage) {
            myCarsBloc!.subscribeCarToPackage();
          } else {
            HelpooInAppNotification.showSuccessMessage(
                message: LocaleKeys.carAddedSuccessfully.tr());
            //myCarsBloc!.isHomeScreenRoute = true;

            NavigationService.navigatorKey.currentContext!
                .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
          }
        }
        if (state is UpdateCarSuccessState) {
          if (myCarsBloc!.addCarToPackage) {
            myCarsBloc!.subscribeCarToPackage();
          } else {
            HelpooInAppNotification.showSuccessMessage(
                message: LocaleKeys.carUpdatedSuccessfully.tr());
            // myCarsBloc!.isHomeScreenRoute = true;

            NavigationService.navigatorKey.currentContext!
                .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
          }
        }

        if (state is AddCarErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        if (state is UpdateCarErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }

        if (state is CameraInitializedState) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: myCarsBloc!,
              child: ShootingForMyCars(myCarsBloc: myCarsBloc!),
            ),
          ));
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          appBarTitle: /*myCarsBloc!.addCarToPackage
              ? LocaleKeys.packagesubscription.tr()
              : myCarsBloc!.activateCar
              ? LocaleKeys.activateCar.tr()
              : myCarsBloc!.editCar
              ? LocaleKeys.edit
              : */
              LocaleKeys.addCar.tr(),
          extendBodyBehindAppBar: false,
          onBackTab: () {
            // if (myCarsBloc!.addCarToPackage) {

            //   myCarsBloc!.selectedBottomNavBarIndex = userRoleName == "Client" ? 0 : 2;
            //   myCarsBloc!.isHomeScreenRoute = true;

            //    NavigationService.navigatorKey.currentContext!.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
            NavigationService.navigatorKey.currentContext!.pop;
            // }
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Customer Name and Phone =====
                if (myCarsBloc!.isAddCorporateCar)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.clientName.tr(),
                              style: TextStyles.bold14,
                            ),
                            verticalSpace8,
                            PrimaryFormField(
                              validationError: '',
                              // initialValue: '',
                              controller: myCarsBloc?.clientNameController,
                              label: '',
                              onChange: (v) {
                                myCarsBloc!.customerName = v;
                              },
                            ),
                          ],
                        ),
                      ),
                      horizontalSpace30,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.clientMobile.tr(),
                              style: TextStyles.bold14,
                            ),
                            verticalSpace8,
                            PrimaryFormField(
                              validationError: '',
                              controller: myCarsBloc?.clientPhoneController,

                              ///   initialValue: "",
                              label: '',
                              onChange: (v) {
                                myCarsBloc!.customerPhoneNumber = v;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                verticalSpace10,

                // Insurance Company and Policy Number =====
                if (myCarsBloc!.activateCar)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.insuranceCompany.tr(),
                              style: TextStyles.bold14,
                            ),
                            verticalSpace8,
                            PrimaryFormField(
                              validationError: '',
                              controller: myCarsBloc!.insuranceCompanyName,
                              /*initialValue:
                                  myCarsBloc!.selectedCar.insuranceCompany !=
                                          null
                                      ? myCarsBloc!.selectedCar
                                              .insuranceCompany!.arName ??
                                          ""
                                      : "",*/
                              label: myCarsBloc!.selectedCar.insuranceCompany !=
                                      null
                                  ? myCarsBloc!.selectedCar.insuranceCompany!
                                          .arName ??
                                      ""
                                  : "",
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                      horizontalSpace30,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.policyNumber.tr(),
                              style: TextStyles.bold14,
                            ),
                            verticalSpace8,
                            PrimaryFormField(
                              validationError: '',
                              controller: TextEditingController(
                                  text: myCarsBloc!.selectedCar.policyNumber ??
                                      "---"),
                              //    initialValue: myCarsBloc!.selectedCar.policyNumber ?? "",
                              label: '',
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                verticalSpace10,

                // Car Type and Model ======================
                Row(
                  children: [
                    // Car Type *****

                      Expanded(
                          child: PrimaryDropDown(
                              controller: myCarsBloc?.carManufacturerController,
                              globalKey: manufecterKey,
                              title: LocaleKeys.carType.tr(),
                              hint: myCarsBloc?.selectedCar.manufacturer?.name != null ? myCarsBloc!.selectedCar.manufacturer!.name
                                  : LocaleKeys.carType.tr(),
                              validatorText: 'please select type',
                              items: myCarsBloc!.manufactures
                                  .map((e) => e.name)
                                  .toList(),
                              isLoading:
                                  myCarsBloc!.isGetAllManufacturesLoading,
                              isEnabled: myCarsBloc!.editCar || myCarsBloc!.selectedCar.manufacturer == null,
                              onSelect: (v) {
                                myCarsBloc?.carModelController.clear();

                                myCarsBloc!.selectedManufacturer =
                                      myCarsBloc!.manufactures.firstWhere(
                                          (element) => element.name == v);
                                  myCarsBloc!.getModelsForManufacturer();

                              })),
                    horizontalSpace30,
                    //Car Model *****

                      Expanded(
                        child: PrimaryDropDown(
                          controller: myCarsBloc?.carModelController,
                          globalKey: modelKey,
                          title: LocaleKeys.carModel.tr(),
                          hint:myCarsBloc?.selectedCar.carModel?.name!=null ? myCarsBloc!.selectedCar.carModel!.name
                              : LocaleKeys.carModel.tr(),
                          validatorText: 'please select model',
                          isEnabled: myCarsBloc!.editCar || myCarsBloc!.selectedCar.carModel == null,
                          isLoading:
                              myCarsBloc!.isGetModelsForManufacturerLoading,
                          items: myCarsBloc!.models.map((e) => e.name).toList(),
                          onSelect: (v) {

                            myCarsBloc!.selectedModel =
                                myCarsBloc!.models.firstWhere(
                              (element) => element.name == v,
                            );
                          },
                        ),
                      )
                  ],
                ),
                verticalSpace10,

                // Car Year and Color ======================
                Row(
                  children: [
                    //Car Year *****
                    Expanded(
                      child: PrimaryDropDown(
                        controller: myCarsBloc?.carYearController,
                        globalKey: yearKey,
                        title: LocaleKeys.year.tr(),
                        hint: myCarsBloc?.selectedCar.year != null ? myCarsBloc!.selectedCar.year.toString()
                            : LocaleKeys.year.tr(),
                        validatorText: 'please select year',
                        isEnabled: myCarsBloc!.editCar || myCarsBloc!.selectedCar.year == null,
                        items: years,
                        onSelect: (v) {
                          //  printMeLog('selected Year ===>>> $v');
                          if (myCarsBloc!.addCarToPackage ||
                              myCarsBloc!.activateCar ||
                              myCarsBloc!.editCar) {
                            myCarsBloc!.selectedCar.year = int.parse(v ?? "");
                          }
                          myCarsBloc!.selectedCarYear = v;
                        },
                      ),
                    ),
                    horizontalSpace30,
                    // Car Color *****
                    Expanded(
                      child: PrimaryDropDown(
                        controller: myCarsBloc?.carColorController,
                        globalKey: colorKey,
                        title: LocaleKeys.color.tr(),
                        hint: myCarsBloc?.selectedCar.color != null ? myCarsBloc!.selectedCar.color!
                            : LocaleKeys.color.tr(),
                        validatorText: 'please select color',
                        isEnabled: myCarsBloc!.editCar || myCarsBloc!.selectedCar.color == null,
                        items: CarColors.values
                            .map((e) => (isArabic ? e.nameAr : e.nameEn))
                            .toList(),
                        onSelect: (v) {
                          //    printMeLog('selected Color ===>>> $v');
                          if (myCarsBloc!.addCarToPackage ||
                              myCarsBloc!.activateCar ||
                              myCarsBloc!.editCar) {
                            myCarsBloc!.selectedCar.color = v ?? "";
                          }
                          myCarsBloc!.selectedCarColor = v;
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace10,

                // Car Chassis Number ================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.vinNumber.tr(),
                          style: TextStyles.bold14,
                        ),
                        IconButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                backgroundColor: whiteColor,
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(onPressed: () => context.pop(), icon: Icon(Icons.clear)),
                                    Image.asset(AssetsImages.vinNumInLicence),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.info_outline),
                        ),
                      ],
                    ),
                    verticalSpace8,
                    PrimaryFormField(
                      validationError: '',
                      // initialValue: ,
                      controller: TextEditingController(

                          text: myCarsBloc?.selectedCar.vinNumber ??
                              myCarsBloc?.selectedCarVinNumber),
                      enabled: myCarsBloc!.editCar || myCarsBloc!.selectedCar.vinNumber == null,
                      onChange: (v) {
                        if (myCarsBloc!.addCarToPackage ||
                            myCarsBloc!.activateCar ||
                            myCarsBloc!.editCar) {
                          myCarsBloc!.selectedCar.vinNumber = v;
                        } else {
                          myCarsBloc!.selectedCarVinNumber = v;
                        }
                      },
                    ),
                  ],
                ),
                verticalSpace10,

                // Car Plate Number ================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.plateNumber.tr(),
                      style: TextStyles.bold14,
                    ),
                    verticalSpace8,
                    CarPlateNumber(
                      confirmData: myCarsBloc!.addCarToPackage || myCarsBloc!.activateCar || myCarsBloc!.editCar,
                    ),
                  ],
                ),

                verticalSpace16,
                if ((myCarsBloc!.addCarToPackage ||
                        myCarsBloc!.isAddNewCarToPackage) &&
                    myCarsBloc!.myPackages.isNotEmpty) ...[
                  MyPackagesForAddCar(
                    selectedPackage: widget.selectedAddedPackage,
                    isFromPayment: widget.isFromPayment,
                  )
                ],

                // verticalSpace16,
                Visibility(
                  visible: myCarsBloc!.activateCar,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.rSp,
                      vertical: 50.rSp,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: 15.rSp.br,
                      border: Border.all(
                        color: ColorsManager.mainColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myCarsBloc!.isTakeLicenseImages
                            ? Container(
                                height: 150,
                                width: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: myCarsBloc!.licensesImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Container(
                                          height: 100,
                                          width: 250,
                                          child: Image.file(
                                              io.File(myCarsBloc!
                                                  .licensesPathes[index]),
                                              fit: BoxFit.cover)),
                                      // child: Image.file(myCarsBloc!. licensesImages[index].path),
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  LocaleKeys.twoSideShoot.tr(),
                                  style: TextStyles.bold14
                                      .copyWith(color: ColorsManager.mainColor),
                                ),
                              ),
                        horizontalSpace10,
                        GestureDetector(
                          onTap: () async {
                            myCarsBloc!.selectImages();
                          },
                          child: const Icon(
                            Icons.image,
                            color: ColorsManager.mainColor,
                            size: 33,
                          ),
                        ),
                        horizontalSpace10,
                        GestureDetector(
                          onTap: () async {
                            myCarsBloc!.licensesBase64.clear();
                            myCarsBloc!.licensesImages.clear();
                            myCarsBloc!.licensesPathes.clear();

                            myCarsBloc!.initCameraController();
                          },
                          child: const LoadSvg(
                            isIcon: true,
                            image: AssetsImages.camera,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace20,

                // confirm
                PrimaryButton(
                  text: LocaleKeys.confirm.tr(),
                  isLoading: myCarsBloc!.isAddCarLoading ||
                      myCarsBloc!.isSubscribeCarLoading ||
                      myCarsBloc!.isActivateCarLoading ||
                      myCarsBloc!.isUpdateCarLoading,
                  onPressed: () {
                    myCarsBloc!.selectedCar.manufacturer??=myCarsBloc!.selectedManufacturer;
                    myCarsBloc!.selectedCar.vinNumber??=myCarsBloc!.selectedCarVinNumber;
                    myCarsBloc!.selectedCar.color??=myCarsBloc!.selectedCarColor;
                    myCarsBloc!.selectedCar.year??=int.tryParse(myCarsBloc!.selectedCarYear!);
                    myCarsBloc!.selectedCar.carModel??=myCarsBloc!.selectedModel;

                    myCarsBloc!.selectedCar.plateNumber =
                        myCarsBloc!.policyCarFirstCharController.text +
                            "-" +
                            myCarsBloc!.policyCarSecondCharController.text +
                            "-" +
                            myCarsBloc!.policyCarThirdCharController.text +
                            "-" +
                            myCarsBloc!.policyCarPlateNumberController.text;
                    if (myCarsBloc!.addCarToPackage) {
                      debugPrint('add car -----> .isAddCarToPackage');
                      ///  print('myCarsBloc!.selectedCar.plateNumber!.length');
                      ///  print(myCarsBloc!.selectedCar.plateNumber!.length);
                      if (myCarsBloc!.selectedCar.vinNumber != null &&
                          myCarsBloc!.selectedCar.vinNumber!.isNotEmpty &&
                          myCarsBloc!.selectedAddedPackage.packageId != null &&
                          myCarsBloc?.selectedCar.color != null &&
                          myCarsBloc?.selectedCar.manufacturer?.id != null &&
                          myCarsBloc?.selectedCar.year != null &&
                          myCarsBloc?.selectedCar.carModel?.id != null &&
                          myCarsBloc?.selectedCar.color != "" &&
                          myCarsBloc?.selectedCar.year.toString() != "" &&
                          myCarsBloc?.selectedCar.carModel?.name != "" &&
                          myCarsBloc?.selectedCar.manufacturer?.name != "" &&
                          myCarsBloc?.selectedCar.plateNumber != null &&
                          myCarsBloc!.selectedCar.plateNumber!
                              .replaceAll("-", "")
                              .isNotEmpty) {
                        if(myCarsBloc!.selectedCar.vinNumber!.length>=5 &&
                          myCarsBloc!.selectedCar.vinNumber!.length <=17&&
                          RegExp(r'^[a-zA-Z0-9]+$').hasMatch(myCarsBloc!.selectedCar.vinNumber!)){
                          myCarsBloc!.updateCar();

                        }else{
                          HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());
                        }
                      } else {
                        HelpooInAppNotification.showErrorMessage(
                            message: LocaleKeys.pleaseAddRequiredData.tr());
                      }
                    }
                    else if (myCarsBloc!.editCar) {
                      debugPrint('add car -----> .editCar');
                      if(myCarsBloc!.selectedCar.vinNumber != null){
                        if(myCarsBloc!.selectedCar.vinNumber!.length>=5&& myCarsBloc!.selectedCar.vinNumber!.length<=17 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(myCarsBloc!.selectedCar.vinNumber!)){
                          myCarsBloc!.updateCar();
                        }else{
                          HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());
                        }
                      }else{
                            myCarsBloc!.updateCar();
                      }
                    }
                    else if (myCarsBloc!.isAddNewCarToPackage) {
                      debugPrint('add car -----> .isAddNewCarToPackage');
                      if (myCarsBloc!.isAddCarValidWithPackage) {
                        if (myCarsBloc?.selectedManufacturer != null &&
                                myCarsBloc?.selectedCarYear != null &&
                                myCarsBloc?.selectedModel != null &&
                                myCarsBloc?.selectedCarColor != "" &&
                                myCarsBloc?.selectedCarYear != "" &&
                                myCarsBloc!.selectedCarVinNumber != null&&
                                myCarsBloc?.selectedModel?.name != "" &&
                                myCarsBloc?.selectedManufacturer?.name != ""
                             // && myCarsBloc!.selectedAddedPackage.id != null
                            ) {
                          if(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(myCarsBloc!.selectedCar.vinNumber!)&&
                              myCarsBloc!.selectedCarVinNumber!.length>=5 &&
                              myCarsBloc!.selectedCarVinNumber!.length<=17
                          ) {
                            myCarsBloc!.addCar();
                          } else {
                          HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());
                          }
                        }
                      } else {
                          // debugPrint('add car Not Valid');
                        HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.pleaseAddRequiredData.tr(),
                        );
                      }
                    }
                    else if (myCarsBloc!.activateCar) {
                      debugPrint('add car -----> .activateCar');
                      if (myCarsBloc!.selectedCar.vinNumber != null &&
                          myCarsBloc?.selectedCar.color != null &&
                          myCarsBloc?.selectedCar.manufacturer?.id != null &&
                          myCarsBloc?.selectedCar.year != null &&
                          myCarsBloc?.selectedCar.carModel?.id != null &&
                          myCarsBloc?.selectedCar.color != "" &&
                          myCarsBloc?.selectedCar.year.toString() != "" &&
                          myCarsBloc!.selectedCar.vinNumber != "" &&
                          myCarsBloc?.selectedCar.carModel?.name != "" &&
                          myCarsBloc?.selectedCar.manufacturer?.name != "" &&
                          myCarsBloc!.selectedCar.insuranceCompany?.id != null &&
                          // TODO:---------------
                          ((myCarsBloc!.selectedCar.policyNumber?.isNotEmpty ?? false) || myCarsBloc!.insurancePolicyNumber.text.isNotEmpty) &&
                          myCarsBloc!.licensesBase64.length == 2 &&
                          myCarsBloc?.selectedCar.plateNumber != null &&
                          myCarsBloc!.selectedCar.plateNumber!.isNotEmpty) {
                        if(myCarsBloc!.selectedCar.vinNumber!.length >=5 &&
                            myCarsBloc!.selectedCar.vinNumber!.length<=17 &&
                            RegExp(r'^[a-zA-Z0-9]+$').hasMatch(myCarsBloc!.selectedCar.vinNumber!)){
                          myCarsBloc!.activateCarMothod();

                        }else{
                          HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());
                        }
                      } else {
                        //   printMeLog('add car Not Valid');
                        HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.pleaseAddRequiredData.tr(),
                        );
                      }
                    }
                    else if (myCarsBloc!.isAddCorporateCar) {
                      debugPrint('add car -----> .isAddCorporateCar');
                      if (myCarsBloc!.selectedCarVinNumber == "") {
                        HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.pleaseAddRequiredData.tr(),
                        );
                      }
                      if ( //myCarsBloc!.selectedCarVinNumber != null &&
                          myCarsBloc?.selectedCarColor != null &&
                              myCarsBloc?.selectedManufacturer != null &&
                              myCarsBloc?.selectedCarYear != null &&
                              myCarsBloc?.selectedModel != null &&
                              myCarsBloc?.selectedCarColor != "" &&
                              myCarsBloc?.selectedCarYear != "" &&
                              //myCarsBloc!.selectedCarVinNumber != "" &&
                              myCarsBloc?.selectedModel?.name != "" &&
                              myCarsBloc?.selectedManufacturer?.name != "" &&
                              myCarsBloc!
                                  .clientNameController.text.isNotEmpty &&
                              myCarsBloc!
                                  .clientPhoneController.text.isNotEmpty) {
                        myCarsBloc!.addCorporateCar();
                      } else {
                        HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.pleaseAddRequiredData.tr(),
                        );
                      }
                    }
                    else if (myCarsBloc!.isAddCarValidNoVin) {
                      if(myCarsBloc!.isAddCarValid){
                        debugPrint('add car -----> .isAddCarValid');
                      myCarsBloc!.addCar();
                      }else{
                          HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());

                      }
                      
                    } else {
                      debugPrint('add car -----> .AddCarNotValid');
                      HelpooInAppNotification.showErrorMessage(
                        message: LocaleKeys.pleaseAddRequiredData.tr(),
                      );
                    }
                  },
                ),
                verticalSpace20,
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PackageSuccessDialog(context: context);
      },
    );
  }
}

class PackageSuccessDialog extends StatelessWidget {
  final BuildContext context;
  PackageSuccessDialog({required this.context});

  @override
  Widget build(context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            margin: const EdgeInsets.only(top: 30.0, right: 8.0),
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    width: 240,
                    child: Text("car_added_to_package_success".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0B141F))) //
                    ),
                PrimaryButton(
                    text: "ok".tr(),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: const Color(0xffD9D9D9),
                    child: SvgPicture.asset(
                      "assets/images/check_icon.svg",
                      height: 60,
                      width: 60,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//******************************************************************************

