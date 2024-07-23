import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Models/cars/my_cars.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/primary_loading.dart';
import '../../Widgets/scaffold_bk.dart';
import '../../Widgets/spacing.dart';
import '../Home/widgets/design_systems.dart';
import 'my_cars_bloc.dart';
import 'widgets/my_car_item.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({Key? key}) : super(key: key);

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  MyCarsBloc? myCarsBloc;

  @override
  void initState() {
    super.initState();
    myCarsBloc = context.read<MyCarsBloc>();
    if (userRoleName == "Client") {
      myCarsBloc?.add(GetMyCarsEvent());
      myCarsBloc!.getMyPackages();
    }

    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) {
        //   appBloc.renderUI();
      }
    });
    /*  if (userRoleName == "Client") {
      appBloc.getMyCars();
      appBloc.getMyPackages();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments != null
        ? ScaffoldWithBackground(
            body: buildMyCarsView(),
          )
        : buildMyCarsView();
  }

  Widget buildMyCarsView() {
    return BlocConsumer<MyCarsBloc, MyCarsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpace20,
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: ColorsManager.mainColor,
              labelColor: ColorsManager.mainColor,
              dividerColor: ColorsManager.greyColor,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyles.bold16,
              onTap: (value) {
                setState(() {});
              },
              indicatorWeight: 0.0,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 12.rw),
              controller: tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: ColorsManager.lightGreyColor),
              tabs: [
                Container(
                  width: 210.rSp,
                  padding: EdgeInsets.symmetric(horizontal: 10.rw),
                  decoration: BoxDecoration(
                    color: tabController!.index == 1
                        ? ColorsManager.darkerGreyColor
                        : ColorsManager.lightGreyColor,
                    // Background color for the entire TabBar
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      // Adjust top-left radius
                      topRight:
                          Radius.circular(10.0), // Adjust top-right radius
                    ),
                  ),
                  child: Tab(
                      child: Text(
                    LocaleKeys.carsWithoutPackage.tr(),
                    style: TextStyles.bold12.copyWith(
                      color: tabController!.index == 0
                          ? ColorsManager.mainColor
                          : ColorsManager.white,
                    ),
                  )),
                ),
                Container(
                  width: 210.rSp,
                  padding: EdgeInsets.symmetric(horizontal: 10.rw),
                  decoration: BoxDecoration(
                    color: tabController!.index == 0
                        ? ColorsManager.darkerGreyColor
                        : ColorsManager.lightGreyColor,
                    // Background color for the entire TabBar
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      // Adjust top-left radius
                      topRight:
                          Radius.circular(10.0), // Adjust top-right radius
                    ),
                  ),
                  child: Tab(
                    child: Text(
                      LocaleKeys.carsWithPackage.tr(),
                      style: TextStyles.bold12.copyWith(
                        color: tabController!.index == 1
                            ? ColorsManager.mainColor
                            : ColorsManager.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            PrimaryLoading(
              isExpanded: true,
              isLoading: state is GetMyCarsLoadingState,
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: 20.rSp.br,
                    color: ColorsManager.lightGreyColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.rw, vertical: 16.rh),
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        ///** my cars without package
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: myCarsBloc?.myCarsWithoutPackage.isEmpty ??
                                      true
                                  ? DesignSystem.emptyWidget(
                                      emptyText: LocaleKeys.noCars.tr(),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              bottomPaddingToAvoidBottomNav.rh),
                                      itemCount: myCarsBloc
                                              ?.myCarsWithoutPackage.length ??
                                          0,
                                      separatorBuilder: (context, index) =>
                                          verticalSpace12,
                                      itemBuilder: (context, index) {
                                        return BlocProvider.value(
                                          value: myCarsBloc!,
                                          child: MyCarItem(
                                            myCarModel: myCarsBloc!
                                                .myCarsWithoutPackage[index],
                                            activateButton: !myCarsBloc!
                                                .myCarsWithoutPackage[index]
                                                .active!,
                                            addToPackageButton: myCarsBloc!
                                                .myCarsWithoutPackage[index]
                                                .carPackages!
                                                .isEmpty,
                                            activeReq: [],
                                            myCarsBloc: myCarsBloc,
                                            editButton: true,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Visibility(
                              visible: tabController?.index == 0,
                              //!appBloc.isFromPackageScreen,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PrimaryButton(
                                    text: LocaleKeys.addCar.tr(),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    onPressed: () {
                                      myCarsBloc?.handleAddCarIntro(
                                        activateCarValue: false,
                                        addCarToPackageValue: false,
                                        isAddCorporateCarValue: false,
                                        isAddNewCarToPackageValue: false,
                                        editCarValue: false,
                                      );
                                      NavigationService
                                          .navigatorKey.currentContext!
                                          .pushNamed(
                                              PageRouteName.addCarScreen);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///** my cars inside package
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: myCarsBloc?.myCarsAddedToPackage.isEmpty ??
                                      true
                                  ? DesignSystem.emptyWidget(
                                      emptyText:
                                          LocaleKeys.carsWithPackage.tr(),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            bottomPaddingToAvoidBottomNav.rh,
                                      ),
                                      itemCount: myCarsBloc!
                                          .myCarsAddedToPackage.length,
                                      separatorBuilder: (context, index) =>
                                          verticalSpace12,
                                      itemBuilder: (context, index) {
                                        return BlocProvider.value(
                                          value: myCarsBloc!,
                                          child: MyCarItem(
                                            activeReq: [],
                                            myCarModel: myCarsBloc!
                                                .myCarsAddedToPackage[index],
                                            activateButton: !myCarsBloc!
                                                .myCarsAddedToPackage[index]
                                                .active!,
                                            myCarsBloc: myCarsBloc,
                                            addToPackageButton: false,
                                            editButton: false,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //verticalSpace40,
          ],
        );
      },
    );
  }
}

//******************************************************************************
