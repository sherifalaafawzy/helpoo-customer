import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'package:helpooappclient/Pages/ServiceRequest/widgets/bottom_sheets_wrapper.dart';
import 'package:helpooappclient/Widgets/load_asset_image.dart';

import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../generated/locale_keys.g.dart';

class ChooseOtherServiceBottomSheet extends StatefulWidget {
  const ChooseOtherServiceBottomSheet({super.key});

  @override
  State<ChooseOtherServiceBottomSheet> createState() =>
      _ChooseOtherServiceBottomSheetState();
}

class _ChooseOtherServiceBottomSheetState
    extends State<ChooseOtherServiceBottomSheet> {
  late final WenchServiceBloc _wenchServiceBloc;
  @override
  void initState() {
    _wenchServiceBloc = context.read<WenchServiceBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetsWrapper(
        sheetBody: BlocBuilder<WenchServiceBloc, WenchServiceState>(
      builder: (context, state) {
        final ids = _wenchServiceBloc.otherServiceIds;
        return Column(
          children: [
            Text(
              LocaleKeys.totalFees.tr(),
              style: TextStyles.bold16.copyWith(
                color: ColorsManager.mainColor,
              ),
            ),
            const SizedBox(height: 8.0),
            if (ids.contains(1))
              _buildItem(
                "fuel_icon",
                LocaleKeys.fuel.tr(),
              ),
            SizedBox(height: 8.0),
            if (ids.contains(3))
              _buildItem(
                "battery_icon",
                LocaleKeys.battery.tr(),
              ),
            SizedBox(height: 8.0),
            if (ids.contains(2))
              _buildItem(
                "tire_icon",
                LocaleKeys.tire.tr(),
              ),
            if (ids.contains(1)) ...[
              SizedBox(height: 8.0),
              _buildDivider(),
              _buildFuelNote(),
              _buildDivider(),
            ],
            SizedBox(height: 8.0),
            _buildTotalPrice(),
            PrimaryButton(
              height: 40.rh,
              width: 200.0,
              text: LocaleKeys.confirm.tr(),
              onPressed: () {
                _wenchServiceBloc.add(
                  UpdateUserRequestSheetEvent(
                      userReqProcess: UserRequestProcesses.paymentMethod),
                );
              },
            ),
          ],
        );
      },
    ));
  }

  Widget _buildItem(String icon, String title) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.darkGreyColor,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoadAssetImage(
            height: 30,
            width: 30,
            image: icon,
          ),
          SizedBox(width: 8.0),
          Text(
            title,
            style: TextStyles.bold16,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    // make dashed line for divider
    return Text(
      "-----------------------------------------------",
      style: TextStyles.bold14.copyWith(
        color: ColorsManager.grey,
      ),
    );
  }

  Widget _buildFuelNote() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        LocaleKeys.fuelNote.tr(),
        style: TextStyles.bold14.copyWith(
          color: ColorsManager.red,
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    final fees = _wenchServiceBloc.calculateFeesModel;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            LocaleKeys.total.tr(),
            style: TextStyles.bold16,
          ),
          Spacer(),
          // make price before discount
          if (_wenchServiceBloc
                      .calculateFeesOtherServiceModel?.discountPercent !=
                  null &&
              _wenchServiceBloc
                      .calculateFeesOtherServiceModel?.discountPercent !=
                  0)
            Text(
              _wenchServiceBloc.calculateFeesOtherServiceModel!.originalFees
                  .toString(),
              style: TextStyles.bold16.copyWith(
                color: ColorsManager.grey,
                decoration: TextDecoration.lineThrough,
                decorationColor: ColorsManager.red,
              ),
            ),
          SizedBox(width: 8.0),
          Text(
            "${_wenchServiceBloc.calculateFeesOtherServiceModel?.fees} ${LocaleKeys.egp.tr()}",
            style: TextStyles.bold16,
          ),
        ],
      ),
    );
  }
}
