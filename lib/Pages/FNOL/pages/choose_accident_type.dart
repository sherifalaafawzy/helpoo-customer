import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';
import '../../../Configurations/Constants/enums.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

import '../fnol_bloc.dart';
import '../widgets/accident_button.dart';

import '../widgets/main_scaffold.dart';

class ChooseAccidentType extends StatefulWidget {
  const ChooseAccidentType({super.key});

  @override
  State<ChooseAccidentType> createState() => _ChooseAccidentTypeState();
}

class _ChooseAccidentTypeState extends State<ChooseAccidentType> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    fnolBloc = context.read<FnolBloc>();
    fnolBloc?.add(InitialFNOLEvent(context: context));
    fnolBloc?.selectedAccidentTypes.clear();
    fnolBloc?.getAllAccidentTypes();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      scaffold: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 30,
        ),
        body: SafeArea(
          child: BlocConsumer<FnolBloc, FnolState>(
            listener: (context, state) {
              if (state is FnolInitial) {
                setState(() {});
              } else if (state is GetLocationFnolDone) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                          value: fnolBloc!,
                          child: FnolConfirmaionPage(
                            fnolBloc: fnolBloc,
                          ),
                        ),
                    settings: RouteSettings(arguments: {
                      "MyCarModel": ModalRoute.of(context)!.settings.arguments
                          as MyCarModel,
                      "selectedAccidentTypes": fnolBloc?.selectedAccidentTypes,
                    })));
              }
            },
            builder: (context, state) {
              if (state is GetAllAccidentTypesLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 85),
                        child: SizedBox(
                          //  height: 300.rh,

                          height: 300,
                          child: Image.asset('assets/images/fnol_car.png',
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              LocaleKeys.accidentType.tr(),
                              style: TextStyles.bold22
                                  .copyWith(color: ColorsManager.black),
                            ),
                          ],
                        ),
                        verticalSpace2,
                        Row(
                          children: [
                            Text(
                              LocaleKeys.chooseAccident.tr(),
                              style: TextStyles.medium15
                                  .copyWith(color: ColorsManager.black),
                            ),
                          ],
                        ),
                        verticalSpace10,
                        Column(
                          children: [
                            AccidentButton(
                              title: LocaleKeys.frontAccident.tr(),
                              onChanged: (value) {
                                fnolBloc?.addAccidentType(
                                    accidentType: AccidentType.frontAccident);
                              },
                              isSelected:
                                  fnolBloc?.isAllCarAccidentSelected ?? false
                                      ? true
                                      : fnolBloc?.isAccidentSelected(
                                              accidentType:
                                                  AccidentType.frontAccident) ??
                                          false,
                            ),
                            verticalSpace5,
                            AccidentButton(
                              title: LocaleKeys.frontGlass.tr(),
                              onChanged: (value) {
                                fnolBloc?.addAccidentType(
                                    accidentType:
                                        AccidentType.frontClassAccident);
                              },
                              isSelected:
                                  fnolBloc?.isAllCarAccidentSelected ?? false
                                      ? true
                                      : fnolBloc?.isAccidentSelected(
                                              accidentType: AccidentType
                                                  .frontClassAccident) ??
                                          false,
                            ),
                          ],
                        ),
                        verticalSpace10,
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RotatedBox(
                                quarterTurns: 1,
                                child: AccidentButton(
                                  title: LocaleKeys.rightAccident.tr(),
                                  onChanged: (value) {
                                    fnolBloc?.addAccidentType(
                                        accidentType:
                                            AccidentType.rightSideAccident);
                                  },
                                  isSelected:
                                      fnolBloc?.isAllCarAccidentSelected ??
                                              false
                                          ? true
                                          : fnolBloc?.isAccidentSelected(
                                                  accidentType: AccidentType
                                                      .rightSideAccident) ??
                                              false,
                                ),
                              ),
                              RotatedBox(
                                quarterTurns: 1,
                                child: AccidentButton(
                                  title: LocaleKeys.leftAccident.tr(),
                                  onChanged: (value) {
                                    fnolBloc?.addAccidentType(
                                        accidentType:
                                            AccidentType.leftSideAccident);
                                  },
                                  isSelected:
                                      fnolBloc?.isAllCarAccidentSelected ??
                                              false
                                          ? true
                                          : fnolBloc?.isAccidentSelected(
                                                  accidentType: AccidentType
                                                      .leftSideAccident) ??
                                              false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace8,
                        RotatedBox(
                          quarterTurns: 0,
                          child: AccidentButton(
                            title: LocaleKeys.carRoof.tr(),
                            onChanged: (value) {
                              fnolBloc?.addAccidentType(
                                  accidentType: AccidentType.carRoofAccident);
                            },
                            isSelected:
                                fnolBloc?.isAllCarAccidentSelected ?? false
                                    ? true
                                    : fnolBloc?.isAccidentSelected(
                                            accidentType:
                                                AccidentType.carRoofAccident) ??
                                        false,
                          ),
                        ),
                        verticalSpace30,
                        Center(
                          child: AccidentButton(
                            title: LocaleKeys.rearGlass.tr(),
                            onChanged: (value) {
                              fnolBloc?.addAccidentType(
                                  accidentType: AccidentType.backClassAccident);
                            },
                            isSelected: fnolBloc?.isAllCarAccidentSelected ??
                                    false
                                ? true
                                : fnolBloc?.isAccidentSelected(
                                        accidentType:
                                            AccidentType.backClassAccident) ??
                                    false,
                          ),
                        ),

                        ///  verticalSpace5,
                        verticalSpace5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AccidentButton(
                              title: LocaleKeys.rearAccident.tr(),
                              onChanged: (value) {
                                fnolBloc?.addAccidentType(
                                    accidentType: AccidentType.backAccident);
                              },
                              isSelected:
                                  fnolBloc?.isAllCarAccidentSelected ?? false
                                      ? true
                                      : fnolBloc?.isAccidentSelected(
                                              accidentType:
                                                  AccidentType.backAccident) ??
                                          false,
                            ),
                          ],
                        ),
                        // verticalSpace5,

                        Expanded(
                          child: Center(
                            child: AccidentButton(
                              title: LocaleKeys.fullAccident.tr(),
                              isInfinityWidth: true,
                              onChanged: (value) {
                                fnolBloc?.addAccidentType(
                                    accidentType: AccidentType.allCarAccident);
                              },
                              isSelected:
                                  fnolBloc?.isAllCarAccidentSelected ?? false,
                            ),
                          ),
                        ),
                        verticalSpace10,
                        PrimaryButton(
                            text: LocaleKeys.next.tr(),
                            isLoading: state is GetLocationFnolLoadingState,
                            onPressed: () async {
                              if (fnolBloc?.selectedAccidentTypes.isNotEmpty ??
                                  false) {
                                bool? serviceEnabled =
                                    await fnolBloc?.location.serviceEnabled();
                                if (serviceEnabled ?? false) {
                                  await fnolBloc
                                      ?.getForceLocation()
                                      .then((value) async {
                                    if (value == null) {
                                      HelpooInAppNotification.showErrorMessage(
                                          message: LocaleKeys
                                              .pleaseAllowLocationToContinue
                                              .tr());
                                    }
                                  });
                                } else {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: LocaleKeys
                                          .pleaseAllowLocationToContinue
                                          .tr());
                                  await fnolBloc?.location
                                      .requestService()
                                      .then((valueRequestLocation) async {
                                    serviceEnabled = await fnolBloc!.location
                                        .serviceEnabled();
                                    await fnolBloc
                                        ?.getForceLocation()
                                        .then((value) async {
                                      if (value == null) {
                                        HelpooInAppNotification.showErrorMessage(
                                            message: LocaleKeys
                                                .pleaseAllowLocationToContinue
                                                .tr());
                                      }
                                    });
                                  });
                                }
                              } else {
                                HelpooInAppNotification.showErrorMessage(
                                    message:
                                        LocaleKeys.accidentTyperequired.tr());
                              }
                            }),
                        verticalSpace5,
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
