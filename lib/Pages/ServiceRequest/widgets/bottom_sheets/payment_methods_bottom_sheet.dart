import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Configurations/di/injection.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Services/cache_helper.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../PaymentWebView/payment_web_view_page.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import '../payment_widget.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  PaymentMethodsBottomSheet({super.key});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  late final WenchServiceBloc wenchServiceBloc;

  @override
  void initState() {
    wenchServiceBloc = context.read<WenchServiceBloc>();
    //wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc.add(GetRequestByIdEvent(
        activeReqId: wenchServiceBloc.activeReq?.id.toString()));
    wenchServiceBloc.add(GetConfigEvent());

    ///wenchServiceBloc.add(HandleRequestRoutesEvent());
    wenchServiceBloc.panelController.open();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return wenchServiceBloc.config?.distanceLimit == null
        ? Container()
        : WillPopScope(
            onWillPop: () {
              wenchServiceBloc.request!.requestLocationModel.distanceToDest = 0;
              return Future.value(true);
            },
            child: BottomSheetsWrapper(
              sheetBody: BlocListener<WenchServiceBloc, WenchServiceState>(
                listener: (context, state) async {
                  if (wenchServiceBloc.otherServiceIds.isNotEmpty == true) {
                    if (state is CreateRequestSuccessState) {
                      wenchServiceBloc.add(UpdateUserRequestSheetEvent(
                          userReqProcess: UserRequestProcesses.driverWaiting));
                      wenchServiceBloc.add(HandleRequestRoutesEvent());
                    }
                  }
                  print('pay sheet $state');
                  // wenchServiceBloc.add(HandleRequestRoutesEvent());
                  if (state is PaymentMethodChangedState ||
                      state is GetRequestByIdSuccessState ||
                      state is UserRequestProcessChangedState ||
                      state is GetConfigSuccessState) {
                    wenchServiceBloc.add(HandleRequestRoutesEvent());
                    await wenchServiceBloc.drawMapPath(wenchServiceBloc
                        .activeReq!.requestLocationModel.pointsClientToDest!);
                    wenchServiceBloc.add(HandleRequestRoutesEvent());
                    await wenchServiceBloc.drawMapPath(wenchServiceBloc
                        .activeReq!.requestLocationModel.pointsClientToDest!);
                  }
                  // TODO: implement listener
                  if (state is GetIFrameUrlSuccessState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return PaymentWebViewPage(
                            url: state.url!,
                            callBack: () {
                              wenchServiceBloc.add(ConfirmRequestEvent());
                              context.pop;
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is WenchServiceOnlinePaymentSuccessState) {
                    wenchServiceBloc.add(UpdateUserRequestSheetEvent(
                        userReqProcess: UserRequestProcesses.driverWaiting));
                  }
                  if (state is GetNearestDriverSuccessState) {
                    await wenchServiceBloc.assignDriverToRequest();
                  } else if (state is AssignDriverToRequestSuccessState) {
                    if (wenchServiceBloc.request?.paymentMethod ==
                        PaymentMethod.online) {
                      // await appBloc.confirmRequest();
                      wenchServiceBloc.add(GetIframeEvent(
                        amount: wenchServiceBloc.request!.fees!.toDouble(),
                        requestId: wenchServiceBloc.request!.id,
                      ));
                    } else {
                      wenchServiceBloc.add(ConfirmRequestEvent());
                    }
                  } else if (state is ConfirmRequestSuccessState) {
                    wenchServiceBloc.add(UpdateUserRequestSheetEvent(
                        userReqProcess: UserRequestProcesses.driverWaiting));
                  }
                },
                child: BlocBuilder<WenchServiceBloc, WenchServiceState>(
                  builder: (context, state) {
                    final canShowOnline =
                        wenchServiceBloc.request?.fees != null &&
                                wenchServiceBloc.request!.fees! > 0
                            ? true
                            : false;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace26,
                        PaymentWidget(
                          isSelected: wenchServiceBloc.request?.paymentMethod ==
                                  PaymentMethod.cash
                              ? true
                              : false,
                          visiablity: (wenchServiceBloc
                                          .otherServiceIds.isEmpty ==
                                      true
                                  ? _canShowCashPaymentMethod()
                                  : _canShowCashPaymentMethodOtherService()) ||
                              !canShowOnline,
                          image: AssetsImages.cash,
                          title: LocaleKeys.cash.tr(),
                          onTap: () => wenchServiceBloc.add(
                              ChangeRequestPaymentMethod(
                                  pm: PaymentMethod.cash, callBack: () {})),
                        ),
                        verticalSpace5,
                        PaymentWidget(
                          visiablity:
                              wenchServiceBloc.otherServiceIds.isEmpty == true
                                  ? _canShowCashPaymentMethod()
                                  : _canShowCashPaymentMethodOtherService(),
                          isSelected: wenchServiceBloc.request?.paymentMethod ==
                                  PaymentMethod.visa
                              ? true
                              : false,
                          image: AssetsImages.visaToDriver,
                          title: LocaleKeys.visa.tr(),
                          onTap: () => wenchServiceBloc.add(
                              ChangeRequestPaymentMethod(
                                  pm: PaymentMethod.visa, callBack: () {})),
                        ),
                        verticalSpace5,
                        PaymentWidget(
                          visiablity: canShowOnline,
                          isSelected: wenchServiceBloc.request?.paymentMethod ==
                                  PaymentMethod.online
                              ? true
                              : false,
                          image: AssetsImages.online,
                          title: LocaleKeys.onlinePayment.tr(),
                          onTap: () => wenchServiceBloc.add(
                              ChangeRequestPaymentMethod(
                                  pm: PaymentMethod.online, callBack: () {})),
                        ),
                        verticalSpace16,
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            text: LocaleKeys.confirm.tr(),
                            isLoading: state is ConfirmRequestLoadingState ||
                                state is AssignDriverToRequestLoadingState ||
                                state is GetIFrameUrlLoadingState ||
                                state is CreateRequestLoadingState ||
                                state is GetNearestDriverLoadingState,
                            onPressed: () async {
                              // if (appBloc.request.requestLocationModel.distanceToClient != null) {
                              if (wenchServiceBloc.otherServiceIds.isNotEmpty ==
                                  true) {
                                wenchServiceBloc.add(CreateOtherServiceRequest(
                                    context: context));
                                return;
                              }
                              wenchServiceBloc.request?.clientId = int.parse(
                                  await sl<CacheHelper>().get(Keys.generalID));
                              if (wenchServiceBloc.request?.paymentMethod ==
                                      PaymentMethod.cash ||
                                  wenchServiceBloc.request?.paymentMethod ==
                                      PaymentMethod.visa ||
                                  wenchServiceBloc.request?.paymentMethod ==
                                      PaymentMethod.online) {
                                wenchServiceBloc.add(GetNearestDriver());
                              } else {
                                // wenchServiceBloc.add(GetNearestDriver());

                                HelpooInAppNotification.showErrorMessage(
                                  message: LocaleKeys.comingSoonPayment.tr(),
                                );
                              }
                              // }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
  }

  bool _canShowCashPaymentMethod() {
    return wenchServiceBloc.config?.distanceLimit == null
        ? false
        : (wenchServiceBloc.request!.requestLocationModel.distanceToDest! /
                    1000)
                .ceil() <=
            int.tryParse(wenchServiceBloc.config!.distanceLimit!)!;
  }

  bool _canShowCashPaymentMethodOtherService() {
    if (wenchServiceBloc.request!.driver?.distance?.distance?.value == null) {
      return false;
    }
    return wenchServiceBloc.config?.distanceLimit == null
        ? false
        : (wenchServiceBloc.request!.driver!.distance!.distance!.value! / 1000)
                .ceil() <=
            int.tryParse(wenchServiceBloc.config!.distanceLimit!)!;
  }
}
