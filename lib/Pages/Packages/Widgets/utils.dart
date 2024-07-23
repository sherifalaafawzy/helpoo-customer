import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../Configurations/Constants/api_endpoints.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Style/theme/theme.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';

class Utils {
  Utils._();

  ///* Return `true` if the locale is `English en_US`
  static bool get isEnglish => AppTheme.currentLocale == localizeLanguages.last;

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  ///* Open URL in browser
  static Future openUrl(String url) async {
    //printMe(url);
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // printMeLog(e);
    }
  }

  ///* OTP validation
  static RegExp get otpValidation => RegExp(r'^[0-9]+$');

  ///* phone validation
  static RegExp get phoneValidation => RegExp(r'^[0-9]+$');

  ///* Email validation
  static RegExp get emailValidation =>
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  ///* Link validation
  static RegExp get linkValidation => RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}'
      r'(:[0-9]{1,5})?(\/.*)?$');

  ///* handle Phone number
  static String handlePhoneNumber({required String phoneNum}) {
    String phone = phoneNum;
    if (phone.startsWith('0')) {
      phone = phone.replaceFirst('0', '+20');
    } else if (phone.startsWith('2')) {
      phone = '+$phone';
    } else if (phone.startsWith('+')) {
      phone = phone;
    } else {
      phone = phone;
    }
    return phone;
  }

  ///* handle Phone number format
  static String handlePhoneNumberFormat({
    required String phoneNum,
  }) {
    String phone = phoneNum;
    if (phone.startsWith('0')) {
      phone = phone.replaceFirst('0', '+20');
    } else if (phone.startsWith('2')) {
      phone = '+$phone';
    } else if (phone.startsWith('+')) {
      phone = phone;
    } else {
      phone = '+20$phone';
    }
    return phone;
  }

  ///* Change languages
  static void toggleLanguage(
    bool isEnglishvalue,
  ) {
    if (isEnglishvalue) {
      NavigationService.navigatorKey.currentContext!
          .setLocale(localizeLanguages.last);
      isArabic = false;
    } else {
      NavigationService.navigatorKey.currentContext!
          .setLocale(localizeLanguages.first);
      isArabic = true;
    }
    AppTheme.setLocale = NavigationService.navigatorKey.currentContext!.locale;
  }

  ///* Check if the app version need to Update (IOS)
  static bool checkIosVersionUpdate(
      {required String appVersionNum, required String minIosVersionApp}) {
    List<int> appVersionList =
        appVersionNum.split('.').map((e) => int.parse(e)).toList();

    List<int> minIosVersionAppList = minIosVersionApp.split('.').map((e) {
      debugPrint('minIosVersionAppList: $e');
      return int.parse(e);
    }).toList();
    bool needToUpdate = false;
    
    for (var i = 0; i < appVersionList.length; i++) {
      if (minIosVersionAppList[i] > appVersionList[i]) {
        needToUpdate = true;
        break;
      } else if (minIosVersionAppList[i] < appVersionList[i]) {
        break;
      }
    }

    // for (var i = 0; i < appVersionList.length; i++) {
    //   if (appVersionList[i] < minIosVersionAppList[i]) {
    //     needToUpdate = true;
    //     break;
    //   }
    // }
    return needToUpdate;
  }

  ///* Check if the app version need to Update (Android)
  static bool checkAndroidVersionUpdate(
      {required String appVersionNum, required String minAndroidVersionApp}) {
    List<int> appVersionList =
        appVersionNum.split('.').map((e) => int.parse(e)).toList();
    List<int> minAndroidVersionAppList =
        minAndroidVersionApp.split('.').map((e) => int.parse(e)).toList();
    bool needToUpdate = false;

    for (var i = 0; i < appVersionList.length; i++) {
      if (minAndroidVersionAppList[i] > appVersionList[i]) {
        needToUpdate = true;
        break;
      } else if (minAndroidVersionAppList[i] < appVersionList[i]) {
        break;
      }
    }
    return needToUpdate;
  }

  ///* Set status bar to [DARK]
  static get setStatusBarColorToDark => SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      );

  ///* Set status bar to [Light]
  static get setStatusBarColorToLight => SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      );

  ///* show update dialog
  static void showUpdateDialog(
    BuildContext context, {
    bool isUnderMaintenance = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: LoadSvg(
            width: double.infinity,
            image: AssetsImages.logo,
            height: 106.rh,
            fit: BoxFit.fill,
          ),
          content: Text(
            isUnderMaintenance
                ? 'The app is under maintenance. Please Contact the call center'
                : 'A new update is available. Please update the app to enjoy the latest features.',
            textAlign: TextAlign.center,
            style: TextStyles.semiBold16,
          ),
          actions: <Widget>[
            if (isUnderMaintenance) ...[
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse('tel:17000'))) {
                      HelpooInAppNotification.showErrorMessage(
                          message: "Could not Make Call");
                    }
                  },
                  text: 'Call 17000',
                ),
              )
            ] else ...[
              if (Platform.isAndroid) ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Utils.openUrl(
                        "https://play.google.com/store/apps/details?id=com.helpoo.app",
                      );
                    },
                    text: "Update",
                  ),
                )
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Utils.openUrl(
                        "https://apps.apple.com/eg/app/helpoo/id1627316561",
                      );
                    },
                    text: "Update",
                  ),
                )
              ],
            ],
          ],
        );
      },
    );
  }
   void showTermsAndConditions(
    BuildContext context,{required bool accepted ,required Function buttonAction,required Function(bool s) onChanged}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: LoadSvg(
            width: double.infinity,
            image: AssetsImages.logo,
            height: 106.rh,
            fit: BoxFit.fill,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [Icon(Icons.info),SizedBox(width: 5,),
                    Text('Info about packages',
                      textAlign: TextAlign.right,
                      style: TextStyles.semiBold16,
                    ),
                  ],
                ),
                Container(width: MediaQuery.of(context).size.width-10,height: MediaQuery.of(context).size.height-120,child: ListView.builder(itemBuilder:(context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry"),
                ), itemCount: 7,))
              ],
            ),
          ),
          actions: <Widget>[          
            
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text("I have read and accept the subscription info")),
                        Checkbox(value: accepted, onChanged:(value) => onChanged(value!)),
                      ],
                    ),
                    SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () => buttonAction(),
                      text: 'Next',
                    ),
                                  ),
                  ],
                )
            

          ],
        );
      },
    );
  }
