import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

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

class TripPricingBottomSheet extends StatefulWidget {
  TripPricingBottomSheet({super.key, required this.serviceRequestBloc});

  WenchServiceBloc? serviceRequestBloc;

  @override
  State<TripPricingBottomSheet> createState() => _TripPricingBottomSheetState();
}

class _TripPricingBottomSheetState extends State<TripPricingBottomSheet> {
  WenchServiceBloc? serviceRequestBloc;

  @override
  void initState() {
    super.initState();
    serviceRequestBloc = widget.serviceRequestBloc;
//    serviceRequestBloc = context.read<WenchServiceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) async {
        if (state is CreateRequestSuccessState) {
          serviceRequestBloc?.add(UpdateUserRequestSheetEvent(
              userReqProcess: UserRequestProcesses.paymentMethod));
        } else if ( //state is UpdateUserRequestSheetEvent
            state is UserRequestProcessChangedState) {
          //   await serviceRequestBloc?.drawMapPath(serviceRequestBloc!.activeReq!.requestLocationModel.pointsClientToDest!);
          serviceRequestBloc?.add(HandleRequestRoutesEvent());
        }
      },
      builder: (context, state) {
        return BottomSheetsWrapper(
          sheetBody: BlocBuilder<WenchServiceBloc, WenchServiceState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.totalFees.tr(),
                      style: TextStyles.bold16.copyWith(
                          color: ColorsManager.mainColor, fontSize: 17.rSp),
                    ),
                    verticalSpace(15),
                    Row(
                      children: [
                        WinchItemWidget(
                          isColumn: true,
                          width: MediaQuery.of(context).size.width / 2.7,
                          height: serviceRequestBloc
                                      ?.getRequestOriginalFees()
                                      ?.isNotEmpty ??
                                  false
                              ? 100
                              : 70,
                          winchName:
                              serviceRequestBloc!.selectedWenchType!.name,
                          // winchPrice: appBloc.calculateFeesModel != null ? appBloc.calculateFeesModel!.euroFees! : "",
                          originalPrice: serviceRequestBloc?.activeReq?.corporateCompanyId == null ?serviceRequestBloc?.getRequestOriginalFees() : "***"
                              ,
                          winchPrice: serviceRequestBloc?.activeReq?.corporateCompanyId == null ? serviceRequestBloc?.getRequestFees() : "***",
                          //  imageName: serviceRequestBloc?.request?.carServiceTypeId == 4 ? AssetsImages.normalWinch : AssetsImages.euroWinch,
                          onTap: () {},
                          // isWithCloseButton: true,
                        ),
                        horizontalSpace10,
                        WinchItemWidget(
                          isColumn: true,
                          winchName: LocaleKeys.passengerCar.tr(),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: serviceRequestBloc
                                      ?.getRequestOriginalFees()
                                      ?.isNotEmpty ??
                                  false
                              ? 100
                              : 70,

                          winchPrice: '0',
                          //   imageName: AssetsImages.passengersCar,
                          onTap: () {},
                          // isWithCloseButton: true,
                        ),
                      ],
                    ),
                    verticalSpace10,
                    Center(
                      child: Container(
                        width: 163.rw,
                        height: 32.rh,
                        decoration: BoxDecoration(
                          color: ColorsManager.darkGreyColor,
                          borderRadius: 10.rSp.br,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${serviceRequestBloc?.getRequestFees() ?? ''} ${'EGP'.tr()}',
                          style: TextStyles.bold14.copyWith(
                            color: ColorsManager.black,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace10,
                    PrimaryButton(
                      isLoading: state is CreateRequestLoadingState ||
                          state is UpdateMapState,
                      // width: 170.rh,
                      isDisabled: state is CreateRequestLoadingState ||
                          state is UpdateMapState,
                      text: LocaleKeys.continueToPayment.tr(),
                      onPressed: () async {
                        print('on click cont pay state  ${state}');
                        serviceRequestBloc
                            ?.add(CreateServiceRequest(context: context));
                        //  await serviceRequestBloc?.createServiceRequest();
                        //   serviceRequestBloc?.updateUserRequestSheetState(UserRequestProcesses.paymentMethod);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
