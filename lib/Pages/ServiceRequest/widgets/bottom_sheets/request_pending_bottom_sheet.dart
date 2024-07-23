import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/GradientButton.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';


class RequestPendingORNotAvaliableBottomSheet extends StatefulWidget {
  final bool isDriverArrived;
  final bool isServiceDone;

  const RequestPendingORNotAvaliableBottomSheet({
    super.key,
    this.isDriverArrived = false,
    this.isServiceDone = false,
  });

  @override
  State<RequestPendingORNotAvaliableBottomSheet> createState() => _RequestPendingORNotAvaliableBottomSheetState();
}

class _RequestPendingORNotAvaliableBottomSheetState extends State<RequestPendingORNotAvaliableBottomSheet> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    super.initState();
    wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.panelController.open();

  }
  @override
  Widget build(BuildContext context) {
    return BottomSheetsWrapper(
      sheetBody: BlocBuilder<WenchServiceBloc, WenchServiceState>(
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${LocaleKeys.request.tr()} # ${wenchServiceBloc?.activeReq!.id}',
                            style: TextStyles.bold10.copyWith(color: ColorsManager.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.rSp),
                                decoration: BoxDecoration(
                                  color: widget.isServiceDone ? ColorsManager.primaryGreen : ColorsManager.white,
                                  borderRadius: 9.rSp.br,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: Text(
                                  _mapTripStateToText(),
                                  style: TextStyles.bold10.copyWith(
                                    color: widget.isServiceDone ? ColorsManager.white : ColorsManager.mainColor,
                                  ),
                                ),
                              ),
                              verticalSpace6,
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  verticalSpace16,
                  Container(
                    width: 106.rw,
                    height: 106.rw,
                    padding: EdgeInsets.all(8.rw),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.darkGreyColor,
                    ),
                    child: const LoadSvg(
                      image: AssetsImages.questionIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  verticalSpace16,
                  Container(
                    width: 126.rw,
                    height: 50.rw,
                    child: GradientButton(
                      onPressed: () {
                        wenchServiceBloc?.launchDialPadWithPhoneNumber('17000');
                      },
                      isWithIcon: true,
                      title: LocaleKeys.call17000.tr(),
                      icon: AssetsImages.call,
                      colors: const [
                        Color(0xff39B54A),
                        Color(0xff00A651),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  _mapTripStateToText() {
    if (wenchServiceBloc?.activeReq!.status == ServiceRequestStatus.accepted) {
      return LocaleKeys.driverOnWay.tr();
    } else if (wenchServiceBloc?.activeReq!.status == ServiceRequestStatus.arrived) {
      return LocaleKeys.driverArrived.tr();
    } else if (wenchServiceBloc?.activeReq!.status == ServiceRequestStatus.done) {
      return LocaleKeys.done.tr();
    } else if (wenchServiceBloc?.activeReq!.status == ServiceRequestStatus.pending) {
      return LocaleKeys.pending.tr();
    } else {
      return LocaleKeys.somethingWentWrong.tr();
    }
  }
}