//****************************************************************
  ///* parse String to date time
  static DateTime? parseStringToDate(String date) {
    return DateTime.tryParse(date) ?? null;
  }

  ///* get Company Logo For Package
  ///* Priority :
  //* 1- corporate
  //* 2- insurance
  //* 3- broker
  //* 4- UsedPromosPackages => package promo code => corporate
  static String getCompanyLogoForPackage({
    required Package package,
  }) {
    String logo = '';
    if (package.corporateCompany != null) {
      //printWarning('photo CorporateCompany ');
      logo = package.corporateCompany!.photo ?? '';
    } else if (package.insuranceCompany != null) {
      //printWarning('photo insuranceCompany ');
      logo = package.insuranceCompany?.photo ?? '';
    } else if (package.broker != null) {
      //printWarning('photo broker ');
      logo = package.broker!.user?.photo ?? '';
    } else if (package.usedPromosPackages != null) {
      //printWarning('photo UsedPromosPackages ');
      logo = package.usedPromosPackages!.isNotEmpty
          ? package.usedPromosPackages![0].packagePromoCode?.corporateCompany
                  ?.photo ??
              ''
          : '';
    }

    // printMeLog('Logo For Package : $logo');
    return '$imagesBaseUrl$logo';
  }

//*****************************************************************************
  static String getCompanyNameForPackage({
    required Package package,
  }) {
    String name = '';
    if (package.corporateCompany != null) {
      // printWarning('photo CorporateCompany ');
      name = package.corporateCompany!.enName ?? '';
    } else if (package.insuranceCompany != null) {
      // printWarning('photo insuranceCompany ');
      name = package.insuranceCompany?.enName ?? '';
    } else if (package.broker != null) {
      // printWarning('photo broker ');
      name = package.broker!.user?.name ?? '';
    } else if (package.usedPromosPackages != null) {
      // printWarning('photo UsedPromosPackages ');
      name = package.usedPromosPackages!.isNotEmpty
          ? package.usedPromosPackages![0].packagePromoCode?.corporateCompany
                  ?.enName ??
              ''
          : '';
    }
    return name;
  }

//*****************************************************************************
  static double getHoursPerDays(int days) {
    return days * 24;
  }
}
