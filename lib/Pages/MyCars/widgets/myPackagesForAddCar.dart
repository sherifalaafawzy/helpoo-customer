import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/primary_loading.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../my_cars_bloc.dart';

class MyPackagesForAddCar extends StatefulWidget {
  const MyPackagesForAddCar({
    this.selectedPackage,
    this.isFromPayment = false,
    super.key,
  });
  final Package? selectedPackage;
  final bool isFromPayment;
  @override
  State<MyPackagesForAddCar> createState() => _MyPackagesForAddCarState();
}

class _MyPackagesForAddCarState extends State<MyPackagesForAddCar> {
  MyCarsBloc? myCarsBloc;

  @override
  void initState() {
    myCarsBloc = context.read<MyCarsBloc>();
    if (myCarsBloc?.myPackages.contains(myCarsBloc?.selectedAddedPackage) ??
        false) {
      // printMeLog("yeah it's contain");
      myCarsBloc?.selectedAddedPackage = myCarsBloc!.selectedAddedPackage;
    }
    if (widget.selectedPackage != null)
      myCarsBloc?.selectedAddedPackage = widget.selectedPackage!;
    if (widget.isFromPayment) {
      myCarsBloc?.selectedAddedPackage = myCarsBloc!.myPackages.first;
    }
    //  printMeLog(myCarsBloc?.selectedAddedPackage.name.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCarsBloc, MyCarsState>(
      listener: (context, state) {
        if (state is GetMyPackagesFromMyCarsSuccessState) {
          myCarsBloc?.selectedAddedPackage = myCarsBloc!.selectedAddedPackage;
        }
      },
      builder: (context, state) {
        return PrimaryLoading(
          isLoading: false, //myCarsBloc?.isGetMyPackagesLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.availablePackages.tr(),
                style: TextStyles.bold14,
              ),
              if (widget.isFromPayment &&
                  myCarsBloc?.myPackages.isNotEmpty == true)
                RadioListTile<Package>(
                  selected: true,
                  title: Text(
                    myCarsBloc?.myPackages.first.name ?? '',
                    style: TextStyles.bold16,
                  ),
                  value: myCarsBloc!.myPackages.first,
                  groupValue: myCarsBloc?.myPackages.first,
                  onChanged: null,
                )
              else if (widget.selectedPackage != null)
                RadioListTile<Package>(
                  selected: true,
                  title: Text(widget.selectedPackage?.name ?? ''),
                  value: widget.selectedPackage!,
                  groupValue: myCarsBloc?.selectedAddedPackage,
                  onChanged: null,
                )
              else
                ...List.generate(
                  myCarsBloc!.myPackages.length,
                  (index) => RadioListTile<Package>(
                    selected: myCarsBloc?.myPackages[index].packageId ==
                        myCarsBloc?.selectedAddedPackage.packageId,
                    title: Row(
                      children: [
                        Text(
                          myCarsBloc?.myPackages[index].name ?? '',
                          style: TextStyles.bold16,
                        ),
                        horizontalSpace6,
                        if (myCarsBloc?.myPackages[index].createdAt != null)
                          Text(
                            "(${DateFormat('yyyy-MM-dd').format(DateTime.parse(myCarsBloc!.myPackages[index].createdAt!))})",
                            style: TextStyles.bold10,
                          ),
                      ],
                    ),
                    value: myCarsBloc!.myPackages[index],
                    groupValue: myCarsBloc?.selectedAddedPackage,
                    onChanged: (Package? value) {
                      setState(() {
                        myCarsBloc?.selectedAddedPackage = value!;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
