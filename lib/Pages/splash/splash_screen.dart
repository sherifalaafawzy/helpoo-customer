import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Configurations/Constants/assets_images.dart';
import '../../Widgets/animations/fade_animation.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/load_svg.dart';
import '../Packages/Widgets/utils.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc? _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = context.read<SplashBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _splashBloc?.add(GetLanguageEvent(context: context));
      _splashBloc?.add(GetConfigEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    /* This is to load the background image during the splash screen
     to prevent black screen in service request page */
    precacheImage(AssetImage(AssetsImages.backgroundLight), context);
    return BlocProvider(
      create: (context) => _splashBloc!,
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          print(state);

          if (_splashBloc!.config != null) {
            if (_splashBloc!.config?.underMaintaining ?? false) {
              Utils.showUpdateDialog(
                  NavigationService.navigatorKey.currentContext!,
                  isUnderMaintenance: true);
            } else {
              if (Platform.isAndroid) {
                PackageInfo.fromPlatform().then(
                  (deviceInfo) {
                    print('Android version is => ${deviceInfo.version}');
                    print(
                        'minAndroidVersion is => ${_splashBloc!.config?.minimumAndroidVersion}');
                    if (Utils.checkAndroidVersionUpdate(
                        appVersionNum: deviceInfo.version,
                        minAndroidVersionApp:
                            _splashBloc!.config?.minimumAndroidVersion ??
                                '0')) {
                      Utils.showUpdateDialog(
                          NavigationService.navigatorKey.currentContext!);
                    } else {
                      ///  startAppFlow();
                      if (state is NoLanguageState) {
                        _splashBloc
                            ?.add(NavigateToLanguageEvent(context: context));
                      } else if (state is LanguageExistsState) {
                        _splashBloc?.add(GetTokenEvent());
                      } else if (state is NoTokenState) {
                        _splashBloc
                            ?.add(NavigateToWelcomeEvent(context: context));
                      } else if (state is TokenExistsState) {
                        _splashBloc?.add(NavigateToHomeEvent(context: context));
                      }
                    }
                  },
                );
              } else if (Platform.isIOS) {
                PackageInfo.fromPlatform().then(
                  (deviceInfo) {
                    print('IOS version is ${deviceInfo.version}');
                    print(
                        'minIOSVersion is => ${_splashBloc!.config?.minimumIOSVersion}');
                    if (Utils.checkIosVersionUpdate(
                        appVersionNum: deviceInfo.version,
                        minIosVersionApp:
                            _splashBloc!.config?.minimumIOSVersion ?? '0')) {
                      Utils.showUpdateDialog(
                          NavigationService.navigatorKey.currentContext!);
                    } else {
                      /// startAppFlow();
                      if (state is NoLanguageState) {
                        _splashBloc
                            ?.add(NavigateToLanguageEvent(context: context));
                      } else if (state is LanguageExistsState) {
                        _splashBloc?.add(GetTokenEvent());
                      } else if (state is NoTokenState) {
                        _splashBloc
                            ?.add(NavigateToWelcomeEvent(context: context));
                      } else if (state is TokenExistsState) {
                        _splashBloc?.add(NavigateToHomeEvent(context: context));
                      }
                    }
                  },
                );
              } else {
                HelpooInAppNotification.showErrorMessage(
                    message: 'Unknown device');
              }
            }
          }
          /* // TODO: implement listener
          if (state is TokenExistsState) {
            //navigate to home page with state.token
         //   _splashBloc?.add(NavigateToHomeEvent(context: context));
            _splashBloc?.add(GetRemoteConfigDataEvent());
          } else if (state is NoTokenState) {
          //  _splashBloc?.add(NavigateToHomeEvent(context: context));
            _splashBloc?.add(GetRemoteConfigDataEvent());
          } else if (state is NoLanguageState) {
           // _splashBloc?.add(NavigateToHomeEvent(context: context));
            _splashBloc?.add(GetRemoteConfigDataEvent());
          } else if (state is LanguageExistsState) {
            _splashBloc?.add(GetTokenEvent());
           // _splashBloc?.add(GetRemoteConfigDataEvent());
          }else if(state is RemoteConfigDataSuccessState){
            _splashBloc?.add(CheckVersionEvent(appConfigurationsModel: state.appConfigurationsModel!,context: context));
          }else if(state is ForceUpdateState){
            _splashBloc?.add(NavigateToForceUpdateEvent(context: context));
          }*/
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [
                LoadSvg(
                  width: double.infinity,
                  image: AssetsImages.splash,
                  fit: BoxFit.fill,
                ),
                FadeAnimation(
                  delay: 2,
                  child: LoadSvg(
                    image: AssetsImages.logo,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
