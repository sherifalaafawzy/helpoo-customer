import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/locale_keys.g.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Models/on_boarding_model.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/load_svg.dart';
import '../../Widgets/scaffold_bk.dart';
import '../../Widgets/spacing.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController boardController = PageController(initialPage: 0);
  int currentIndex = 0;
  List<BoardingModel> boarding = [
    BoardingModel(
        // image: 'assets/images/on_boarding1.png',
        title: LocaleKeys.onBoarding1.tr(),
        content: LocaleKeys.onBoardingSub1.tr(),
        backgroundImage: 'assets/images/on_boarding_background1.png',
        json: 'assets/json/json1.json'),
    // Lottie.asset('assets/json/json1.json')),
    BoardingModel(
        //  image: 'assets/images/on_boarding2.png',
        title: LocaleKeys.onBoarding2.tr(),
        content: LocaleKeys.onBoardingSub2.tr(),
        backgroundImage: '',
        json: 'assets/json/json2.json'),
    BoardingModel(
        // image: 'assets/images/on_boarding_background3.png',
        title: LocaleKeys.onBoarding3.tr(),
        content: LocaleKeys.onBoardingSub3.tr(),
        backgroundImage: 'assets/images/on_boarding_background3.png',
        json: 'assets/json/json3.json'),
    BoardingModel(
        //   image: 'assets/images/on_boarding4.jpg',
        title: LocaleKeys.onBoarding4.tr(),
        content: LocaleKeys.onBoardingSub4.tr(),
        backgroundImage: 'assets/images/on_boarding_background4.png',
        json: ''),
    BoardingModel(
        // image: 'assets/images/on_boarding5.jpg',
        title: LocaleKeys.onBoarding5.tr(),
        content: LocaleKeys.onBoardingSub5.tr(),
        backgroundImage: '',
        json: 'assets/json/json5.json'),
  ];

  @override
  void initState() {
    super.initState();
    // appBloc.renderUI();
    currentIndex = 0;

    /// Attach a listener which will update the state and refresh the page index
    // boardController.addListener(() {
    //   if (boardController.page!.round() != currentIndex) {
    //     setState(() {
    //       currentIndex = boardController.page!.round();
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldWithBackground(
        horizontalPadding: 0,
        withBack: false,
        body: Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 15.rSp,
            start: 12.rSp,
            end: 12.rSp,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///* page view [ board Item ]
              SizedBox(
                height: 50.h,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.rSp,
                  ),
                  child: PageView.builder(
                    itemBuilder: (context, index) => buildBoardingItem(index),
                    itemCount: boarding.length,
                    controller: boardController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              ///* Helpoo Logo
              LoadSvg(
                image: AssetsImages.logo,
                width: 145.rw,
                height: 50.rh,
              ),
              // verticalSpace24,

              Spacer(),
              ///* Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.skip.tr(),
                    style: TextStyles.bold14
                        .copyWith(color: ColorsManager.transparent),
                  ),
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: WormEffect(
                      activeDotColor: ColorsManager.mainColor,
                      dotColor: ColorsManager.mainColor.withOpacity(0.5),
                      dotWidth: 9,
                      dotHeight: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // CacheHelper.saveData(
                      //     key: Keys.firstTimeInstalled, value: false);
                      // firstTimeInstalled =
                      //     CacheHelper.getData(key: Keys.firstTimeInstalled);
                      //
                      //   context.pushNamedAndRemoveUntil(Routes.welcomeScreen);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          PageRouteName.welcomeScreen, (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentIndex == boarding.length - 1
                            ? LocaleKeys.doneOnBoarding.tr()
                            : LocaleKeys.skip.tr(),
                        style: TextStyles.bold14
                            .copyWith(color: ColorsManager.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace14,
            ],
          ),
        ),
      ),
    );
  }

  ///* Board Item [ Image / title / subTitle ]
  Widget buildBoardingItem(int index) {
    String title = index == 0
        ? LocaleKeys.onBoarding1.tr()
        : index == 1
            ? LocaleKeys.onBoarding2.tr()
            : index == 2
                ? LocaleKeys.onBoarding3.tr()
                : index == 3
                    ? LocaleKeys.onBoarding4.tr()
                    : LocaleKeys.onBoarding5.tr();
    String content = index == 0
        ? LocaleKeys.onBoardingSub1.tr()
        : index == 1
            ? LocaleKeys.onBoardingSub2.tr()
            : index == 2
                ? LocaleKeys.onBoardingSub3.tr()
                : index == 3
                    ? LocaleKeys.onBoardingSub4.tr()
                    : LocaleKeys.onBoardingSub5.tr();
    return Column(
      children: [
        if (index != 2)
          Container(
            width: double.infinity,
            height: 250,
            decoration: boarding[index].backgroundImage.isNotEmpty
                ? BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(boarding[index].backgroundImage),
                        fit: BoxFit.fill))
                : null,
            child: index != 3
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 20),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: index == 0
                          ? CircleAvatar(
                              radius: 100,
                              foregroundColor: Colors.transparent,
                              child: boarding[index].json.isNotEmpty
                                  ? Lottie.asset(boarding[index].json)
                                  : Container(),
                            )
                          : boarding[index].json.isNotEmpty
                              ? Lottie.asset(boarding[index].json)
                              : Container(),
                    ),
                  ))
                : Container(),
            //AssetsImages.logo,
          ),
        if (index == 2)
          Stack(
            children: [
              SizedBox(
                  height: 305,
                  child: boarding[index].json.isNotEmpty
                      ? Lottie.asset(boarding[index].json)
                      : Container()),
              Container(
                width: double.infinity,
                height: 330,
                decoration: boarding[index].backgroundImage.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(boarding[index].backgroundImage),
                            fit: BoxFit.fill))
                    : null,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 20),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                )),
                //AssetsImages.logo,
              ),
            ],
          ),
        verticalSpace20,
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyles.bold22,
        ),
        verticalSpace10,
        Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyles.regular18.copyWith(
            fontFamily: TextStyles.tajawalFamilyName,
          ),
        )
      ],
    );
  }
}
