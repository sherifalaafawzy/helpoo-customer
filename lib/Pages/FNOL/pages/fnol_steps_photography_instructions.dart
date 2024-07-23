

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
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


class FNOLStepsPhotographyInstructions extends StatefulWidget {
  const FNOLStepsPhotographyInstructions({Key? key}) : super(key: key);

  @override
  State<FNOLStepsPhotographyInstructions> createState() => _FNOLStepsPhotographyInstructionsState();
}

class _FNOLStepsPhotographyInstructionsState extends State<FNOLStepsPhotographyInstructions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      appBarTitle: LocaleKeys.shotInstructionshead.tr(),
      body: BlocConsumer<FnolBloc, FnolState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: AnimatedContainer(
              duration: duration500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.shootInspectionNotes.tr(),
                    style: TextStyles.bold20,
                  ),
                  verticalSpace32,
                  const Center(
                    child: LoadAssetImage(
                      image: AssetsImages.mobile,
                      height: 180,
                      width: 180,
                    ),
                  ),
                  verticalSpace32,
                  Container(
                    padding: EdgeInsets.all(10.rSp),
                    decoration: BoxDecoration(
                      color: ColorsManager.darkGreyColor,
                      boxShadow: primaryShadow,
                      borderRadius: 15.rSp.br,
                    ),
                    child: Column(
                      children: [
                        ...List.generate(3, (index) {
                          List<String> list = isArabic ? documentsShootInstructionsAr : documentsShootInstructionsEn;
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
                        verticalSpace18,
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: LocaleKeys.startShoot.tr(),
                                textStyle: TextStyles.bold14.copyWith(
                                  color: ColorsManager.white,
                                ),
                                radius: 25.rSp,
                                height: 45.rSp,
                                onPressed: () {},
                              ),
                            ),
                            horizontalSpace18,
                            Expanded(
                              child: PrimaryButton(
                                text: LocaleKeys.gallery.tr(),
                                textStyle: TextStyles.bold14.copyWith(
                                  color: ColorsManager.white,
                                ),
                                radius: 25.rSp,
                                height: 45.rSp,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        verticalSpace18,
                        PrimaryButton(
                          text: LocaleKeys.noInspectionNow.tr(),
                          backgroundColor: ColorsManager.brownColor,
                          textStyle: TextStyles.bold14.copyWith(
                            color: ColorsManager.white,
                          ),
                          radius: 25.rSp,
                          height: 45.rSp,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  verticalSpace12,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
