import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

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
import '../fnol_bloc.dart';

class AccidentDescription extends StatefulWidget {
  const AccidentDescription({Key? key}) : super(key: key);

  @override
  State<AccidentDescription> createState() => _AccidentDescriptionState();
}

class _AccidentDescriptionState extends State<AccidentDescription> {
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
      appBarTitle: LocaleKeys.accidentDescription.tr(),
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
                    LocaleKeys.fnolVoice.tr(),
                    style: TextStyles.bold20,
                  ),
                  verticalSpace10,
                  Text(
                    LocaleKeys.voiceError.tr(),
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
                  PrimaryFormField(
                    validationError: '',
                    hint: LocaleKeys.addAccidentDescription.tr(),
                    label: LocaleKeys.accidentDescription.tr(),
                    infiniteLines: true,
                    controller: TextEditingController(),
                  ),
                  verticalSpace10,
                  Center(
                    child: Text(
                      LocaleKeys.fnolVoice.tr(),
                      style: TextStyles.medium14.copyWith(
                        color: ColorsManager.gray60,
                      ),
                    ),
                  ),
                  verticalSpace10,
                  // TODO : Add Audio Player
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
          onPressed: () {},
        ),
      ),
    );
  }
}
