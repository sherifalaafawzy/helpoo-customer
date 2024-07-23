import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Pages/MyCars/widgets/add_car_or_select_car_card.dart';

import '../../../Services/navigation_service.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../generated/locale_keys.g.dart';
import '../my_cars_bloc.dart';

class AddCarOrSelectCarPackage extends StatefulWidget {
  const AddCarOrSelectCarPackage({this.isFromPayment = false, Key? key})
      : super(key: key);
  final bool isFromPayment;
  @override
  State<AddCarOrSelectCarPackage> createState() =>
      _AddCarOrSelectCarPackageState();
}

class _AddCarOrSelectCarPackageState extends State<AddCarOrSelectCarPackage> {
  MyCarsBloc? myCarsBloc;

  @override
  void initState() {
    myCarsBloc = context.read<MyCarsBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print((myCarsBloc!.isAddCorporateCar));
    return BlocConsumer<MyCarsBloc, MyCarsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ScaffoldWithBackground(
          appBarTitle: LocaleKeys.addCar.tr(),
          extendBodyBehindAppBar: false,
          onBackTab: () {
            NavigationService.navigatorKey.currentContext!.pop;
          },
          body: SingleChildScrollView(
            child: Column(children: [
              ListView.builder(
                itemBuilder: (context, index) => AddCarOrSelectCarCard(
                  selectedPackage: (ModalRoute.of(context)!.settings.arguments
                      as Map)['selectedAddedPackage'],
                  isFromPayment: widget.isFromPayment,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (ModalRoute.of(context)!.settings.arguments
                        as Map)["totalCars"] -
                    (ModalRoute.of(context)!.settings.arguments
                        as Map)["addedCars"],
              )
            ]),
          ),
        );
      },
    );
  }
}
