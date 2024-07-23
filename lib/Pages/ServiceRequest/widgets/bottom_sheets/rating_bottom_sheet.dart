import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpooappclient/Configurations/Constants/api_endpoints.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';

class RatingBottomSheet extends StatefulWidget {
  final bool isDriverArrived;
  final bool isServiceDone;

  const RatingBottomSheet({
    super.key,
    this.isDriverArrived = false,
    this.isServiceDone = false,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    super.initState();
    wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.panelController.open();

    wenchServiceBloc?.add(GetRequestByIdEvent(
        activeReqId: wenchServiceBloc?.activeReq?.id.toString()));
    wenchServiceBloc?.add(HandleRequestRoutesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) {
        if (state is RateRequestDriverSuccessState) {
          HelpooInAppNotification.showSuccessMessage(
              message: LocaleKeys.rateDriverSuccess.tr());
          context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 10.rh),
          child: BottomSheetsWrapper(
            sheetBody: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // verticalSpace32,
                    ListTile(
                      subtitle: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 25,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 233, 212, 27),
                        ),
                        onRatingUpdate: (rating) {
                          //printMeLog(rating.toString());
                          wenchServiceBloc?.rateDriverValue = rating.toString();
                        },
                      ),
                      leading: Container(
                        width: 50.rw,
                        height: 50.rh,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  wenchServiceBloc!.activeReq!.driver!.photo!)),
                          borderRadius: 11.rSp.br,
                        ),
                      ),
                      title: Text(
                        '${wenchServiceBloc?.activeReq!.driver?.name}',
                        style: TextStyles.regular24
                            .copyWith(color: ColorsManager.black),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.notes.tr(),
                            style: TextStyles.regular14
                                .copyWith(color: ColorsManager.black),
                          ),
                          TextField(
                            controller:
                                wenchServiceBloc?.rateDriverCommentCtrl,

                            /// maxLines: ,
                            onChanged: (value) {
                              wenchServiceBloc?.rateDriverCommentCtrl.text =
                                  value;
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8)),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace5,
                    PrimaryButton(
                      text: LocaleKeys.confirm.tr(),
                      height: 40,
                      width: MediaQuery.of(context).size.width / 3,
                      isLoading: state is RateRequestDriverLoadingState,
                      onPressed: () async {
                        // await wenchServiceBloc?.rateRequestDriver();
                        wenchServiceBloc?.add(RateRequestDriverEvent(
                            requestId:
                                wenchServiceBloc?.activeReq!.id.toString(),
                            rate: wenchServiceBloc?.rateDriverValue,
                            comment:
                                wenchServiceBloc?.rateDriverCommentCtrl.text,
                            rated: 'true'));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
