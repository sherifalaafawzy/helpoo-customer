import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../bottom_sheets_wrapper.dart';
import '../winch_item_widget.dart';


class PassengersCarBottomSheet extends StatefulWidget {
  const PassengersCarBottomSheet({super.key});

  @override
  State<PassengersCarBottomSheet> createState() => _PassengersCarBottomSheetState();
}

class _PassengersCarBottomSheetState extends State<PassengersCarBottomSheet> {
  WenchServiceBloc? serviceRequestBloc;

  @override
  void initState() {
    super.initState();
    serviceRequestBloc = context.read<WenchServiceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetsWrapper(
      sheetBody: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.wantPassengerCar.tr(),
            style: TextStyles.bold16.copyWith(
              color: ColorsManager.mainColor,
            ),
          ),
          verticalSpace(15),
          WinchItemWidget(
            winchName: LocaleKeys.passengerCar.tr(),
            winchPrice: '***',
            imageName: AssetsImages.passengersCar,
            onTap: () {},
          ),
          verticalSpace20,
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: LocaleKeys.confirm.tr(),
                  onPressed: () {
                    HelpooInAppNotification.showMessage(message: LocaleKeys.comingSoon.tr());
                    // appBloc.emitState(ClientShowPricingSheetState());
                  },
                ),
              ),
              horizontalSpace10,
              Expanded(
                child: PrimaryButton(
                  text: LocaleKeys.skip.tr(),
                  onPressed: () {
                    serviceRequestBloc?.add(UpdateUserRequestSheetEvent(
                        userReqProcess:
                        UserRequestProcesses.pricingSheet));
                 //   appBloc.updateUserRequestSheetState(UserRequestProcesses.pricingSheet);
                  },
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
