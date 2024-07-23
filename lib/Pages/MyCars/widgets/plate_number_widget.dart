import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/MyCars/my_cars_bloc.dart';
import 'package:helpooappclient/Pages/MyCars/widgets/primary_drop_down_card.dart';
import 'package:helpooappclient/Widgets/helpoo_in_app_notifications.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Models/cars/my_cars.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/primary_form_field.dart';
import '../../../Widgets/spacing.dart';

class CarPlateNumber extends StatefulWidget {
  bool confirmData;
  MyCarModel? myCarModel;

  CarPlateNumber({super.key, this.confirmData = false, this.myCarModel});

  @override
  State<CarPlateNumber> createState() => _CarPlateNumberState();
}

class _CarPlateNumberState extends State<CarPlateNumber> {
  GlobalKey<FormFieldState> carFirstCharKey = GlobalKey<FormFieldState>();

  GlobalKey<FormFieldState> carSecondCharKey = GlobalKey<FormFieldState>();

  GlobalKey<FormFieldState> carThirdCharKey = GlobalKey<FormFieldState>();
  MyCarsBloc? myCarsBloc;

  @override
  void initState() {
    super.initState();
    myCarsBloc = context.read<MyCarsBloc>();
    if (widget.confirmData &&
        myCarsBloc?.selectedCar.plateNumber != null &&
        myCarsBloc?.selectedCar.plateNumber != "") {
      List<String> plateNumberChars =
          myCarsBloc!.selectedCar.plateNumber!.split("-");
      if (plateNumberChars[0].contains(RegExp(r'[0-9]'))) {
        myCarsBloc?.policyCarFirstCharController.text = plateNumberChars[3];
        myCarsBloc?.policyCarSecondCharController.text = plateNumberChars[2];
        myCarsBloc?.policyCarThirdCharController.text = plateNumberChars[1];
        myCarsBloc?.policyCarPlateNumberController.text = plateNumberChars[0];
      } else {
        myCarsBloc?.policyCarFirstCharController.text = plateNumberChars[0];
        myCarsBloc?.policyCarSecondCharController.text = plateNumberChars[1];
        myCarsBloc?.policyCarThirdCharController.text = plateNumberChars[2];
        myCarsBloc?.policyCarPlateNumberController.text = plateNumberChars[3];
      }
    } else if (widget.myCarModel != null) {
      List<String> plateNumberChars =
          widget.myCarModel!.plateNumber!.split("-");
      //check the first char is number or not
      if (plateNumberChars[0].contains(RegExp(r'[0-9]'))) {
        myCarsBloc?.policyCarFirstCharController.text = plateNumberChars[3];
        myCarsBloc?.policyCarSecondCharController.text = plateNumberChars[2];
        myCarsBloc?.policyCarThirdCharController.text = plateNumberChars[1];
        myCarsBloc?.policyCarPlateNumberController.text = plateNumberChars[0];
      } else {
        myCarsBloc?.policyCarFirstCharController.text = plateNumberChars[0];
        myCarsBloc?.policyCarSecondCharController.text = plateNumberChars[1];
        myCarsBloc?.policyCarThirdCharController.text = plateNumberChars[2];
        myCarsBloc?.policyCarPlateNumberController.text = plateNumberChars[3];
      }
    } else {
      myCarsBloc?.policyCarFirstCharController.clear();
      myCarsBloc?.policyCarSecondCharController.clear();
      myCarsBloc?.policyCarThirdCharController.clear();
      myCarsBloc?.policyCarPlateNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCarsBloc, MyCarsState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.only(bottom: 8.rSp),
            decoration: BoxDecoration(
              color: ColorsManager.darkGreyColor,
              borderRadius: 8.rSp.br,
              boxShadow: primaryShadow,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.rSp),
                  decoration: BoxDecoration(
                    color: ColorsManager.mainColor,
                    borderRadius: 8.rSp.br,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'مصر',
                        style: TextStyles.bold14.copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        'EGYPT',
                        style: TextStyles.bold14.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                verticalSpace12,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.rSp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60.rSp,
                        child: PrimaryDropDown(
                          isEnabled:
                              myCarsBloc?.selectedCar.plateNumber == null ||
                                  myCarsBloc!.editCar,
                          isFromChars: true,
                          // widget.myCarModel != null,// || (myCarsBloc!.addCarToPackage),
                          controller: myCarsBloc?.policyCarFirstCharController,
                          globalKey: carFirstCharKey,
                          title: '',
                          hint: myCarsBloc?.policyCarFirstCharController.text
                                      .isNotEmpty ??
                                  false
                              ? myCarsBloc!.policyCarFirstCharController.text
                              : '',
                          items: arabicLetters.toList(),
                          onSelect: (v) {
                            if (arabicLetters.toList().contains(v)) {
                              myCarsBloc?.selectedCarFirstChar = v!;
                            } else {
                              ///  HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddRequiredData);
                              setState(() {
                                myCarsBloc?.policyCarFirstCharController
                                    .clear();
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 60.rSp,
                          child: PrimaryDropDown(
                            isEnabled:
                                myCarsBloc?.selectedCar.plateNumber == null ||
                                    myCarsBloc!.editCar,
                            // widget.myCarModel != null,//|| myCarsBloc!.addCarToPackage,
                            controller:
                                myCarsBloc?.policyCarSecondCharController,
                            globalKey: carSecondCharKey,
                            title: '',
                            hint: myCarsBloc?.policyCarSecondCharController.text
                                        .isNotEmpty ??
                                    false
                                ? myCarsBloc!.policyCarSecondCharController.text
                                : '',

                            isFromChars: true,
                            items: arabicLetters.toList(),
                            onSelect: (v) {
                              if (arabicLetters.toList().contains(v)) {
                                myCarsBloc?.selectedCarFirstChar = v!;
                              } else {
                                setState(() {
                                  myCarsBloc!.policyCarSecondCharController
                                      .clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60.rSp,
                        child: PrimaryDropDown(
                          isEnabled:
                              myCarsBloc?.selectedCar.plateNumber == null ||
                                  myCarsBloc!.editCar,
                          //widget.myCarModel != null,//|| myCarsBloc!.addCarToPackage,
                          controller: myCarsBloc?.policyCarThirdCharController,
                          globalKey: carThirdCharKey,
                          title: '',
                          hint: myCarsBloc?.policyCarThirdCharController.text
                                      .isNotEmpty ??
                                  false
                              ? myCarsBloc!.policyCarThirdCharController.text
                              : '',
                          isFromChars: true,
                          items: arabicLetters.toList(),
                          onSelect: (v) {
                            if (arabicLetters.toList().contains(v)) {
                              myCarsBloc?.selectedCarFirstChar = v!;
                            } else {
                              setState(() {
                                myCarsBloc!.policyCarThirdCharController
                                    .clear();
                              });
                            }
                          },
                        ),
                      ),
                      horizontalSpace14,

                      ///*** Car Plate Number *********
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsManager.white,
                            borderRadius: 15.rSp.br,
                          ),
                          child: PrimaryFormField(
                            keyboardType: TextInputType.phone,
                            enabled:
                                myCarsBloc?.selectedCar.plateNumber == null ||
                                    myCarsBloc!.editCar,
                            /*widget.confirmData &&
                                    myCarsBloc?.selectedCar.plateNumber != null &&
                                    myCarsBloc?.selectedCar.plateNumber != "" &&
                                    myCarsBloc?.selectedCar.plateNumber != "---"
                                ? false
                                : true,//widget.myCarModel == null,*/
                            controller:
                                myCarsBloc?.policyCarPlateNumberController,
                            inputFormatters: [
                              // only input numbers
                              FilteringTextInputFormatter.digitsOnly,
                              // only 5 digits
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validationError: '',
                            hint: 'ـ ـ ـ ـ',
                            centerText: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPrimaryMenu({
    required BuildContext context,
    required GlobalKey key,
    required List<PopupMenuEntry> items,
    bool isBottom = true,
    double height = 50.0,
    double isBottomHeight = 45.0,
  }) {
    showMenu(
      context: context,
      useRootNavigator: true,
      position: RelativeRect.fromDirectional(
        textDirection: TextDirection.rtl,
        start: MediaQuery.sizeOf(context).width - getXPosition(key) - 50.rSp,
        top: isBottom
            ? getYPosition(key) + isBottomHeight
            : getYPosition(key) - height,
        bottom: getYPosition(key),
        end: getXPosition(key),
      ),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(
          30.0,
        ),
      ),
      items: items,
    );
  }
}
