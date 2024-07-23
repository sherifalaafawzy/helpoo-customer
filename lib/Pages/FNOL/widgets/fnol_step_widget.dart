import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/FNOL/pages/bill_request.dart';
import 'package:helpooappclient/Services/navigation_service.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/enums.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';

class FNOLStepWidget extends StatelessWidget {
  final String title;
  final List<Map<String, FNOLSteps>> steps;
  final FnolBloc? fnolBloc;

  const FNOLStepWidget(
      {super.key,
      required this.title,
      required this.steps,
      required this.fnolBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.gray20,
        borderRadius: 14.rSp.br,
        boxShadow: primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.bold20.copyWith(
              color: ColorsManager.mainColor,
            ),
          ),
          ...List.generate(
            steps.length,
            (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index != steps.length ? 8 : 0),
                child: Row(
                  children: [
                    const LoadSvg(
                      image: AssetsImages.iIcon,
                      isIcon: true,
                      height: 20,
                    ),
                    horizontalSpace3,
                    Expanded(
                      child: Text(
                        steps[index].keys.first,
                        style: TextStyles.bold12,
                      ),
                    ),
                    PrimaryButton(
                      text: steps[index].values.first.isPoliceReport ||
                              steps[index].values.first.isBilling
                          ? LocaleKeys.add.tr()
                          : LocaleKeys.request.tr(),
                      textStyle: TextStyles.medium14
                          .copyWith(color: ColorsManager.white),
                      height: 40.rh,
                      width: 100.rw,
                      onPressed: handleOnPress(
                          step: steps[index].values.first,
                          context: context,
                          fnolBloc: fnolBloc!),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Function() handleOnPress(
      {required FNOLSteps step,
      required BuildContext context,
      required FnolBloc fnolBloc}) {
    switch (step) {
      case FNOLSteps.policeReport:
        return () {
          showPrimaryDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.policeReport.tr(),
              content: LocaleKeys.policeReportDetails.tr(),
              buttonTitle: LocaleKeys.okay.tr(), onPressed: () {
             fnolBloc.currentFnolStep = FNOLSteps.policeReport;
             Navigator.of(context).push(
                 MaterialPageRoute(
                   builder: (context) => BlocProvider.value(
                     value: fnolBloc,
                     child: FNOLStepAskShoot(
                       fnolBloc: fnolBloc,
                     ),
                   ),
                 ),
             );
    /*        NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLStepAskShoot);*/
          });
        };
      case FNOLSteps.bRepair:
        return () {
          showFnolStepAskDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.beforeRepairAsk.tr(), onPressed: () {
             fnolBloc.currentFnolStep = FNOLSteps.bRepair;
             Navigator.of(context).push(
                 MaterialPageRoute(
                   builder: (context) => BlocProvider.value(
                     value: fnolBloc,
                     child: FNOLStepAskShoot(
                       fnolBloc: fnolBloc,
                     ),
                   ),
                 ),
             );
       /*     NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLStepAskShoot);*/
          });
        };
      case FNOLSteps.supplement:
        return () {
          showFnolStepAskDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.supplementAskAdditionalAttach.tr(), onPressed: () {
                fnolBloc.currentFnolStep = FNOLSteps.supplement;
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: fnolBloc,
                        child: FNOLStepAskShoot(
                          fnolBloc: fnolBloc,
                        ),
                      ),
                    ),
                       );
         /*   NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLStepAskShoot);*/
          });
        };
      case FNOLSteps.resurvey:
        return () {
          showFnolStepAskDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.supplementAskNew.tr(), onPressed: () {
                fnolBloc.currentFnolStep = FNOLSteps.resurvey;
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: fnolBloc,
                        child: FNOLStepAskShoot(
                          fnolBloc: fnolBloc,
                        ),
                      ),
                    ),
                );
           /* NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLStepAskShoot);*/
          });
        };
      case FNOLSteps.aRepair:
        return () {
          showFnolStepAskDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.supplementAsk.tr(), onPressed: () {
                fnolBloc.currentFnolStep = FNOLSteps.aRepair;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value:fnolBloc,
                    child: FNOLMapPage(fnolBloc: fnolBloc,fnolModel: fnolBloc.fnolModel),
                  ),
                ));
           /* NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLMapPage);*/
          });
        };
      case FNOLSteps.rightSave:
        return () {
          showFnolStepAskDialog(NavigationService.navigatorKey.currentContext!,
              title: LocaleKeys.supplementAsk.tr(), onPressed: () {
                fnolBloc.currentFnolStep = FNOLSteps.rightSave;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value:fnolBloc,
                    child: FNOLMapPage(fnolBloc: fnolBloc,fnolModel: fnolBloc.fnolModel),
                  ),
                ));
            /*NavigationService.navigatorKey.currentContext!
                .pushNamed(PageRouteName.fNOLMapPage);*/
          });
        };
      case FNOLSteps.billing:
        return () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: fnolBloc,
                child: BillRequest(
                  fnolBloc: fnolBloc,
                  fnolModel: fnolBloc.fnolModel,
                )),
          ));
          /*     NavigationService.navigatorKey.currentContext!.pushNamed(
              PageRouteName.requestFnolBillPage);
     */
        };
      default:
        return () {};
    }
  }
}
