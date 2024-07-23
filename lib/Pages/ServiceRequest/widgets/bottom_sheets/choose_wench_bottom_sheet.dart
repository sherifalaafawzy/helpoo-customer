import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/fees_response_model.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Models/service_request/service_request_model.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import '../winch_item_widget.dart';

class ChooseWenchBottomSheet extends StatefulWidget {
  ChooseWenchBottomSheet({Key? key, required this.wenchServiceBloc})
      : super(key: key);
  WenchServiceBloc? wenchServiceBloc;

  @override
  State<ChooseWenchBottomSheet> createState() => _ChooseWenchBottomSheetState();
}

class _ChooseWenchBottomSheetState extends State<ChooseWenchBottomSheet> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    super.initState();
    wenchServiceBloc = widget.wenchServiceBloc;
    // wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc
        ?.getServiceRequestFeesImpl(updateSheet: false)
        .then((value) {});
    wenchServiceBloc?.panelController.open();
    wenchServiceBloc?.mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) async {},
      builder: (context, state) {
        return BlocBuilder<WenchServiceBloc, WenchServiceState>(
          builder: (context, state) {
            return BottomSheetsWrapper(
              sheetBody: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.selectWenchType.tr(),
                    style: TextStyles.bold16.copyWith(
                      color: ColorsManager.mainColor,
                    ),
                  ),
                  verticalSpace5,
                  Text(
                    LocaleKeys.selectWenchNote.tr(),
                    style: TextStyles.regular11.copyWith(
                      color: ColorsManager.textColor,
                    ),
                  ),
                  verticalSpace10,
                  WinchItemWidget(isCorpRequest: false,
                    height: 40,
                    color: wenchServiceBloc?.selectedWenchType == WenchType.norm
                        ? ColorsManager.primaryGreen.withOpacity(0.5)
                        : ColorsManager.lightGreyColor,
                    winchName: LocaleKeys.normalWench.tr(),
                    winchPrice: wenchServiceBloc?.calculateFeesModel != null
                        ? wenchServiceBloc?.calculateFeesModel!.normFees
                        : "...",
                    originalPrice: wenchServiceBloc?.calculateFeesModel !=
                                null &&
                            wenchServiceBloc?.calculateFeesModel!.normPercent !=
                                '0'
                        ? '${wenchServiceBloc?.calculateFeesModel!.normOriginalFees}'
                        : null,
                    imageName: AssetsImages.normalWinch,
                    onTap: () {
                      setState(() {
                        wenchServiceBloc?.request?.carServiceTypeId = 4;
                        wenchServiceBloc?.selectedWenchType = WenchType.norm;
                      });
                    },
                  ),
                  verticalSpace10,
                  WinchItemWidget(
                    height: 40,
                    color: wenchServiceBloc?.selectedWenchType == WenchType.euro
                        ? ColorsManager.primaryGreen.withOpacity(0.5)
                        : ColorsManager.lightGreyColor,
                    winchName: LocaleKeys.euroWench.tr(),
                    winchPrice: wenchServiceBloc?.calculateFeesModel != null
                        ? wenchServiceBloc?.calculateFeesModel!.euroFees!
                        : "",
                    originalPrice: wenchServiceBloc?.calculateFeesModel !=
                                null &&
                            wenchServiceBloc?.calculateFeesModel!.euroPercent !=
                                '0'
                        ? wenchServiceBloc?.calculateFeesModel!.euroOriginalFees
                        : null,
                    imageName: AssetsImages.euroWinch,
                    onTap: () {
                      setState(() {
                        wenchServiceBloc?.request?.carServiceTypeId = 5;
                        wenchServiceBloc?.selectedWenchType = WenchType.euro;
                      });
                    },
                  ),
                  verticalSpace10,
                  PrimaryButton(
                    text: LocaleKeys.confirm.tr(),
                    onPressed: () {
                      if(wenchServiceBloc?.selectedWenchType == WenchType.norm && wenchServiceBloc?.calculateFeesModel!.normFees == "0"||
                     wenchServiceBloc?.selectedWenchType == WenchType.euro && wenchServiceBloc?.calculateFeesModel!.euroFees == "0" ){
wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
                            userReqProcess:
                                UserRequestProcesses.selectedWenchDetails));
wenchServiceBloc
                                ?.add(CreateServiceRequest(context: context));

                     }else{
  if (wenchServiceBloc?.selectedWenchType != null) {
                        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
                            userReqProcess:
                                UserRequestProcesses.selectedWenchDetails));
                      } else {
                        HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.selectWenchType.tr(),
                        );
                      }
                     }
                    
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
