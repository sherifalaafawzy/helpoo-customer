import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../../Home/home_bloc.dart';
import '../fnol_bloc.dart';
import '../widgets/voiceInputWidget.dart';
import 'upload_fnol_files_page.dart';

class FnolCommentPage extends StatefulWidget {
  FnolCommentPage({Key? key, required this.fnolBloc}) : super(key: key);
  FnolBloc? fnolBloc;

  @override
  State<FnolCommentPage> createState() => _FnolCommentPagePageState();
}

class _FnolCommentPagePageState extends State<FnolCommentPage> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    fnolBloc = widget.fnolBloc;
    fnolBloc?.fnolCommentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: ScaffoldWithBackground(
        withBack: false,
        alignment: AlignmentDirectional.topStart,
        extendBodyBehindAppBar: false,
        verticalPadding: 0,
        appBarTitle: LocaleKeys.shotInstructionshead.tr(),
        body: BlocConsumer<FnolBloc, FnolState>(
          listener: (context, state) {
            if (state is UpdateFnolCommentAndVoiceStart) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: fnolBloc!,
                      ),
                    ],
                    child: UploadFNOLFilesPage(
                      fnolBloc: fnolBloc,
                    ),
                  ),
                ),
              );
              /*NavigationService.navigatorKey.currentContext!
                  .pushNamedAndRemoveUntil(PageRouteName.uploadFNOLFilesPage);*/
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
                      LocaleKeys.fnolVoice.tr(),
                      style: TextStyles.bold20,
                    ),
                    verticalSpace10,
                    Text(
                      LocaleKeys.voiceNote.tr(),
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
                          height: 200,
                        ),
                      ),
                    ),
                    verticalSpace20,
                    Center(
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          controller: fnolBloc?.fnolCommentCtrl,
                          maxLines: 5,
                          onChanged: (value) {
                            fnolBloc?.fnolModel?.comment = value;
                          },
                          onSubmitted: (value) {
                            fnolBloc?.fnolModel?.comment = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'type_your_comment'.tr(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 200,
                        child: BlocProvider.value(
                          value: fnolBloc!,
                          child: voiceInputWidget(fnolBloc: fnolBloc),
                        )),
                    verticalSpace12,
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavBar: BlocConsumer<FnolBloc, FnolState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: EdgeInsetsDirectional.only(
                  bottom: 20, start: 20, end: 20, top: 8),
              child: PrimaryButton(
                text: LocaleKeys.next.tr(),
                isLoading: state is UpdateFnolCommentAndVoiceLoading,
                onPressed: () async {
                  if (fnolBloc?.mediaController.audioFilePath != null ||
                      (fnolBloc?.fnolCommentCtrl.text.isNotEmpty ?? false)) {
                    fnolBloc?.uploadFnolCommentAndVoice(fnolBloc, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: fnolBloc!,
                              ),
                            ],
                            child: UploadFNOLFilesPage(
                              fnolBloc: fnolBloc,
                            ),
                          ),
                        ),
                      );
                    });
                  } else {
                    HelpooInAppNotification.showErrorMessage(
                      message: LocaleKeys.voiceError.tr(),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
