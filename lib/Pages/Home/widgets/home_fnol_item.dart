// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import '../../../Models/fnol/latestFnolModel.dart';

import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../FNOL/fnol_bloc.dart';
import '../../FNOL/pages/fnol_summary.dart';
import 'text_container_item.dart';

class HomeFNOLItem extends StatelessWidget {
  LatestFnolModel? fnol;

  HomeFNOLItem({Key? key, required this.fnol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.rSp),
      decoration: BoxDecoration(
        borderRadius: 20.rSp.br,
        color: ColorsManager.lightGreyColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.request.tr()} # ${fnol!.id}',
                style:
                    TextStyles.bold16.copyWith(color: ColorsManager.mainColor),
              ),
              verticalSpace4,
              Text(
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(fnol!.createdAt!)),
                // 'يوم الاربعاء الموافق 2 ابريل 2023',
                style: TextStyles.medium12,
              ),
              verticalSpace4,
              Row(
                children: [
                  TextContainerItem(
                    text: fnol!.car!.manufacturer!.name,
                    textColor: ColorsManager.mainColor,
                  ),
                  horizontalSpace4,
                  TextContainerItem(
                    text: fnol!.car!.carModel!.name,
                    textColor: ColorsManager.mainColor,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              PrimaryButton(
                text: LocaleKeys.details.tr(),
                backgroundColor: ColorsManager.mainColor,
                textStyle: TextStyles.semiBold14.copyWith(
                  color: ColorsManager.white,
                ),
                width: 90.rw,
                height: 35.rh,
                onPressed: () {
                  //  appBloc.isHomeScreenRoute = false;
                  //  appBloc.fnolModel = fnol;

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => FnolBloc(),
                      child: FnolSummary(fnol: fnol),
                    ),
                  ));
                //  context.pushNamed(PageRouteName.fnolSummaryPage);
                },
              ),
              verticalSpace4,
              PrimaryButton(
                text: LocaleKeys.continueFNOL.tr(),
                backgroundColor: ColorsManager.secondaryGrey,
                textStyle: TextStyles.semiBold14.copyWith(
                  color: ColorsManager.white,
                ),
                width: 90.rw,
                height: 35.rh,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => FnolBloc(),
                      child: FNOLStepsPage(fnol: fnol),
                    ),
                  ));
                  //   appBloc.isHomeScreenRoute = false;
                  //   appBloc.fnolModel = fnol;
                  //   context.pushNamed(PageRouteName.fNOLStepsPage);
                },
              ),
            ],
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
                          'call Driver',
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
