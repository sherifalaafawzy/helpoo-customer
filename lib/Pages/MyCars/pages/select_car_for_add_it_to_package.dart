import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Models/packages/package_model.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Services/navigation_service.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Home/widgets/design_systems.dart';
import '../my_cars_bloc.dart';
import '../widgets/my_car_item.dart';

class SelectCarForAddItToPackage extends StatefulWidget {
  const SelectCarForAddItToPackage({Key? key}) : super(key: key);

  @override
  State<SelectCarForAddItToPackage> createState() =>
      _SelectCarForAddItToPackageState();
}

class _SelectCarForAddItToPackageState
    extends State<SelectCarForAddItToPackage> {
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
      myCarsBloc!.getMyPackages();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      body: BlocListener<MyCarsBloc, MyCarsState>(
        listener: (context, state) {
          if (state is GetMyCarsSuccessState) {
            setState(() {});
          }
          // TODO: implement listener
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: myCarsBloc?.myCarsWithoutPackage.isEmpty ?? true
                  ? DesignSystem.emptyWidget(
                      emptyText: LocaleKeys.noCars.tr(),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                          bottom: bottomPaddingToAvoidBottomNav.rh),
                      itemCount: myCarsBloc?.myCarsWithoutPackage.length ?? 0,
                      separatorBuilder: (context, index) => verticalSpace12,
                      itemBuilder: (context, index) {
                        return BlocProvider.value(
                          value: myCarsBloc!,
                          child: MyCarItem(
                            myCarModel: myCarsBloc!.myCarsWithoutPackage[index],
                            isFromPayment: (ModalRoute.of(context)!
                                    .settings
                                    .arguments as Map?)?["isFromPayment"] ??
                                false,
                            activateButton: false,
                            selectedPackage: (ModalRoute.of(context)!
                                    .settings
                                    .arguments as Map?)?["selectedAddedPackage"]
                                as Package?,
                            addToPackageButton: true,
                            activeReq: [],
                            myCarsBloc: myCarsBloc,
                            editButton: false,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
