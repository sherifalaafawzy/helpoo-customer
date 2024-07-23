import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:helpooappclient/Widgets/primary_divider_text.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/spacing.dart';
import '../ChooseLanguage/choose_language_bloc.dart';
import '../Main/main_bloc.dart';
import 'settings_screen_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey localizationKey = GlobalKey();
  ChooseLanguageBloc? _languageBloc;
  SettingsScreenBloc? _settingBloc;
  MainBloc? _mainBloc;

  @override
  void initState() {
    super.initState();
    _languageBloc = context.read<ChooseLanguageBloc>();
    _languageBloc?.chooseLanguageBloc = _languageBloc;
    _settingBloc = context.read<SettingsScreenBloc>();
    _mainBloc = context.read<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsScreenBloc, SettingsScreenState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          context.pushNamedAndRemoveUntil(PageRouteName.welcomeScreen);
          HelpooInAppNotification.showSuccessMessage(
              message: LocaleKeys.logoutSuccess.tr());
        }
      },
      builder: (_, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.rSp,
            vertical: 10.rSp,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => context.pop, icon: Icon(Icons.clear)),
                ],
              ),
              Text(LocaleKeys.setting.tr(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              verticalSpace20,
              PrimaryButton(
                text: 'عربي',
                onPressed: () {
                  _mainBloc!
                      .add(SetLanguageEvent(locale: const Locale('ar', 'EG')));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PageRouteName.mainScreen, (route) => false);
                },
              ),
              verticalSpace16,
              PrimaryButton(
                text: 'English',
                onPressed: () {
                  _mainBloc
                      ?.add(SetLanguageEvent(locale: const Locale('en', 'US')));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PageRouteName.mainScreen, (route) => false);
                },
              ),
              verticalSpace16,
              PrimaryDividerText(text: '   -   '),
              verticalSpace16,
              PrimaryButton(
                text: LocaleKeys.logOut.tr(),
                isLoading: state is LogoutLoadingState,
                onPressed: () {
                  _settingBloc?.add(LogoutSettingsScreenButton());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
