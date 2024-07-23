import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Models/fnol/accident_report_details_model.dart';
import 'package:helpooappclient/Pages/FNOL/widgets/gradient_stepper_fnol_upload_files.dart';
import 'package:helpooappclient/Widgets/custom_form_widget.dart';
import 'package:helpooappclient/Widgets/helpoo_in_app_notifications.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../fnol_bloc.dart';
import '../widgets/fnolStepDone.dart';
import 'fnol_map_page.dart';
import 'fnol_steps.dart';

class UploadFNOLFilesPage extends StatefulWidget {
  UploadFNOLFilesPage({Key? key, required this.fnolBloc}) : super(key: key);
  final FnolBloc? fnolBloc;

  @override
  State<UploadFNOLFilesPage> createState() => _UploadFNOLFilesPageState();
}

class _UploadFNOLFilesPageState extends State<UploadFNOLFilesPage> {
  FnolBloc? fnolBloc;
  Map<String, dynamic>? additionalFieldsData;
  @override
  void initState() {
    //fnolBloc = context.read<FnolBloc>();
    fnolBloc = widget.fnolBloc;
    fnolBloc?.isAllImagesCaptured = false;
    //fnolBloc?.cameraController.dispose();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: BlocProvider.value(
        value: widget.fnolBloc!,
        child: ScaffoldWithBackground(
          withBack: false,
          alignment: AlignmentDirectional.topStart,
          extendBodyBehindAppBar: false,
          verticalPadding: 0,
          appBarTitle: LocaleKeys.filesUpload.tr(),
          body: BlocConsumer<FnolBloc, FnolState>(
            listener: (context, state) async {
              if (state is UpdateFnolAdditionalFieldsSuccess) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => FnolBloc(),
                    child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                  ),
                ));
              }
              if (state is UpdateFnolAdditionalFieldsError) {
                HelpooInAppNotification.showErrorMessage(message: state.error);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    verticalSpace48,
                    const Center(
                      child: LoadAssetImage(
                        image: AssetsImages.files,
                        height: 100,
                      ),
                    ),
                    verticalSpace48,
                    Text(
                      LocaleKeys.fnolMade.tr(),
                      style: TextStyles.bold20,
                    ),
                    Text(
                      LocaleKeys.uploadIsLoading.tr(),
                      style: TextStyles.regular18,
                    ),
                    verticalSpace20,
                    // animated progress bar
                    Center(
                      child: BlocProvider.value(
                        value: fnolBloc!,
                        child: GradientStepperFNOl(
                          fnolBloc: fnolBloc,
                          percentage:
                              //  fnolBloc?.fnolImagesTaken > fnolBloc?.fnolImagesUploaded
                              //     ? 100
                              //     :
                              double.parse((fnolBloc!.fnolImagesUploaded /
                                      fnolBloc!.fnolImagesTaken *
                                      100)
                                  .toString()),
                          height: 70,
                          width: (100.w * 0.95),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: (100.w * 0.95),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.uploadPercentage.tr(),
                                style: TextStyles.bold10.copyWith(
                                  color: ColorsManager.mainColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${fnolBloc?.fnolImagesTaken}/${fnolBloc?.fnolImagesUploaded}',
                                style: TextStyles.bold10.copyWith(
                                  color: ColorsManager.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: 50, start: 20, end: 20, top: 8),
                      child: PrimaryButton(
                        isLoading: fnolBloc!.state is UpdateFnolAdditionalFieldsLoading,
                        text: LocaleKeys.confirm.tr(),
                        onPressed: () async {
                          if (fnolBloc?.currentFnolStep != null) {
                            //  printMe("fnolBloc?.currentFnolStep    " + fnolBloc?.currentFnolStep.toString());
                            if (fnolBloc?.currentFnolStep!.isPoliceReport) {
                              showSuccessDialog(
                                context,
                                title: LocaleKeys.fnolStepDoneMsg.tr(),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => FnolBloc(),
                                      child:
                                      FNOLStepsPage(fnol: widget.fnolBloc?.fnolModel),
                                    ),
                                  ));
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => BlocProvider.value(
                                  //     value: fnolBloc!,
                                  //     child: fnolStepDone(
                                  //       Report(
                                  //         id: fnolBloc!.fnolModel!.id,
                                  //       ),
                                  //       fnolBloc: fnolBloc!,
                                  //       from: widget.fnolBloc!.currentFnolStep!.title,
                                  //     ),
                                  //   ),
                                  // ));
                                  // context.pop;
                                  /* Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => FnolBloc(),
                            child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                          ),
                        ));*/
                                  //  context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepsPage);
                                },
                              );
                            } else if (fnolBloc?.currentFnolStep!.isBeforeRepair ||
                                fnolBloc?.currentFnolStep!.isSupplement ||
                                fnolBloc?.currentFnolStep!.isResurvey) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: fnolBloc!,
                                  child: FNOLMapPage(
                                      fnolBloc: fnolBloc, fnolModel: fnolBloc?.fnolModel),
                                ),
                              ));
                              // context.pushNamedAndRemoveUntil(PageRouteName.fNOLMapPage);
                            } else if (fnolBloc?.currentFnolStep!.isAdditional) {
                              final insuranceCompany =
                                  fnolBloc?.selectedCar?.insuranceCompany;
                              final additionalFields = insuranceCompany?.additionalFields;
                              if (additionalFields?.isNotEmpty == true) {
                                if (additionalFieldsData == null)
                                  additionalFieldsData =
                                  await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CustomFormWidget(
                                      jsonData: additionalFields!,
                                      locale: context.locale,
                                      photoUrl: insuranceCompany?.photo,
                                    ),
                                  ));
                                if (additionalFieldsData != null)
                                  await fnolBloc!
                                      .updateFnolAdditionalFields(additionalFieldsData!);
                              } else
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => FnolBloc(),
                                    child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                                  ),
                                ));
                            }
                          } else {
                            final insuranceCompany =
                                fnolBloc?.selectedCar?.insuranceCompany;
                            final additionalFields = insuranceCompany?.additionalFields;
                            if (additionalFields?.isNotEmpty == true) {
                              if (additionalFieldsData == null)
                                additionalFieldsData =
                                await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CustomFormWidget(
                                    jsonData: additionalFields!,
                                    locale: context.locale,
                                    photoUrl: insuranceCompany?.photo,
                                  ),
                                ));
                              if (additionalFieldsData != null)
                                await fnolBloc!
                                    .updateFnolAdditionalFields(additionalFieldsData!);
                            } else
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => FnolBloc(),
                                  child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                                ),
                              ));
                            //  context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepsPage);
                          }
                        },
                      ),
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
