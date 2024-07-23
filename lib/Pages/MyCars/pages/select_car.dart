import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../../Home/widgets/design_systems.dart';
import '../my_cars_bloc.dart';
import '../widgets/my_car_item.dart';

class SelectCarScreen extends StatefulWidget {
  const SelectCarScreen({Key? key}) : super(key: key);

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  MyCarsBloc? myCarsBloc;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    myCarsBloc = context.read<MyCarsBloc>();
    //  if (appBloc.isAddCorporateCar) navigatorKey.currentContext!.pushNamed(Routes.addCarScreen);
    if (userRoleName == "Client") {
      myCarsBloc?.add(GetMyCarsEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      appBarTitle: LocaleKeys.selectCar.tr(),
      body: BlocConsumer<MyCarsBloc, MyCarsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is GetMyCarsLoadingState
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.cars.tr(),
                      style: TextStyles.bold20,
                    ),
                    verticalSpace10,
                    Text(
                      LocaleKeys.pleaseSelectCar.tr(),
                      style: TextStyles.regular14,
                    ),
                    verticalSpace20,
                    Expanded(
                      child: (ModalRoute.of(context)!.settings.arguments
                                  as Map)['selectedIndex'] ==
                              0
                          ? myCarsBloc?.allMyCars.isEmpty ?? true
                              ? DesignSystem.emptySelectCarWidget(
                                  emptyText: LocaleKeys.noCars.tr(),
                                  context: context,
                                  onTab: () {
                                    NavigationService
                                        .navigatorKey.currentContext!
                                        .pushNamed(PageRouteName.addCarScreen,
                                            arguments: {
                                          "isAddCarServiceRequest": true
                                        });
                                  })
                              : _buildAllMyCarsList()
                          : myCarsBloc?.myCarsAddedToPackage.isEmpty ?? true
                              ? DesignSystem.emptyWidget(
                                  emptyText: LocaleKeys.noCarsWithPackage.tr(),
                                )
                              : _buildMyCarsAddedToPackageList(),
                    ),
                  ],
                );
        },
      ),
    );
  }

  _buildMyCarsAddedToPackageList() {
    return ListView.separated(
      padding: EdgeInsets.only(
        bottom: bottomPaddingToAvoidBottomNav.rh,
      ),
      itemCount: myCarsBloc?.myCarsAddedToPackage.length ?? 0,
      separatorBuilder: (context, index) => verticalSpace12,
      itemBuilder: (context, index) {
        return BlocProvider.value(
          value: myCarsBloc!,
          child: MyCarItem(
            selectedServices: (ModalRoute.of(context)!.settings.arguments
                as Map)['selectedServices'],
            myCarModel: myCarsBloc!.myCarsAddedToPackage[index],
            isSelection: true,
            selectedIndex: (ModalRoute.of(context)!.settings.arguments
                as Map)['selectedIndex'],
            activeReq: (ModalRoute.of(context)!.settings.arguments
                as Map)['activeReqList'],
            activateButton: false,
            addToPackageButton: false,
            editButton: false,
            myCarsBloc: myCarsBloc,
          ),
        );
      },
    );
  }

  _buildAllMyCarsList() {
    return ListView.separated(
      padding: EdgeInsets.only(
        bottom: bottomPaddingToAvoidBottomNav.rh,
      ),
      itemCount: myCarsBloc?.allMyCars.length ?? 0,
      separatorBuilder: (context, index) => verticalSpace12,
      itemBuilder: (context, index) {
        var myCarItem = MyCarItem(
          selectedServices: (ModalRoute.of(context)!.settings.arguments
              as Map)['selectedServices'],
          myCarModel: myCarsBloc!.allMyCars[index],
          isSelection: true,
          selectedIndex: (ModalRoute.of(context)!.settings.arguments
              as Map)['selectedIndex'],
          activeReq: (ModalRoute.of(context)!.settings.arguments
              as Map)['activeReqList'],
          activateButton: false,
          addToPackageButton: false,
          editButton: false,
          myCarsBloc: myCarsBloc,
        );
        return BlocProvider.value(
          value: myCarsBloc!,
          child: myCarItem,
        );
      },
    );
  }
}
