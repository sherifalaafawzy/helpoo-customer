import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/FNOL/pages/shooting.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../fnol_bloc.dart';

class PhotographyInstructionsPage extends StatefulWidget {
   PhotographyInstructionsPage({Key? key,required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<PhotographyInstructionsPage> createState() =>
      _PhotographyInstructionsPageState();
}

class _PhotographyInstructionsPageState
    extends State<PhotographyInstructionsPage> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    fnolBloc = widget.fnolBloc;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ScaffoldWithBackground(
        withBack: false,
        alignment: AlignmentDirectional.topStart,
        extendBodyBehindAppBar: false,
        verticalPadding: 0,
        appBarTitle: LocaleKeys.shotNotes.tr(),
        onBackTab: () {
          Navigator.pop(context);
        },
        body: BlocConsumer<FnolBloc, FnolState>(
          listener: (context, state) {
            if (state is CameraInitialized) {
              ///   context.pushNamedAndRemoveUntil(PageRouteName.shooting);
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
            return SingleChildScrollView(
              child: AnimatedContainer(
                duration: duration500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.shotInstructionshead.tr(),
                      style: TextStyles.bold20,
                    ),
                    verticalSpace10,
                    Text(
                      LocaleKeys.additionalShotInstructionsTitle2.tr(),
                      style: TextStyles.regular14,
                    ),
                    verticalSpace20,
                    Center(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: 30.rw,
                        ),
                        child: const LoadAssetImage(
                          image: AssetsImages.greenCar,
                          height: 300,
                        ),
                      ),
                    ),
                    verticalSpace20,
                    ...List.generate(3, (index) {
                      List<String> list = isArabic
                          ? shootingInstructionsAr
                          : shootingInstructionsEn;
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
                    verticalSpace12,
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavBar: Padding(
          padding: const EdgeInsetsDirectional.only(
              bottom: 20, start: 20, end: 20, top: 8),
          child: PrimaryButton(
            text: LocaleKeys.next.tr(),
            onPressed: () {
              fnolBloc?.initCameraController();
            },
          ),
        ),
      ),
    );
  }
}
