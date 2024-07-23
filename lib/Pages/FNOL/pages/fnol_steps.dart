import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';

import '../../../Configurations/Constants/enums.dart';
import '../../../Models/fnol/latestFnolModel.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../fnol_bloc.dart';
import '../widgets/fnol_step_widget.dart';

class FNOLStepsPage extends StatefulWidget {
  FNOLStepsPage({Key? key, required this.fnol}) : super(key: key);
  LatestFnolModel? fnol;

  @override
  State<FNOLStepsPage> createState() => _FNOLStepsPageState();
}

class _FNOLStepsPageState extends State<FNOLStepsPage> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    fnolBloc = context.read<FnolBloc>();
    if (widget.fnol != null) {
      fnolBloc?.fnolModel = widget.fnol;
    }
    fnolBloc?.index = 0;
    fnolBloc?.fnolImagesTaken = 0;
    fnolBloc?.fnolImagesUploaded = 0;
    fnolBloc?.isAllImagesCaptured = false;
    fnolBloc?.isFnolAdditional = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationService.navigatorKey.currentContext!
            .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        return Future.value(false);
      },
      child: ScaffoldWithBackground(
        alignment: AlignmentDirectional.topStart,
        extendBodyBehindAppBar: false,
        verticalPadding: 0,
        onBackTab: () {
          //  fnolBloc?.isHomeScreenRoute = true;

          NavigationService.navigatorKey.currentContext!
              .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        },
        appBarTitle: LocaleKeys.fnolSteps.tr(),
        body: BlocConsumer<FnolBloc, FnolState>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.pleaseChooseNextStep.tr(),
                    style: TextStyles.bold20,
                  ),
                  verticalSpace12,
                  BlocProvider.value(
                    value: fnolBloc!,
                    child: FNOLStepWidget(
                      title: LocaleKeys.policeReport.tr(),
                      fnolBloc: fnolBloc,
                      steps: [
                        {
                          LocaleKeys.fnolPoliceReportItem.tr(): FNOLSteps.policeReport,
                        },
                      ],
                    ),
                  ),
                  verticalSpace12,
                  BlocProvider.value(
                    value: fnolBloc!,
                    child: FNOLStepWidget(
                      fnolBloc: fnolBloc,

                      title: LocaleKeys.beforeRepairInspections.tr(),
                      steps: [
                        {
                          LocaleKeys.fnolBeforeRepairRequest.tr(): FNOLSteps.bRepair,
                        },
                        {
                          LocaleKeys.fnolBeforRepairAdditional.tr(): FNOLSteps.supplement,
                        },
                        {
                          LocaleKeys.fnolBeforeRepairNewRequest.tr(): FNOLSteps.resurvey,
                        },
                      ],
                    ),
                  ),
                  verticalSpace12,
                  BlocProvider.value(
                    value: fnolBloc!,
                    child: FNOLStepWidget(
                      fnolBloc: fnolBloc,

                      title: LocaleKeys.afterRepairInspections.tr(),
                      steps: [
                        {
                          LocaleKeys.fnolAfterRepairRequest.tr(): FNOLSteps.aRepair,
                        },
                        {
                          LocaleKeys.fnolAfterRepairSave.tr(): FNOLSteps.rightSave,
                        },
                      ],
                    ),
                  ),
                  verticalSpace12,
                  BlocProvider.value(
                    value:fnolBloc!,
                    child: FNOLStepWidget(
                      fnolBloc: fnolBloc,

                      title: LocaleKeys.billDeliveryRequest.tr(),
                      steps: [
                        {
                          LocaleKeys.fnolBillRequest.tr(): FNOLSteps.billing,
                        },
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
