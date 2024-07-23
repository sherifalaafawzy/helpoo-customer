import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/FNOL/pages/additional_photography_instructions_page.dart';
import 'package:helpooappclient/Pages/FNOL/pages/shooting.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/enums.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../fnol_bloc.dart';
import 'fnolComment.dart';

class AdditionalAskShoot extends StatefulWidget {
  AdditionalAskShoot({Key? key, required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<AdditionalAskShoot> createState() => _AdditionalAskShootState();
}

class _AdditionalAskShootState extends State<AdditionalAskShoot> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    //  fnolBloc = context.read<FnolBloc>();
    fnolBloc?.cameraController?.dispose();
    fnolBloc?.isAskAdditionalAppear=true;
    fnolBloc = widget.fnolBloc;
    if (fnolBloc?.flashMode == FlashMode.torch) {
      fnolBloc?.flashMode = FlashMode.off;
    }

    fnolBloc?.add(InitialFNOLEvent(context: context));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: BlocConsumer<FnolBloc, FnolState>(
        listener: (context, state) async {
          await fnolBloc?.turnOffFlash();
//        await widget.fnolBloc?.cameraController.dispose();
          if (state is CameraInitialized) {
              fnolBloc?.isFnolAdditional = true;
              fnolBloc?.isSupplementShot = true;
              fnolBloc?.isAllImagesCaptured = false;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                  value: fnolBloc!,
                  child: Shooting(
                    controller: fnolBloc!.cameraController,
                  )),
            ));
          }
        },
        builder: (context, state) {
          return ScaffoldWithBackground(
            alignment: AlignmentDirectional.topStart,
            extendBodyBehindAppBar: false,
            verticalPadding: 0,
            withBack: false,
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
                            Text(
                              LocaleKeys.additionalShootAsk.tr(),
                              style: TextStyles.bold14,
                            ),
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
                                    print('ddjdjk');
                                    fnolBloc?.currentFnolStep =
                                        FNOLSteps.additional;
                                    fnolBloc?.isFnolAdditional = true;
                                    fnolBloc?.isSupplementShot = true;
                                    fnolBloc?.isAllImagesCaptured = false;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider.value(
                                          value: fnolBloc!,
                                          child: AdditionalInstructionsPage(
                                              fnolBloc: fnolBloc),
                                        ),
                                      ),
                                    );
//                                  fnolBloc?.initCameraController();
                                  },
                                ),
                                PrimaryButton(
                                  text: LocaleKeys.no.tr(),
                                  textStyle: TextStyles.medium13.copyWith(
                                    color: Colors.white,
                                  ),
                                  width: 150.rw,
                                  height: 48.rh,
                                  onPressed: () async {
                                    await fnolBloc?.cameraController?.dispose();
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: fnolBloc!,
                                        child:
                                            FnolCommentPage(fnolBloc: fnolBloc!),
                                      ),
                                    ));
                                    /* context.pushNamedAndRemoveUntil(
                                        PageRouteName.fnolCommentPage,);*/
                                  },
                                ),
                              ],
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
      ),
    );
  }
}
