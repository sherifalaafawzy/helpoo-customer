import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/Home/widgets/home_service_request_item.dart';
import 'package:helpooappclient/Services/cache_helper.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/fnol/latestFnolModel.dart';
import '../../Models/service_request/service_request.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/primary_loading.dart';
import '../../Widgets/spacing.dart';
import '../ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'home_bloc.dart';
import 'widgets/design_systems.dart';
import 'widgets/home_fnol_item.dart';
import 'widgets/home_service_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  HomeBloc? homeBloc;

  @override
  void initState() {
    super.initState();
    //  appBloc.isHomeScreenRoute = true;
    // appBloc.isFromPackageScreen = false;
    homeBloc = context.read<HomeBloc>();
    homeBloc?.isFromAnimation = true;
    print('init state home isFromAnimation');
    print(homeBloc?.isFromAnimation);
    if (userRoleName == "Client") {
      _scrollController = ScrollController();
      homeBloc?.homeBloc = homeBloc;
      homeBloc?.add(GetLatestRequests());
      homeBloc?.add(GetFNOLLatestRequests());
      _scrollController.addListener(
        () {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            homeBloc?.add(UpdateTabIndexHomeServiceRequestAndFNOL(index: 1));
          } else if (_scrollController.position.pixels == 0) {
            homeBloc?.add(UpdateTabIndexHomeServiceRequestAndFNOL(index: 0));
          }
        },
      );
    } else {
      homeBloc?.getCorporateLast10RequestsHistory();
    }
  }

  @override
  void dispose() {
    homeBloc?.timerHomeUiUpdates?.cancel();
    homeBloc?.timerHomeServiceRequestItemUpdates?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state is GetRequestsHistorySuccessState) {
          homeBloc?.add(FilterCurrentRequests());
        } else if (state is FilterCurrentRequestsState) {
          setState(() {});
          if (homeBloc!.activeReq!.isEmpty) {
            homeBloc?.timerHomeUiUpdates?.cancel();
            homeBloc?.timerHomeServiceRequestItemUpdates?.cancel();
          } else {
            if (homeBloc?.activeReq?.isNotEmpty ?? false) {
              await homeBloc?.handleMapReqUiUpdates(
                  isCurrentReq: true, index: state.index ?? 0);

              ///  await homeBloc?.startTimerHomeServiceRequest(state.index ?? 0);
            }
          }
        }
        if (state is GetRequestsHistoryErrorState)
          HelpooInAppNotification.showErrorMessage(message: state.error);
      },
      builder: (context, state) {
        return PrimaryLoading(
          isLoading: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace10,
              SizedBox(
                height: 33.h,
                child: ListView.separated(
                  itemCount: userRoleName == "Client" ? 2 : 1,
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.rw),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return horizontalSpace16;
                  },
                  itemBuilder: (context, index) {
                    return HomeServiceItem(
                      isLoading: false,
                      image: index == 0
                          ? AssetsImages.roadServices
                          : AssetsImages.fnol,
                      title: index == 0
                          ? LocaleKeys.roadServices.tr()
                          : LocaleKeys.fnol.tr(),
                      titleOnImage: "",
                      onTap: () {
                        // appBloc.isHomeScreenRoute = false;
                        if (index == 0) {
                          homeBloc?.add(
                              NavigateToServiceRequestScreen(context: context));
                          // context.pushNamed(Routes.roadServicePage);
                        } else {
                          setState(() {
                            homeBloc?.cancelUpdateMapUiTimer();
                          });

                          homeBloc?.add(NavigateToFNOLScreen(context: context));

                          // appBloc.isHomeSR = false;
                          // context.pushNamed(Routes.selectCarScreen);
                        }
                        // index == 0 ? context.pushNamed(Routes.roadServicePage) : context.pushNamed(Routes.selectCarScreen);
                      },
                    );
                  },
                ),
              ),
              verticalSpace5,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.rw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (homeBloc?.selectedIndex == 0) ...[
                        Text(
                          LocaleKeys.currentRequests.tr(),
                          style: TextStyles.bold16,
                        ),
                        verticalSpace10,
                        homeBloc!.gettingActiveRequests
                            ? Expanded(
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorsManager.mainColor,
                                  ),
                                ),
                              )
                            : homeBloc?.activeRequestsList.isEmpty ?? true
                                ? Center(
                                    child: DesignSystem.emptyWidget(
                                        emptyText:
                                            LocaleKeys.noActiveRequests.tr()))
                                : Expanded(
                                    child: /*state is GetRequestsHistoryLoadingState
                                    ? const Center(
                                        child: CupertinoActivityIndicator(
                                          color: ColorsManager.mainColor,
                                        ),
                                      )
                                    :*/
                                        ListView.separated(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              bottomPaddingToAvoidBottomNav.rh),
                                      itemBuilder: (context, index) {
                                        ///  homeBloc?.currentServiceRequestIndex=index;
                                        return Column(
                                          children: [
                                            HomeServiceRequestItem(
                                                homeBloc: homeBloc,
                                                stepperOpenSpeed:
                                                    homeBloc?.isFromAnimation,
                                                index: index,
                                                myGoogleMapsHitResponse:
                                                    homeBloc!
                                                        .activeRequestsList[
                                                            index]
                                                        .myGoogleMapsHitResponse,
                                                serviceRequest: homeBloc!
                                                    .activeRequestsList[index]),
                                            /*  Text(
                                            'curr:${homeBloc!.activeRequestsList[index].actualDuration}'),
                                        Text(
                                            'last:${homeBloc!.activeRequestsList[index].requestLocationModel.lastUpdatedDistanceAndDuration?.driverDistanceMatrix?.duration?.value}'),
                                    */
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return verticalSpace8;
                                      },
                                      itemCount:
                                          homeBloc?.activeRequestsList.length ??
                                              0,
                                    ),
                                  ),
                      ] else ...[
                        Text(
                          LocaleKeys.fnol.tr(),
                          style: TextStyles.bold16,
                        ),
                        verticalSpace10,
                        homeBloc?.latestFnols.isEmpty ?? true
                            ? Center(
                                child: DesignSystem.emptyWidget(
                                  emptyText: LocaleKeys.noActiveRequests.tr(),
                                ),
                              )
                            : Expanded(
                                child: /*state is GetLatestFnolsLoading
                              ? Center(
                            child: CupertinoActivityIndicator(
                              color: ColorsManager.mainColor,
                            ),
                          )
                              :*/
                                    ListView.separated(
                                  padding: EdgeInsets.only(
                                      bottom: bottomPaddingToAvoidBottomNav.rh),
                                  itemBuilder: (context, index) {
                                    return HomeFNOLItem(
                                      fnol: homeBloc?.latestFnols[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return verticalSpace8;
                                  },
                                  itemCount: homeBloc?.latestFnols.length ?? 0,
                                ),
                              )
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
