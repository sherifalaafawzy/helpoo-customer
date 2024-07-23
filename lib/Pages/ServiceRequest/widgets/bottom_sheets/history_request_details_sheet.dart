import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/show_success_dialog.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../../service_request_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';

class HistoryRequestDetailsSheet extends StatefulWidget {
  const HistoryRequestDetailsSheet({Key? key}) : super(key: key);

  @override
  State<HistoryRequestDetailsSheet> createState() =>
      _HistoryRequestDetailsSheetState();
}

class _HistoryRequestDetailsSheetState
    extends State<HistoryRequestDetailsSheet> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    super.initState();
    wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.add(HandleRequestRoutesEvent());
    wenchServiceBloc?.panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) {
        if (state is GetNearestDriverErrorState) {
          showPrimaryDialog(context,
              title: "Error",
              content: state.error,
              buttonTitle: "Back to Home", onPressed: () {
            //  appBloc.isHomeScreenRoute = true;

            context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
          });
        }
      },
      builder: (context, state) {
        return (wenchServiceBloc?.request?.done == true ||
                wenchServiceBloc?.activeReq?.done == true)
            ? _buildDoneView()
            : _buildCanceledView();
      },
    );
  }

  _buildDoneView() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.rh),
          child: BottomSheetsWrapper(
            sheetBody: Column(
              children: [
                verticalSpace20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: 64.rw,
                          // height: 27.rh,
                          padding: EdgeInsets.all(6.rSp),
                          decoration: BoxDecoration(
                            color: ColorsManager.darkGreyColor,
                            borderRadius: 9.rSp.br,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.fees.tr(),
                                style: TextStyles.bold10.copyWith(
                                  color: ColorsManager.black,
                                ),
                              ),
                              horizontalSpace6,
                              Column(
                                children: [
                                  Container(
                                    // height: 14.rh,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.white,
                                      borderRadius: 9.rSp.br,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      // vertical: 2.rh,
                                      horizontal: 5.rw,
                                    ),
                                    child: Text(
                                      ' ${wenchServiceBloc?.getRequestFees()} ',
                                      style: TextStyles.bold10.copyWith(
                                          color: const Color(0xff8F8E90),
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  verticalSpace6,
                                  if (wenchServiceBloc
                                              ?.getRequestOriginalFees() !=
                                          null &&
                                      wenchServiceBloc
                                              ?.getRequestOriginalFees() !=
                                          "")
                                    Container(
                                      // height: 14.rh,
                                      decoration: BoxDecoration(
                                        color: ColorsManager.white,
                                        borderRadius: 9.rSp.br,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4)),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        // vertical: 2.rh,
                                        horizontal: 5.rw,
                                      ),
                                      child: Text(
                                        ' ${wenchServiceBloc?.getRequestOriginalFees()} ',
                                        style: TextStyles.bold10.copyWith(
                                            color: const Color(0xff8F8E90)
                                                .withOpacity(0.5),
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                              horizontalSpace6,
                            ],
                          ),
                        ),
                        verticalSpace6,
                        Text(
                          '${LocaleKeys.request.tr()} # ${wenchServiceBloc?.activeReq!.id}',
                          style: TextStyles.bold10
                              .copyWith(color: ColorsManager.black),
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
                                color: ColorsManager.primaryGreen,
                                borderRadius: 9.rSp.br,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Text(
                                LocaleKeys.done.tr(),
                                style: TextStyles.bold10.copyWith(
                                  color: ColorsManager.white,
                                ),
                              ),
                            ),
                            verticalSpace6,
                            Text(
                              '${wenchServiceBloc?.activeReq!.driver?.name}',
                              style: TextStyles.regular12
                                  .copyWith(color: ColorsManager.black),
                            ),
                            verticalSpace4,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${wenchServiceBloc?.activeReq!.driver?.averageRating}',
                                  style: TextStyles.bold12.copyWith(
                                    color: const Color(0xff8F8E90),
                                  ),
                                ),
                                horizontalSpace6,
                                const LoadSvg(
                                  image: AssetsImages.star,
                                  isIcon: true,
                                  color: Color(0xffFFC200),
                                ),
                              ],
                            ),
                            verticalSpace4,
                          ],
                        ),
                        horizontalSpace6,
                        Container(
                          width: 60.rw,
                          height: 60.rh,
                          decoration: BoxDecoration(
                            color: ColorsManager.darkGreyColor,
                            borderRadius: 11.rSp.br,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.rh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                horizontalSpace6,
                if (wenchServiceBloc
                        ?.activeReq?.requestLocationModel?.distanceToDest !=
                    null)
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.rh, horizontal: 12.rw),
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
                      children: [
                        Text(
                          LocaleKeys.distance.tr(),
                          style: TextStyles.regular11.copyWith(
                              color: ColorsManager.white, fontSize: 8),
                        ),
                        Text(
                          '${wenchServiceBloc?.activeReq!.requestLocationModel.distanceToDest?.toDistanceKM()}',
                          style: TextStyles.bold10
                              .copyWith(color: ColorsManager.white),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 60.rw),
            child: Icon(Icons.check_circle,
                color: ColorsManager.mainColor, size: 100.rh),
          ),
        )
      ],
    );
  }

  _buildCanceledView() {
    return BottomSheetsWrapper(
      sheetBody: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: 10),
          Text(
            LocaleKeys.canceled.tr(),
            style: const TextStyle(
              color: ColorsManager.mainColor,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
