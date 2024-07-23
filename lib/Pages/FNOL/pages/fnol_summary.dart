import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../Configurations/Constants/api_endpoints.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/fnol/latestFnolModel.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/online_image_viewer.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../fnol_bloc.dart';
import '../widgets/audio/audioPlayer.dart';
import '../widgets/fnol_summary_widget.dart';
import '../widgets/pdfView.dart';

class FnolSummary extends StatefulWidget {
  FnolSummary({Key? key, required this.fnol}) : super(key: key);
  LatestFnolModel? fnol;

  @override
  State<FnolSummary> createState() => _FnolSummaryState();
}

class _FnolSummaryState extends State<FnolSummary> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    fnolBloc = context.read<FnolBloc>();
    if (widget.fnol != null) {
      fnolBloc?.fnolModel = widget.fnol;
    }
    fnolBloc?.mainImages = [];
    fnolBloc?.additionalImages = [];
    fnolBloc?.policeImages = [];
    fnolBloc?.beforeImages = [];
    fnolBloc?.supplementImages = [];
    fnolBloc?.reservayImages = [];
    fnolBloc?.setFnolSummaryImages();
    super.initState();
  }

  @override
  void dispose() {
    if ((fnolBloc?.cameraController?.value.isInitialized ?? false)) {
      fnolBloc?.cameraController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(fnolBloc?.fnolModel!.commentUser);
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      appBarTitle: LocaleKeys.fnolSteps.tr(),
      onBackTab: () {
//        fnolBloc?.isHomeScreenRoute = true;

        context.pushNamed(PageRouteName.mainScreen);
      },
      body: BlocConsumer<FnolBloc, FnolState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${LocaleKeys.fnol.tr()} # ${fnolBloc?.fnolModel!.id}',
                  style: TextStyles.bold20,
                ),
                verticalSpace12,
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fnolBloc?.mainImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 250,
                        height: double.infinity,
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InterActiveOnlineImage(
                                imgUrl: imagesBaseUrl +
                                    fnolBloc!.mainImages[index].imagePath!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              fnolBloc!.getImageDescription(
                                  fnolBloc?.mainImages[index].imageName ?? ""),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                fnolBloc?.additionalImages.isNotEmpty ?? false
                    ? FnolWidgetSummary(
                        title: LocaleKeys.additionalImages.tr(),
                        images: fnolBloc?.additionalImages,
                      )
                    : Container(),
                verticalSpace12,
                FnolWidgetSummary(
                  title: LocaleKeys.accidentType.tr(),
                  locationName: fnolBloc?.fnolModel!.accidentTypes!
                      .map((e) => e.arName ?? '')
                      .toList()
                      .toString()
                      .replaceAll(',', '\n')
                      .replaceAll(']', '')
                      .replaceAll('[', ''),
                ),
                verticalSpace12,
                FnolWidgetSummary(
                  title: LocaleKeys.accidentDescription.tr(),
                  locationName: fnolBloc?.fnolModel!.comment!,
                  voiceComment: fnolBloc!.fnolModel?.commentUser != null &&
                          fnolBloc!.fnolModel!.commentUser!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: audioPlayer(
                            source: fnolBloc!.fnolModel!.commentUser!,
                          ),
                        )
                      : null,
                ),
                verticalSpace12,
                FnolWidgetSummary(
                  icon: AssetsImages.pin,
                  title: LocaleKeys.accidentLocation.tr(),
                  locationName: fnolBloc?.fnolModel!.location!.address ?? "",
                ),
                verticalSpace12,
                if (fnolBloc!.fnolModel!.carAccidentReports!
                    .where((element) => element.pdfReportId == 16
                        //||element.pdfReportId==14
                        )
                    .isNotEmpty)
                  FnolWidgetSummary(
                    title: LocaleKeys.accidentReport.tr(),
                    icon: AssetsImages.pin,
                    locationName: LocaleKeys.aiReport.tr(),
                    button: Expanded(
                      child: PrimaryButton(
                        text: LocaleKeys.open.tr(),
                        onPressed: () {
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfView(
                                  isFile: false,
                                  pdf: imagesBaseUrl +
                                      fnolBloc!.fnolModel!.carAccidentReports!
                                          .where((element) =>
                                              element.pdfReportId == 16)
                                          .first
                                          .report!,
                                ),
                              ),
                            );
                          } /*else {
                            HelpooInAppNotification.showMessage(
                                message: "Still Processing");
                          }*/
                        },
                      ),
                    ),
                  ),
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("policeReport") ??
                        false
                    ? FnolWidgetSummary(
                        title: LocaleKeys.policeReport.tr(),
                        images: fnolBloc?.policeImages,
                      )
                    : Container(),
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("bRepair") ?? false
                    ? Column(children: [
                        ...fnolBloc!.fnolModel!.beforeRepairLocation!.map((e) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: FnolWidgetSummary(
                                title: LocaleKeys.beforeRepairInspection.tr(),
                                locationName: e.name ?? "",
                                locationAddress: e.address ?? "",
                                lat: e.lat,
                                lng: e.lng,
                                images: fnolBloc?.beforeImages,
                              ),
                            ))
                      ])
                    : Container(),
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("supplement") ?? false
                    ? Column(children: [
                        ...fnolBloc!.fnolModel!.supplementLocation!
                            .map((e) => FnolWidgetSummary(
                                  title: LocaleKeys.reservay.tr(),
                                  locationName: e.name ?? "",
                                  locationAddress: e.address ?? "",
                                  lat: e.lat,
                                  lng: e.lng,
                                  images: fnolBloc?.supplementImages,
                                ))
                      ])
                    : Container(),
                verticalSpace12,
                fnolBloc?.fnolModel!.resurveyLocation != [] &&
                        fnolBloc?.fnolModel!.resurveyLocation != null
                    ? Column(children: [
                        ...fnolBloc!.fnolModel!.resurveyLocation!
                            .map((e) => FnolWidgetSummary(
                                  title: LocaleKeys.newInspection.tr(),
                                  locationName: e.name ?? "",
                                  locationAddress: e.address ?? "",
                                  lat: e.lat,
                                  lng: e.lng,
                                  images: fnolBloc?.reservayImages,
                                ))
                      ])
                    : Container(),
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("aRepair") ?? false
                    ? Column(children: [
                        ...fnolBloc!.fnolModel!.afterRepairLocation!
                            .map((e) => FnolWidgetSummary(
                                  title: LocaleKeys.afterRepairInspection.tr(),
                                  locationName: e.name ?? "",
                                  locationAddress: e.address ?? "",
                                  lat: e.lat,
                                  lng: e.lng,
                                ))
                      ])
                    : Container(),
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("rightSave") ?? false
                    ? Column(children: [
                        ...fnolBloc!.fnolModel!.rightSaveLocation!
                            .map((e) => FnolWidgetSummary(
                                  title: LocaleKeys.rightSaveInspection.tr(),
                                  locationName: e.name ?? "",
                                  locationAddress: e.address ?? "",
                                  lat: e.lat,
                                  lng: e.lng,
                                ))
                      ])
                    : Container(),
                verticalSpace12,
                verticalSpace12,
                fnolBloc?.fnolModel!.statusList!.contains("billing") ?? false
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${LocaleKeys.billWillDeliverat.tr()} ${DateFormat('yyyy-MM-dd').format(fnolBloc!.billDeliveryDate)} ${LocaleKeys.atDateRange.tr()} ${fnolBloc?.billDeliveryTimeString}",

                                        // 'سيتم التسليم بتاريخ ${DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(fnolBloc?.fnolModel!.billDeliveryDate![0]))} وهى الفترة الزمنية  ${fnolBloc?.fnolModel!.billDeliveryTimeRange![0]}',
                                        style: TextStyles.semiBold18.copyWith(
                                          color: const Color.fromARGB(
                                              255, 108, 243, 115),
                                        )),
                                    Text(
                                      LocaleKeys.billDeliveryLocation.tr(),
                                      style: TextStyles.bold16,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (fnolBloc
                                                    ?.fnolModel!
                                                    .billDeliveryLocation![0]
                                                    .lat !=
                                                null &&
                                            fnolBloc
                                                    ?.fnolModel!
                                                    .billDeliveryLocation![0]
                                                    .lng !=
                                                null)
                                          await MapsLauncher.launchCoordinates(
                                              double.parse(fnolBloc
                                                      ?.fnolModel!
                                                      .billDeliveryLocation![0]
                                                      .lat
                                                      .toString() ??
                                                  ''),
                                              double.parse(fnolBloc
                                                      ?.fnolModel!
                                                      .billDeliveryLocation![0]
                                                      .lng
                                                      .toString() ??
                                                  ''));
                                      },
                                      child: Text(
                                          fnolBloc
                                                  ?.fnolModel!
                                                  .billDeliveryLocation![0]
                                                  .address ??
                                              "",
                                          style: TextStyles.semiBold18.copyWith(
                                            color: ColorsManager.mainColor,
                                          )),
                                    ),
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
          );
        },
      ),
    );
  }
}
