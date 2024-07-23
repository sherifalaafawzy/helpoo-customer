import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/fnol/latestFnolModel.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

import '../fnol_bloc.dart';
import '../widgets/chooseBillTime.dart';

import '../widgets/custom_date_picker.dart';
import '../widgets/mapSearchTextField.dart';
import 'fnol_steps.dart';

class BillRequest extends StatefulWidget {
  BillRequest({Key? key, required this.fnolBloc, required this.fnolModel})
      : super(key: key);
  FnolBloc? fnolBloc;
  LatestFnolModel? fnolModel;

  @override
  State<BillRequest> createState() => _BillRequestState();
}

class _BillRequestState extends State<BillRequest> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
//fnolBloc = context.read<FnolBloc>();
    fnolBloc = widget.fnolBloc;
    fnolBloc?.add(InitialFNOLEvent(context: context));
    fnolBloc?.add(GetLocationFromFnolEvent());
    fnolBloc?.fnolModel = widget.fnolModel;
    print('fnolBloc?.fnolModel?.id');
    print(fnolBloc?.fnolModel?.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) async {
        if (state is UpdateFnolBillSuccess) {
          showSuccessDialog(
            context,
            title: LocaleKeys.fnolStepDoneMsg.tr(),
            onPressed: () {
              context.pop;
              // context.pushNamed(PageRouteName.fNOLStepsPage);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => FnolBloc(),
                  child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                ),
              ));
            },
          );
          fnolBloc?.showFinalDeliveryData = false;
        } else if (state is FnolInitial) {
          fnolBloc?.add(GetLocationFromFnolEvent());
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          alignment: AlignmentDirectional.topStart,
          extendBodyBehindAppBar: false,
          verticalPadding: 0,
          appBarTitle: LocaleKeys.billDeliveryRequest.tr(),
          body: BlocConsumer<FnolBloc, FnolState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SingleChildScrollView(
                child: AnimatedContainer(
                  duration: duration500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.billDeliveryRequest.tr(),
                        style: TextStyles.bold20,
                      ),
                      verticalSpace20,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.gray20,
                          borderRadius: 14.rSp.br,
                          boxShadow: primaryShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.date.tr(),
                              style: TextStyles.bold16,
                            ),
                            Center(
                              child: BlocProvider.value(
                                value: fnolBloc!,
                                child: CustomDatePicker(fnolBloc: fnolBloc),
                              ),
                            ),
                            verticalSpace10,
                            Text(
                              LocaleKeys.chooseDateRange.tr(),
                              style: TextStyles.bold16,
                            ),
                            verticalSpace10,
                            BlocProvider.value(
                              value: fnolBloc!,
                              child: ChooseBillTime(fnolBloc: fnolBloc),
                            ),
                            Text(
                              LocaleKeys.billDeliveryLocation.tr(),
                              style: TextStyles.bold16,
                            ),
                            BlocProvider.value(
                              value: fnolBloc!,
                              child: MapSearchTextField(
                                fnolBloc: fnolBloc,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace20,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.gray20,
                          borderRadius: 14.rSp.br,
                          boxShadow: primaryShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.additionalInformation.tr(),
                              style: TextStyles.bold16,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                maxLines: 4,
                                style: const TextStyle(
                                    color: ColorsManager.mainColor),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: ColorsManager.mainColor),
                                  hintText: '',
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                onChanged: (value) {
                                  fnolBloc?.billDeliveryNotes = value;
                                },

                              ),
                            )
                          ],
                        ),
                      ),
                      verticalSpace20,
                      fnolBloc?.showFinalDeliveryData == true
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.gray20,
                                borderRadius: 14.rSp.br,
                                boxShadow: primaryShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.finalDetails.tr(),
                                    style: TextStyles.bold16,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${LocaleKeys.billWillDeliverat.tr()} ${DateFormat('yyyy-MM-dd').format(fnolBloc!.billDeliveryDate)} ${LocaleKeys.atDateRange.tr()} ${fnolBloc?.billDeliveryTimeString}",
                                              style: TextStyles.semiBold18
                                                  .copyWith(
                                                color: ColorsManager.mainColor,
                                              )),
                                          Text(
                                            LocaleKeys.billDeliveryLocation
                                                .tr(),
                                            style: TextStyles.bold16,
                                          ),
                                          Text(
                                              fnolBloc?.billDeliveryLocation ??
                                                  '',
                                              style: TextStyles.semiBold18
                                                  .copyWith(
                                                color: ColorsManager.mainColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavBar: Padding(
            padding: const EdgeInsetsDirectional.only(
                bottom: 20, start: 20, end: 20, top: 8),
            child: PrimaryButton(
              isLoading: state is UpdateFnolBillLoading,
              text: LocaleKeys.confirm.tr(),
              onPressed: () {
                print(fnolBloc?.showFinalDeliveryData.toString());
                if (fnolBloc?.showFinalDeliveryData == false) {
                  fnolBloc?.renderFinalBillData(true);
                } else {
                  fnolBloc?.billDeliveryLatLng = fnolBloc?.currentLatLng;

                  fnolBloc?.updateFnolBill();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
