import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/days_extensions.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/other_service/other_service_view.dart';

import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Home/home_bloc.dart';
import '../pages/WenchService/wench_service_bloc.dart';
import '../pages/WenchService/wench_service_request_map.dart';

class RoadServiceLatestReqItem extends StatelessWidget {
  final ServiceRequest serviceRequest;

  const RoadServiceLatestReqItem({Key? key, required this.serviceRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.rSp),
      decoration: BoxDecoration(
        borderRadius: 20.rSp.br,
        color: ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.request.tr()} # ${serviceRequest.id}',

                // 'رقم الطلب : ${serviceRequest.id}',
                style:
                    TextStyles.bold16.copyWith(color: ColorsManager.mainColor),
              ),
              verticalSpace4,
              Text(
                '${serviceRequest.createdAt?.dayMonthYearFormat}',
                style: TextStyles.medium12,
              ),
            ],
          ),
          PrimaryButton(
            text: LocaleKeys.details.tr(),
            backgroundColor: ColorsManager.mainColor,
            textStyle:
                TextStyles.semiBold14.copyWith(color: ColorsManager.white),
            width: 90.rw,
            height: 35.rh,
            onPressed: () {
              // print('from road serviec ${serviceRequest.requestLocationModel.clientPoint}');
              if ([4, 5, 6]
                  .contains(serviceRequest.selectedTowingService?.firstOrNull))
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) => WenchServiceBloc()),
                            BlocProvider(create: (context) => HomeBloc()),
                          ],
                          child: ServiceRequestWenchMapsPage(
                            isHistoryReq: true,
                            serviceRequest: serviceRequest,
                          ),
                        ),
                    settings: RouteSettings(arguments: serviceRequest)));
              else {
                final Map<String, bool> otherServices = {
                  'fuel': serviceRequest.selectedTowingService?.contains(1) ??
                      false,
                  'tire': serviceRequest.selectedTowingService?.contains(2) ??
                      false,
                  'battery':
                      serviceRequest.selectedTowingService?.contains(3) ??
                          false,
                };
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) => WenchServiceBloc()),
                            BlocProvider(create: (context) => HomeBloc()),
                          ],
                          child: OtherRequestsPage(
                            isHistoryReq: true,
                            serviceRequest: serviceRequest,
                            otherServices: otherServices,
                          ),
                        ),
                    settings: RouteSettings(arguments: serviceRequest)));
              }

              /*  context.pushTo(
                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => WenchServiceBloc()),
                    BlocProvider(create: (context) => HomeBloc()),
                  ],
                  child: ServiceRequestWenchMapsPage(
                    isHistoryReq: true,
                  ),
                ),
              );*/
              // appBloc.activeReq = serviceRequest;
              // appBloc.historyRequestModel = serviceRequest;
              //  context.pushTo(ServiceRequestMapsPage(isHistoryReq: true));
            },
          ),
        ],
      ),
    );
  }

  Column _infoContainerItem({
    required int index,
    required String content,
    bool isDriver = false,
    String? driverName,
    String? driverPhone,
    String? driverImage,
  }) {
    List<String> titles = [
      'Driver Info',
      'Distance',
      'Time',
    ];
    return Column(
      children: [
        Text(
          titles[index],
          style: TextStyles.medium14.copyWith(
            color: ColorsManager.mainColor,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.rSp),
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: 15.rSp.br,
          ),
          child: Row(
            children: [
              if (isDriver) ...[
                Container(
                  padding: EdgeInsets.all(3.rSp),
                  decoration: BoxDecoration(
                    color: ColorsManager.mainColor,
                    borderRadius: 15.rSp.br,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          LocaleKeys.callDriver.tr(),
                          style: TextStyles.medium10.copyWith(
                            color: ColorsManager.white,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.phone,
                        color: ColorsManager.white,
                        size: 14.rSp,
                      ),
                    ],
                  ),
                ),
                horizontalSpace8,
              ],
              Text(
                isDriver ? driverName! : content,
                style: TextStyles.medium12,
              ),
              if (isDriver) ...[
                horizontalSpace4,
                ClipRRect(
                  borderRadius: 100.br,
                  child: LoadAssetImage(
                    image: driverImage!,
                    width: 20.rSp,
                    height: 20.rSp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
