import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../pages/WenchService/wench_service_bloc.dart';

class DestLocSearch extends StatefulWidget {
  DestLocSearch({super.key, required this.destinationLocationController});

  TextEditingController? destinationLocationController;

  @override
  State<DestLocSearch> createState() => _DestLocSearchState();
}

class _DestLocSearchState extends State<DestLocSearch> {
  FocusNode searchFocusNode = FocusNode();
  WenchServiceBloc? wenchServiceBloc;
  String address = "";
  bool isFromSearch = false;
  @override
  void initState() {
    super.initState();
    wenchServiceBloc = context.read<WenchServiceBloc>();
    //wenchServiceBloc?.add(GetLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Prediction>(
      displayStringForOption: (x) => x.description ?? '',
      fieldViewBuilder: (BuildContext context, destinationCtrl, searchFocusNode,
          VoidCallback onFieldSubmitted) {
        // destinationCtrl.text = appBloc.request.requestLocationModel.destAddress ?? "";
        widget.destinationLocationController = destinationCtrl;

        /// print(destinationCtrl.text);
        if (wenchServiceBloc?.activeReq != null &&
            wenchServiceBloc!.activeReq!.requestLocationModel.destAddress !=
                null) {
          address =
              wenchServiceBloc!.activeReq!.requestLocationModel.destAddress!;
        }
        destinationCtrl.text =
            wenchServiceBloc?.request?.requestLocationModel.destAddress ??
                address;

        return BlocBuilder<WenchServiceBloc, WenchServiceState>(
          builder: (context, state) {
            return Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                onChanged: (value) {
                  isFromSearch = true;
                },
                onTap: () {
                  wenchServiceBloc?.request?.fieldPin =
                      MapPickerStatus.destination;
                  wenchServiceBloc?.activeReq?.fieldPin =
                      MapPickerStatus.destination;
                  wenchServiceBloc?.isFromSearch = true;
                  destinationCtrl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: destinationCtrl.text.length,
                  );
                },
                controller: destinationCtrl,
                focusNode: searchFocusNode,
                enabled: wenchServiceBloc?.userRequestProcess ==
                    UserRequestProcesses.none,
                decoration: InputDecoration(
                  hintText: LocaleKeys.yourDestination.tr(),
                  hintStyle: TextStyles.regular14.copyWith(
                    color: ColorsManager.textColor,
                  ),
                  suffixIcon: (state is GetLocationLoading &&
                          wenchServiceBloc?.request?.fieldPin ==
                              MapPickerStatus.destination)
                      ? CupertinoActivityIndicator(
                          color: ColorsManager.mainColor,
                        )
                      : InkWell(
                          onTap: () async {
                            wenchServiceBloc?.isFromSearch = true;
                            wenchServiceBloc?.request?.fieldPin =
                                MapPickerStatus.destination;
                            destinationCtrl.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: destinationCtrl.text.length,
                            );
                            // serviceRequestBloc?.getLocation();
                            // wenchServiceBloc?.add(GetLocationEvent());
                            await wenchServiceBloc?.getForceLocation();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: LoadSvg(
                              image: AssetsImages.location,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
            );
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Prediction> onSelected,
        Iterable<Prediction> options,
      ) {
        return SizedBox(
          width: 300.rw,
          height: 50.rh,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              child: Container(
                color: ColorsManager.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(30.0),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final Prediction option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () async {
                              searchFocusNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(searchFocusNode);
                              onSelected(option);

                              wenchServiceBloc?.getPlaceDetails(option: option);

                              // String currentString = '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                              // appBloc.request.requestLocationModel.destAddress = currentString;
                              // LatLng destPoint = await appBloc.getLatLang(currentString);
                              // appBloc.request.requestLocationModel.destPoint = destPoint;
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Column(children: [
                                        const LoadSvg(
                                          image: AssetsImages.location,
                                          fit: BoxFit.contain,
                                        ),
                                        verticalSpace4,
                                        Text(
                                          option.distanceMeters != null
                                              ? (option.distanceMeters! / 1000)
                                                  .toStringAsFixed(1)
                                              : "",
                                          style: TextStyle(
                                            color: ColorsManager.black,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option
                                                .structuredFormatting!.mainText
                                                .toString(),
                                            style: const TextStyle(
                                              color: ColorsManager.black,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          option.structuredFormatting!
                                                      .secondaryText !=
                                                  null
                                              ? SizedBox(
                                                  child: Text(
                                                    option.structuredFormatting!
                                                        .secondaryText
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13.0,
                                                    ),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text == '') {
          return [];
        }
        if (textEditingValue.text.length > 2 &&
            wenchServiceBloc?.currentPosition != null&&isFromSearch) {
          var res = await wenchServiceBloc?.searchPlace(textEditingValue.text);
          address = res?.predictions.first.description ?? "";
          wenchServiceBloc?.request?.requestLocationModel.destAddress = address;
          //  wenchServiceBloc?.isFromSearch=true;
          isFromSearch = false;
          return res?.predictions ?? [];
        }
        return [];
      },
    );
  }
}
