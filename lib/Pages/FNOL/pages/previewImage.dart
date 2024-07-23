import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../fnol_bloc.dart';
import 'fnol_steps.dart';

class FnolPreviewImage extends StatefulWidget {
   FnolPreviewImage({Key? key,required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<FnolPreviewImage> createState() => _FnolPreviewImageState();
}

class _FnolPreviewImageState extends State<FnolPreviewImage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {},
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
                        height: 300.rSp,
                      ),
                    ),
                    verticalSpace100,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrimaryButton(
                          text: LocaleKeys.shootAnother.tr(),
                          textStyle: TextStyles.medium13.copyWith(
                            color: Colors.white,
                          ),
                          width: 150.rw,
                          height: 48.rh,
                          onPressed: () {},
                        ),
                        PrimaryButton(
                          text: '',
                          textStyle: TextStyles.medium13.copyWith(
                            color: Colors.white,
                          ),
                          width: 150.rw,
                          height: 48.rh,
                          onPressed: () async {},
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
                        width: 150.rw,
                        height: 48.rh,
                        onPressed: () {
                         // context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepsPage);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => FnolBloc(),
                              child: FNOLStepsPage(fnol: widget.fnolBloc?.fnolModel),
                            ),
                          ));
                        },
                      ),
                    ),
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
