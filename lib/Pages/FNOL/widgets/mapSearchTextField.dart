import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/Pages/FNOL/fnol_bloc.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../generated/locale_keys.g.dart';

class MapSearchTextField extends StatefulWidget {
  MapSearchTextField({super.key, required this.fnolBloc});

  FnolBloc? fnolBloc;

  @override
  State<MapSearchTextField> createState() => _MapSearchTextFieldState();
}

class _MapSearchTextFieldState extends State<MapSearchTextField> {
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    widget.fnolBloc?.add(GetLocationFromFnolEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        if(state is FNOLGetLocationDone){
          setState(() {

          });
        }
      },
      builder: (context, state) {
        return Container(
          height: 40,
          child: Autocomplete<Prediction>(
            displayStringForOption: (x) => x.description ?? '',
            fieldViewBuilder: (BuildContext context, fieldTextEditingController,
                searchFocusNode, VoidCallback onFieldSubmitted) {
              fieldTextEditingController.text =
                  widget.fnolBloc!.mapSearchFnolTextFieldCtrl.text;
              if (fieldTextEditingController.text.isNotEmpty) {
                widget.fnolBloc!.saveCurrentFnolStepAddressLatLngFromAddress(
                    controllerText: fieldTextEditingController.text);
              }

              return Container(
                height: 40,
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: searchFocusNode,
                        maxLines: 1,
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.inspectionLocationSelect.tr(),
                          hintStyle: TextStyles.regular14.copyWith(
                            color: ColorsManager.textColor,
                          ),
                          suffixIcon: /* widget.fnolBloc!.getLocationLoading
                              ? CupertinoActivityIndicator(
                                  color: ColorsManager.mainColor,
                                )
                              :*/
                              InkWell(
                            onTap: () {
                              //   printMe("get my current location");

                              widget.fnolBloc!.add(GetLocationFromFnolEvent());
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
                        style: TextStyles.regular14.copyWith(
                          color: ColorsManager.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<Prediction> onSelected,
              Iterable<Prediction> options,
            ) {
              return SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(30.0),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final Prediction option =
                                    options.elementAt(index);

                                return GestureDetector(
                                  onTap: () async {
                                    searchFocusNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(searchFocusNode);

                                    onSelected(option);

                                    widget.fnolBloc!
                                        .getPlaceDetails(option: option);
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
                                              Text(
                                                option.distanceMeters != null
                                                    ? (option.distanceMeters! /
                                                            1000)
                                                        .toStringAsFixed(1)
                                                    : "",
                                                style: TextStyles.regular14
                                                    .copyWith(
                                                  color:
                                                      ColorsManager.textColor,
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
                                                option.structuredFormatting!
                                                    .mainText
                                                    .toString(),
                                                style: TextStyles.regular14
                                                    .copyWith(
                                                  color:
                                                      ColorsManager.textColor,
                                                ),
                                              ),
                                              option.structuredFormatting!
                                                          .secondaryText !=
                                                      null
                                                  ? SizedBox(
                                                      child: Text(
                                                        option
                                                            .structuredFormatting!
                                                            .secondaryText
                                                            .toString(),
                                                        style: TextStyles
                                                            .regular14
                                                            .copyWith(
                                                          color: ColorsManager
                                                              .textColor,
                                                        ),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ))
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
              if (textEditingValue.text.length > 2) {
                var res =
                    await widget.fnolBloc!.searchPlace(textEditingValue.text);
                return res.predictions;
                //  return [];
              }
              return [];
            },
          ),
        );
      },
    );
  }
}
