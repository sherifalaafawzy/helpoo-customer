import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/Profile/profile_bloc.dart';
import 'package:helpooappclient/Services/cache_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Configurations/extensions/size_extension.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/animations/cross_fade.dart';
import '../../Widgets/load_svg.dart';

import '../../generated/locale_keys.g.dart';
import '../Home/home_bloc.dart';
import '../Home/home_view.dart';
import '../MyCars/my_cars.dart';
import '../MyCars/my_cars_bloc.dart';
import '../Packages/packages_screen_bloc.dart';
import '../Packages/packages_screen_view.dart';
import '../Profile/profile_view.dart';
import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({this.isFromRegister = false, super.key});
  final bool isFromRegister;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainBloc? mainBloc;
  late List<Widget> bottomNavTabsScreen;

  @override
  void initState() {
    super.initState();
    bottomNavTabsScreen = [
      BlocProvider(create: (context) => HomeBloc(), child: const HomeScreen()),
      BlocProvider(
        create: (context) => MyCarsBloc(),
        child: const MyCarsScreen(),
      ),
      BlocProvider(
          create: (context) => PackagesScreenBloc(),
          child: PackagesScreen(isFromRegister: widget.isFromRegister)),
      BlocProvider(
          create: (context) => ProfileBloc(), child: const ProfileScreen()),
    ];
    mainBloc = context.read<MainBloc>();
    mainBloc?.add(MainGetUserRoleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) async {
        print('welcome omar');
        print(state);
        if (state is SelectBottomNavBarState) {
          userName = await sl<CacheHelper>().get(Keys.userName);
          setState(() {});
        }
        if (state is GetUserRoleSuccess || state is ChangeLanguageState) {
          if (userRoleName != "Client") {
            bottomNavTabsScreen = [
              BlocProvider(
                create: (context) => HomeBloc(),
                child: const HomeScreen(),
              ),
              BlocProvider(
                create: (context) => ProfileBloc(),
                child: const ProfileScreen(),
              ),
            ];
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.rSp),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppBar(
                backgroundColor: ColorsManager.transparent,
                elevation: 0,
                leadingWidth: 20.w,
                leading: Padding(
                  padding:
                      EdgeInsetsDirectional.only(start: 20.rSp, end: 10.rSp),
                  child: LoadSvg(
                    image: AssetsImages.userProfile,
                    isIcon: true,
                    fit: BoxFit.contain,
                    height: 40.rSp,
                    width: 40.rSp,
                  ),
                ),
                title: SizedBox(
                  width: 60.w,
                  child: Text(
                    '${LocaleKeys.welcome.tr()} ${mainBloc?.userName}',
                    style: TextStyles.bold16,
                    maxLines: 2,
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.rSp),
                    child: LoadSvg(
                      image: AssetsImages.logo,
                      height: 40.rSp,
                      width: 60.rSp,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: bottomNavTabsScreen[mainBloc!.selectedBottomNavBarIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: HexColor(mainColor),
            currentIndex: mainBloc!.selectedBottomNavBarIndex,
            onTap: (index) => setState(() {
              mainBloc!.selectedBottomNavBarIndex = index;
            }),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  AssetsImages.home_icon,
                  width: 25.rSp,
                  height: 25.rSp,
                  color: mainBloc!.selectedBottomNavBarIndex == 0
                      ? ColorsManager.mainColor
                      : Colors.grey,
                ),
                label: LocaleKeys.home.tr(),
              ),
              if (userRoleName == "Client")
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsImages.cars_icon,
                    width: 30.rSp,
                    height: 30.rSp,
                    color: mainBloc!.selectedBottomNavBarIndex == 1
                        ? ColorsManager.mainColor
                        : Colors.grey,
                  ),
                  label: LocaleKeys.myCars.tr(),
                ),
              if (userRoleName == "Client")
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsImages.packages_icon,
                    width: 30.rSp,
                    height: 30.rSp,
                    color: mainBloc!.selectedBottomNavBarIndex == 2
                        ? ColorsManager.mainColor
                        : Colors.grey,
                  ),
                  label: LocaleKeys.packages.tr(),
                ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  AssetsImages.profile_icon,
                  width: 30.rSp,
                  height: 30.rSp,
                  color: (userRoleName == "Client"
                          ? mainBloc!.selectedBottomNavBarIndex == 3
                          : mainBloc!.selectedBottomNavBarIndex == 1)
                      ? ColorsManager.mainColor
                      : Colors.grey,
                ),
                label: LocaleKeys.profile.tr(),
              ),
            ],
          ),
        );
      },
    );
  }

//******************************************************************************
  BottomNavigationBarItem getBottomNavIcon({
    required String selectedIconName,
    required String unSelectedIconName,
    required String label,
    required bool isSelected,
    bool isHomeIcon = false,
  }) =>
      BottomNavigationBarItem(
        label: label,
        icon: CrossFade(
          duration: duration300,
          condition: isSelected,
          shownIfTrue: isHomeIcon
              ? Image.asset(
                  '${AssetsImages.imagePath}/${AssetsImages.home}.png',
                  width: 50.rSp,
                  height: 50.rSp,
                )
              : LoadSvg(
                  image: selectedIconName,
                  color: ColorsManager.mainColor,
                  isIcon: true,
                  height: 26.rSp,
                  width: 26.rSp,
                ),
          shownIfFalse: isHomeIcon
              ? Image.asset(
                  '${AssetsImages.imagePath}/${AssetsImages.home}.png',
                  width: 50.rSp,
                  height: 50.rSp,
                )
              : LoadSvg(
                  image: selectedIconName,
                  color: ColorsManager.mainColor.withOpacity(0.5),
                  isIcon: true,
                  height: 26.rSp,
                  width: 26.rSp,
                ),
        ),
      );
//******************************************************************************
}
