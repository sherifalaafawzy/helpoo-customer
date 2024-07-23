import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/FNOL/pages/shooting.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/fnol/accident_report_details_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

import '../../../main.dart';
import '../fnol_bloc.dart';
import '../widgets/fnolStepDone.dart';
import 'fnol_map_page.dart';
import 'fnol_steps.dart';

class FNOLStepAskShoot extends StatefulWidget {
  FNOLStepAskShoot({Key? key, required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<FNOLStepAskShoot> createState() => _FNOLStepAskShootState();
}

class _FNOLStepAskShootState extends State<FNOLStepAskShoot> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    //fnolBloc = context.read<FnolBloc>();
    fnolBloc = widget.fnolBloc;
    print('test fnol model ${fnolBloc?.fnolModel?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is CameraInitialized) {
          fnolBloc?.isSupplementShot = true;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: fnolBloc!,
                child: Shooting(
                  controller: fnolBloc!.cameraController,
                )),
          ));
          //context.pushNamedAndRemoveUntil(PageRouteName.shooting);
          // } else if (state is UploadImagesSuccess) {
          //   if (fnolBloc?.currentFnolStep!.isPoliceReport) {
          //     showSuccessDialog(
          //       context,
          //       title: LocaleKeys.fnolStepDoneMsg.tr(),
          //       onPressed: () {
          //         context.pop;
          //         Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => BlocProvider(
          //             create: (context) => FnolBloc(),
          //             child: FNOLStepsPage(fnol: widget.fnolBloc?.fnolModel),
          //           ),
          //         ));
          //         // context.pushNamed(PageRouteName.fNOLStepsPage);
          //         // Navigator.of(context).push(MaterialPageRoute(
          //         //   builder: (context) => BlocProvider.value(
          //         //     value: fnolBloc!,
          //         //     child: fnolStepDone(
          //         //       Report(
          //         //         id: fnolBloc!.fnolModel!.id,
          //         //       ),
          //         //       fnolBloc: fnolBloc!,
          //         //       from: widget.fnolBloc!.currentFnolStep!.title,
          //         //     ),
          //         //   ),
          //         // ));
          //         /* Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => BlocProvider(
          //             create: (context) => FnolBloc(),
          //             child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
          //           ),
          //         ));*/
          //       },
          //     );
          //   } else if (fnolBloc?.currentFnolStep!.isBeforeRepair ||
          //       fnolBloc?.currentFnolStep!.isSupplement ||
          //       fnolBloc?.currentFnolStep!.isResurvey) {
          //     if (fnolBloc!.isStillShooting) return;
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => BlocProvider.value(
          //         value: fnolBloc!,
          //         child: FNOLMapPage(
          //             fnolBloc: fnolBloc, fnolModel: fnolBloc?.fnolModel),
          //       ),
          //     ));
          //     // context.pushNamedAndRemoveUntil(PageRouteName.fNOLMapPage);
          //   }
          // }
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          alignment: AlignmentDirectional.topStart,
          extendBodyBehindAppBar: false,
          verticalPadding: 0,
          appBarTitle: LocaleKeys.fnolSteps.tr(),
          body: BlocConsumer<FnolBloc, FnolState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.rw),
                      child: LoadAssetImage(
                        image: AssetsImages.mobile,
                        width: double.infinity,
                        height: 250.rSp,
                      ),
                    ),
                    verticalSpace40,
                    Container(
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
                          ...List.generate(3, (index) {
                            List<String> list = isArabic
                                ? documentsShootInstructionsAr
                                : documentsShootInstructionsEn;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: ColorsManager.mainColor,
                                  size: 16,
                                ),
                                horizontalSpace8,
                                Expanded(
                                  child: Text(
                                    list[index],
                                    style: TextStyles.bold14,
                                  ),
                                ),
                              ],
                            );
                          }),
                          verticalSpace40,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PrimaryButton(
                                text: LocaleKeys.startShoot.tr(),
                                textStyle: TextStyles.medium13.copyWith(
                                  color: Colors.white,
                                ),
                                width: 150.rw,
                                height: 48.rh,
                                onPressed: () {
                                  fnolBloc?.initCameraController();
                                },
                              ),
                              PrimaryButton(
                                text: LocaleKeys.gallery.tr(),
                                textStyle: TextStyles.medium13.copyWith(
                                  color: Colors.white,
                                ),
                                width: 150.rw,
                                height: 48.rh,
                                onPressed: () async {
                                  fnolBloc?.uploadPhotosFromGallery();
                                },
                              ),
                            ],
                          ),
                          verticalSpace14,
                          Center(
                            child: PrimaryButton(
                              backgroundColor: Colors.black,
                              text: LocaleKeys.later.tr(),
                              textStyle: TextStyles.medium13.copyWith(
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(NavigationService
                                          .navigatorKey.currentContext!)
                                      .size
                                      .width *
                                  .8,
                              height: 48.rh,
                              onPressed: () {
                                // context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepsPage);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => FnolBloc(),
                                    child: FNOLStepsPage(
                                        fnol: fnolBloc?.fnolModel),
                                  ),
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
