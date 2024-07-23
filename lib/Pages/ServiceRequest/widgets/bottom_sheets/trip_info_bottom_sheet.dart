import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import '../winch_item_widget.dart';

class TripInformationBottomSheet extends StatefulWidget {
  const TripInformationBottomSheet({
    super.key,
  });

  @override
  State<TripInformationBottomSheet> createState() =>
      _TripInformationBottomSheetState();
}

class _TripInformationBottomSheetState
    extends State<TripInformationBottomSheet> {
  WenchServiceBloc? serviceRequestBloc;

  @override
  void initState() {
    super.initState();
    serviceRequestBloc = context.read<WenchServiceBloc>();

    serviceRequestBloc
        ?.getServiceRequestFeesImpl(updateSheet: false)
        .then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WenchServiceBloc, WenchServiceState>(
      bloc: serviceRequestBloc,
      builder: (context, state) {
        final carServiceTypeId = serviceRequestBloc?.request?.carServiceTypeId;
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.rh),
              child: BottomSheetsWrapper(
                sheetBody: Padding(
                  padding: EdgeInsets.only(top: 50.rh),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WinchItemWidget(
                        winchName: LocaleKeys.fees.tr(),
                        originalPrice:serviceRequestBloc?.activeReq?.corporateCompanyId == null ? serviceRequestBloc?.getRequestOriginalFees():"***"
                            ,
                        winchPrice:serviceRequestBloc?.activeReq?.corporateCompanyId == null ? serviceRequestBloc?.getRequestFees():"***",
                        imageName: carServiceTypeId == 4
                            ? AssetsImages.normalWinch
                            : carServiceTypeId == 5
                                ? AssetsImages.euroWinch
                                : AssetsImages.n300Stepper,
                        onTap: () {},
                      ),
                      verticalSpace20,
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                          isLoading: state is CreateRequestLoadingState ||
                              state is UpdateMapState,
                          text: LocaleKeys.continueToPayment.tr(),
                          onPressed: () {
                            serviceRequestBloc
                                ?.add(CreateServiceRequest(context: context));
                            //  serviceRequestBloc?.updateUserRequestSheetState(UserRequestProcesses.passengersSheet);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.rh),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.rw,
                      height: 80.rh,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: 9.rSp.br,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.distance.tr(),
                            style: TextStyles.regular11.copyWith(
                              color: Colors.white,
                              fontSize: 10.rSp,
                            ),
                          ),
                          // verticalSpace5,
                          Text(
                            '${serviceRequestBloc?.request?.requestLocationModel.distanceToDest!.toDistanceKM()}',
                            style: TextStyles.bold14.copyWith(
                              fontSize: 15.rSp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalSpace6,
                    Container(
                      width: 80.rw,
                      height: 80.rh,
                      padding: EdgeInsets.all(10.rSp),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: 9.rSp.br,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.time.tr(),
                            style: TextStyles.regular11.copyWith(
                              color: Colors.white,
                              fontSize: 10.rSp,
                            ),
                          ),
                          // verticalSpace5,
                          Text(
                            '${serviceRequestBloc?.request?.requestLocationModel.timeToDest!.toTimeMin()}',
                            // '${appBloc.request.driverDirectionDetails?.durationText}',
                            style: TextStyles.bold14.copyWith(
                              fontSize: 15.rSp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 70.rw,
                      height: 70.rh,
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryGreen,
                        borderRadius: 9.rSp.br,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.arrivalTime.tr(),
                            style: TextStyles.regular11.copyWith(
                              color: Colors.black,
                              fontSize: 10.rSp,
                            ),
                          ),
                          // verticalSpace5,
                          Text(
                            serviceRequestBloc?.getRequestETA() ?? '',
                            style: TextStyles.bold14.copyWith(
                              fontSize: 15.rSp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
