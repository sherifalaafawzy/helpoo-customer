import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Widgets/helpoo_in_app_notifications.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/primary_form_field.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../MyCars/widgets/plate_number_widget.dart';
import '../../MyCars/widgets/primary_drop_down_card.dart';
import '../fnol_bloc.dart';
import 'photography_instructions_page.dart';

class FnolConfirmaionPage extends StatefulWidget {
  FnolConfirmaionPage({Key? key, required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<FnolConfirmaionPage> createState() => _FnolConfirmaionPageState();
}

class _FnolConfirmaionPageState extends State<FnolConfirmaionPage> {
  FnolBloc? fnolBloc;

  final manufecterKey = GlobalKey<FormFieldState>();
  final modelKey = GlobalKey<FormFieldState>();
  final yearKey = GlobalKey<FormFieldState>();
  final colorKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    //fnolBloc = context.read<FnolBloc>();
    fnolBloc = widget.fnolBloc;
    fnolBloc?.add(InitialFNOLEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) async {
        if (state is CreateFnolSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: fnolBloc!,
                child: PhotographyInstructionsPage(fnolBloc: fnolBloc),
              ),
            ),
          );
        }
        if (state is CreateFnolError) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          appBarTitle: LocaleKeys.accidentReport.tr(),
          extendBodyBehindAppBar: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Car Type and Model ======================
                Row(
                  children: [
                    // Car Type *****
                    Expanded(
                      child: PrimaryDropDown(
                        globalKey: manufecterKey,
                        title: LocaleKeys.carType.tr(),
                        hint: fnolBloc!.selectedCar?.manufacturer?.name ?? '',
                        validatorText: 'please select type',
                        items:
                            fnolBloc!.manufactures.map((e) => e.name).toList(),
                        //add text field ua omar
                        isEnabled: false,
                        controller: TextEditingController(),
                      ),
                    ),
                    horizontalSpace30,
                    Expanded(
                      child: PrimaryDropDown(
                        globalKey: modelKey,
                        title: LocaleKeys.carModel.tr(),
                        hint: fnolBloc!.selectedCar?.carModel?.name ?? '',
                        validatorText: 'please select model',
                        isEnabled: false,
                        //change textedit y omar
                        items: fnolBloc!.models.map((e) => e.name).toList(),
                        controller: TextEditingController(),
                      ),
                    ),
                  ],
                ),
                verticalSpace10,

                // Car Year and Color ======================
                Row(
                  children: [
                    Expanded(
                      child: PrimaryDropDown(
                        globalKey: yearKey,
                        title: LocaleKeys.year.tr(),
                        hint: fnolBloc?.selectedCar?.year.toString() ?? '',
                        validatorText: 'please select year',
                        items: years,
                        isEnabled: false,
                        controller: TextEditingController(),
                      ),
                    ),
                    horizontalSpace30,
//                    / Car Color *****
                    Expanded(
                      child: PrimaryDropDown(
                        globalKey: colorKey,
                        title: LocaleKeys.color.tr(),
                        hint: fnolBloc?.selectedCar?.color.toString() ?? '',
                        validatorText: 'please select color',
                        items: CarColors.values
                            .map((e) => (isArabic ? e.nameAr : e.nameEn))
                            .toList(),

                        ///texteditfield ya omar
                        isEnabled: false,
                        controller: TextEditingController(),
                      ),
                    ),
                  ],
                ),
                verticalSpace10,

                // Car Chassis Number ================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.vinNumber.tr(),
                      style: TextStyles.bold14,
                    ),
                    verticalSpace8,
                    PrimaryFormField(
                      validationError: '',
                      //  initialValue: fnolBloc?.selectedCar?.vinNumber,

                      controller: TextEditingController(
                        text: fnolBloc?.selectedCar?.vinNumber,
                      ),
                      label: '',
                      enabled: false,
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
                    /*BlocProvider(
                      create: (context) => MyCarsBloc(),
                      child: CarPlateNumber(
                          confirmData: true, myCarModel: fnolBloc?.selectedCar),
                    ),*/
                    Container(
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
                                  style: TextStyles.bold14
                                      .copyWith(color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  'EGYPT',
                                  style: TextStyles.bold14
                                      .copyWith(color: Colors.white),
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
                                    isEnabled: false,
                                    controller:
                                        fnolBloc?.policyCarFirstCharController,
                                    globalKey: fnolBloc!.carFirstCharKey,
                                    title: '',
                                    hint: fnolBloc?.policyCarFirstCharController
                                            .text ??
                                        '',
                                    items: arabicLetters.toList(),
                                    onSelect: (v) {
                                      fnolBloc?.selectedCarFirstChar = v!;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 60.rSp,
                                    child: PrimaryDropDown(
                                      isEnabled: false,
                                      controller: fnolBloc
                                          ?.policyCarSecondCharController,
                                      globalKey: fnolBloc!.carSecondCharKey,
                                      title: '',
                                      hint: fnolBloc
                                              ?.policyCarSecondCharController
                                              .text ??
                                          '',
                                      items: arabicLetters.toList(),
                                      onSelect: (v) {
                                        fnolBloc?.selectedCarFirstChar = v!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60.rSp,
                                  child: PrimaryDropDown(
                                    isEnabled: false,
                                    controller:
                                        fnolBloc?.policyCarThirdCharController,
                                    globalKey: fnolBloc!.carThirdCharKey,
                                    title: '',
                                    hint: fnolBloc?.policyCarThirdCharController
                                            .text ??
                                        '',
                                    items: arabicLetters.toList(),
                                    onSelect: (v) {
                                      fnolBloc?.selectedCarFirstChar = v!;
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
                                      enabled: false,
                                      controller: fnolBloc
                                          ?.policyCarPlateNumberController,
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
                    )
                  ],
                ),
                verticalSpace16,

                // Insurance Company and Policy Number =====
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
                            controller: TextEditingController(
                                text: fnolBloc
                                    ?.selectedCar?.insuranceCompany?.arName),
                            label: '',
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
                                text: fnolBloc?.selectedCar?.policyNumber),
                            label: '',
                            enabled: fnolBloc?.selectedCar?.policyNumber ==
                                        null ||
                                    fnolBloc?.selectedCar?.policyNumber == ""
                                ? true
                                : false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Accident Types =====
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            LocaleKeys.accidentType.tr(),
                            style: TextStyles.bold14,
                          ),
                          verticalSpace8,
                          Container(
                            width: double.infinity,
                            //height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    fnolBloc!.selectedAccidentTypes.map((type) {
                                  return Text(
                                    type.arName ?? '',
                                    style: TextStyles.medium14.copyWith(
                                      color: ColorsManager.darkerGreyColor,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Accident Location =====
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            LocaleKeys.accidentLocation.tr(),
                            style: TextStyles.bold14,
                          ),
                          verticalSpace8,
                          PrimaryFormField(
                            validationError: '',
                            controller: TextEditingController(
                                text: fnolBloc?.currentAddress),
                            label: '',
                            prefixIcon: LoadAssetImage(
                              image: AssetsImages.pin,
                              height: 5,
                              fit: BoxFit.contain,
                              color: ColorsManager.mainColor,
                            ),
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpace8,
                PrimaryButton(
                  isLoading: state is CreateFnolLoading,
                  text: LocaleKeys.confirm.tr(),
                  onPressed: () async {
                    fnolBloc?.currentImageIndex = 0;
                    fnolBloc?.getRequiredImagesTags();
                    fnolBloc?.isSupplementShot = false;
                    fnolBloc?.createFnol();
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
}
