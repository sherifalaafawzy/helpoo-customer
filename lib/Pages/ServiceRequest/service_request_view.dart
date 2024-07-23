import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';
import 'package:helpooappclient/Pages/Home/home_bloc.dart';
import 'package:helpooappclient/Pages/ServiceRequest/widgets/road_service_latest_req_item.dart';
import 'package:helpooappclient/Services/cache_helper.dart';
import 'package:helpooappclient/Widgets/primary_button.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Configurations/di/injection.dart';
import '../../Services/navigation_service.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/load_asset_image.dart';
import '../../Widgets/scaffold_bk.dart';
import '../../Widgets/spacing.dart';
import '../../generated/locale_keys.g.dart';
import '../Home/widgets/design_systems.dart';
import '../Home/widgets/home_service_item.dart';
import 'service_request_bloc.dart';

class RoadServicePage extends StatefulWidget {
  const RoadServicePage({Key? key}) : super(key: key);

  @override
  State<RoadServicePage> createState() => _RoadServicePageState();
}

class _RoadServicePageState extends State<RoadServicePage> {
  ServiceRequestBloc? serviceRequestBloc;
  HomeBloc? homeBloc;
  final List<bool> selectedServices = List.filled(4, false);
  bool isWenchEnabled = false;
  @override
  void initState() {
    homeBloc = context.read<HomeBloc>();
    serviceRequestBloc = context.read<ServiceRequestBloc>();
    if (userRoleName == "Client") {
      homeBloc?.add(GetLatestRequests());
    } else {
      homeBloc?.getCorporateLast10RequestsHistory();
    }
    homeBloc?.stream.listen((homeState) {
      print('homeState');
      print(homeState);
      if (homeState is GetRequestsHistorySuccessState) {
        homeBloc?.add(FilterCurrentRequests());
      } else if (homeState is FilterCurrentRequestsState ||
          homeState is FilterHistoryRequestsState) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      horizontalPadding: 0,
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      appBarTitle: LocaleKeys.roadServices.tr(),
      body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
        listener: (context, state) {
          ///  print(state);
          ///  print(homeBloc?.activeRequestsList.length);
          if (state is UserCanSendNewRequest) {
            Navigator.of(context)
                .pushNamed(PageRouteName.selectCarScreen, arguments: {
              "selectedServices": selectedServices,
              "selectedIndex": 0,
              "activeReqList": homeBloc?.activeRequestsList
            });
          } else if (state is UserCanNotSendNewRequest) {
            Navigator.of(context)
                .pushNamed(PageRouteName.selectCarScreen, arguments: {
              "selectedServices": selectedServices,
              "selectedIndex": 0,
              "activeReqList": homeBloc?.activeRequestsList
            });
          } else if (state is CheckIfUserCanSendRequestErrorState) {
            HelpooInAppNotification.showErrorMessage(message: state.error);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace16,
              _buildNewServicesWidget(state),
              verticalSpace16,
              Expanded(child: _buildHistoryRequests()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryRequests() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (homeBloc?.gettingLatestRequests == true)
          return Center(
              child: CircularProgressIndicator(
                  backgroundColor: ColorsManager.mainColor));

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.recentRequests.tr(),
                style: TextStyles.bold16,
              ),
              verticalSpace16,
              homeBloc?.latestRequests.isEmpty ?? true
                  ? Center(
                      child: DesignSystem.emptyWidget(
                      emptyText: LocaleKeys.noRecentRequests.tr(),
                    ))
                  : Expanded(
                      child: ListView.separated(
                        itemCount: homeBloc?.latestRequests.length ?? 0,
                        padding: EdgeInsets.only(bottom: 90.rh),
                        itemBuilder: (context, index) {
                          return homeBloc?.latestRequests.isEmpty ?? true
                              ? DesignSystem.emptyWidget(
                                  emptyText: LocaleKeys.noRecentRequests.tr(),
                                )
                              : homeBloc!.activeRequestsList.any((element) =>
                                      homeBloc!.latestRequests[index].id ==
                                      element.id)
                                  ? const SizedBox(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : RoadServiceLatestReqItem(
                                      serviceRequest:
                                          homeBloc!.latestRequests[index]);
                        },
                        separatorBuilder: (context, index) {
                          return verticalSpace8;
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServices(ServiceRequestState state) {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        itemCount: 4,
        padding: EdgeInsets.symmetric(horizontal: 20.rw),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return horizontalSpace16;
        },
        itemBuilder: (context, index) {
          List<String> images = [
            AssetsImages.wenchSRA,
            AssetsImages.fuelSRA,
            AssetsImages.battaryRSA,
            AssetsImages.tireRSA,
          ];
          List<String> titles = [
            LocaleKeys.wench.tr(),
            LocaleKeys.fuel.tr(),
            LocaleKeys.battery.tr(),
            LocaleKeys.tire.tr(),
          ];
          List<String> titlesOnImgages = [
            LocaleKeys.wenchText.tr(),
            LocaleKeys.fuelText.tr(),
            LocaleKeys.batteryText.tr(),
            LocaleKeys.tireText.tr(),
          ];
          return HomeServiceItem(
            isLoading: state is CheckIfUserCanSendRequestLoadingState,
            image: images[index],
            title: titles[index],
            titleOnImage: titlesOnImgages[index],
            onTap: () async {
              if (state is CheckIfUserCanSendRequestLoadingState) {
                return;
              }
              final String? userRoleName =
                  await sl<CacheHelper>().get(Keys.userRoleName);
              if (index == 0) {
                if (userRoleName != "Client") {
                  // appBloc.isAddCorporateCar = true;
                  // ignore: use_build_context_synchronously
                  NavigationService.navigatorKey.currentContext!
                      .pushNamed(PageRouteName.addCarScreen, arguments: {
                    "myCarModel": MyCarModel(),
                    "activateCarValue": false,
                    "addCarToPackageValue": false,
                    "isAddCorporateCarValue": true,
                    "isAddNewCarToPackageValue": false,
                    "editCarValue": false
                  });
                  //  context.pushNamed(PageRouteName.addCarScreen);
                } else {
                  serviceRequestBloc?.add(CheckIfUserCanSendNewRequestEvent());
                }
              } else {
                // TODO: comming soon
                HelpooInAppNotification.showErrorMessage(
                    message: LocaleKeys.call17000.tr());
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildNewServicesWidget(ServiceRequestState state) {
    return StatefulBuilder(
      builder: (context, changeState) {
        final bool otherServicesEnabled =
            selectedServices[0] || selectedServices[1] || selectedServices[2];
        final bool isWenchOrPassengerEnabled =
            isWenchEnabled || selectedServices[3];

        void _updateWench(bool value) {
          if (!otherServicesEnabled) isWenchEnabled = value;
          changeState(() {});
        }

        void _updateOtherServices(int index, bool value) {
          if (index == 3 && !otherServicesEnabled) {
            selectedServices[index] = value;
          } else if (!isWenchOrPassengerEnabled && index != 3)
            selectedServices[index] = value;

          changeState(() {});
        }

        final isButtonDisabled =
            !isWenchEnabled && !selectedServices.any((element) => element);
        final selectedServicesMap = {
          "wench": isWenchEnabled,
          "fuel": selectedServices[0],
          "battery": selectedServices[1],
          "tire": selectedServices[2],
          "passenger": selectedServices[3]
        };
        return _buildCard(
          context,
          _buildWenchRow(
            context,
            _updateWench,
            otherServicesEnabled,
          ),
          _buildDivider(),
          _buildServicesGridView(
            _updateOtherServices,
            isWenchOrPassengerEnabled,
            isWenchEnabled,
            otherServicesEnabled,
          ),
          _buildRequestButton(
            isButtonDisabled,
            state,
            selectedServicesMap,
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    Widget wenchRow,
    Widget divider,
    Widget servicesGridView,
    Widget button,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.rw),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            wenchRow,
            verticalSpace16,
            divider,
            verticalSpace16,
            servicesGridView,
            verticalSpace16,
            button,
          ],
        ),
      ),
    );
  }

  Widget _buildWenchRow(
    BuildContext context,
    Function(bool) updateWench,
    bool otherServicesEnabled,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.rw),
          child: LoadAssetImage(
            image: AssetsImages.wenchSRA,
            extension: 'jpg',
            width: 120.rw,
            height: 90.rh,
            fit: BoxFit.cover,
          ),
        ),
        horizontalSpace16,
        Checkbox(
          activeColor: Colors.green,
          value: isWenchEnabled,
          onChanged: otherServicesEnabled || selectedServices[3]
              ? null
              : (value) => updateWench(value!),
        ),
        horizontalSpace16,
        Text(
          LocaleKeys.wench.tr(),
          style: TextStyles.bold16,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey,
      indent: 30.rw,
      endIndent: 30.rw,
    );
  }

  Widget _buildServicesGridView(
    Function(int, bool) updateOtherServices,
    bool isWenchOrPassengerEnabled,
    bool isWenchEnabled,
    bool otherServicesEnabled,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final bool isOtherServiceCheckBoxDisabled =
            isWenchOrPassengerEnabled && index != 3;
        final bool isPassengerCheckBoxDisabled =
            (otherServicesEnabled || isWenchEnabled) && index == 3;
        final bool isCheckBoxDisabled =
            isOtherServiceCheckBoxDisabled || isPassengerCheckBoxDisabled;

        return _buildServiceRow(
          index,
          updateOtherServices,
          isCheckBoxDisabled,
        );
      },
    );
  }

  Widget _buildServiceRow(
    int index,
    Function(int, bool) updateOtherServices,
    bool isCheckBoxDisabled,
  ) {
    final List<String> images = [
      AssetsImages.fuelSRA,
      AssetsImages.battaryRSA,
      AssetsImages.tireRSA,
      AssetsImages.passenger,
    ];

    final List<String> titles = [
      LocaleKeys.fuel.tr(),
      LocaleKeys.battery.tr(),
      LocaleKeys.tire.tr(),
      LocaleKeys.passengerCar.tr(),
    ];
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.green,
          value: selectedServices[index],
          onChanged: isCheckBoxDisabled
              ? null
              : (value) => updateOtherServices(index, value!),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.rw),
          child: LoadAssetImage(
            extension: 'jpg',
            image: images[index],
            width: 40.rw,
            height: 40.rh,
            fit: BoxFit.cover,
          ),
        ),
        horizontalSpace4,
        Expanded(
          child: Text(
            titles[index],
            style: TextStyles.bold12,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestButton(
    bool isButtonDisabled,
    ServiceRequestState state,
    Map<String, bool> selectedServices,
  ) {
    return PrimaryButton(
      text: LocaleKeys.request.tr(),
      isLoading: state is CheckIfUserCanSendRequestLoadingState,
      isDisabled: isButtonDisabled,
      onPressed: () async {
        final hasNotTrip = homeBloc?.activeRequestsList.isEmpty ?? true;
        if (!selectedServices["wench"]! &&
            hasNotTrip &&
            selectedServices["passenger"]!) {
          return HelpooInAppNotification.showErrorMessage(
              message: LocaleKeys.passengerErrorMessage.tr());
        }
        final String? userRoleName =
            await sl<CacheHelper>().get(Keys.userRoleName);

        if (userRoleName != "Client")
          context.pushNamed(PageRouteName.addCarScreen, arguments: {
            "selectedServices": selectedServices,
            "myCarModel": MyCarModel(),
            "activateCarValue": false,
            "addCarToPackageValue": false,
            "isAddCorporateCarValue": true,
            "isAddNewCarToPackageValue": false,
            "editCarValue": false
          });
        else
          context.pushNamed(PageRouteName.selectCarScreen, arguments: {
            "selectedServices": selectedServices,
            "selectedIndex": 0,
            "activeReqList": homeBloc?.activeRequestsList
          });
      },
    );
  }
}
