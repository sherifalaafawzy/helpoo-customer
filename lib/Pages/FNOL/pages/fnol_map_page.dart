import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Models/fnol/latestFnolModel.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/enums.dart';
import '../../../Models/fnol/accident_report_details_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import 'package:map_picker/map_picker.dart';
import '../fnol_bloc.dart';
import '../widgets/fnolStepDone.dart';
import '../widgets/mapSearchTextField.dart';
import '../widgets/primary_search_field.dart';
import 'fnol_steps.dart';

class FNOLMapPage extends StatefulWidget {
  FNOLMapPage({super.key, required this.fnolBloc, required this.fnolModel});

  FnolBloc? fnolBloc;
  LatestFnolModel? fnolModel;

  @override
  State<FNOLMapPage> createState() => _FNOLMapPageState();
}

class _FNOLMapPageState extends State<FNOLMapPage> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    // fnolBloc = context.read<FnolBloc>();
    fnolBloc = widget.fnolBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is UpdateFnolStepLocationSuccess) {
          showSuccessDialog(
            context,
            title: LocaleKeys.fnolStepDoneMsg.tr(),
            onPressed: () {
              context.pop;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => FnolBloc(),
                  child: FNOLStepsPage(fnol: widget.fnolBloc?.fnolModel),
                ),
              ));
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => BlocProvider.value(
              //     value: fnolBloc!,
              //     child: fnolStepDone(
              //       Report(id: fnolBloc!.fnolModel!.id,),
              //       fnolBloc: fnolBloc!,
              //       from: widget.fnolBloc!.currentFnolStep!.title,
              //     ),
              //   ),
              // ));
              /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => FnolBloc(),
                  child: FNOLStepsPage(fnol: fnolBloc?.fnolModel),
                ),
              ));*/
              // context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepsPage);
            },
          );
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          horizontalPadding: 0,
          alignment: AlignmentDirectional.topStart,
          extendBodyBehindAppBar: false,
          appBarTitle: LocaleKeys.selectLocation.tr(),
          body: BlocConsumer<FnolBloc, FnolState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Stack(
                children: [
                  MapPicker(
                    mapPickerController: fnolBloc!.mapPickerController,
                    showDot: true,
                    iconWidget: LoadAssetImage(
                      image: AssetsImages.pin,
                      height: 25,
                      color: ColorsManager.mainColor,
                    ),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: fnolBloc!.initialCameraPosition,
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        fnolBloc?.setMapController(
                          controller: controller,
                        );
                      },
                      onCameraMoveStarted: () async {
                        fnolBloc?.onCameraMoveStarted();
                      },
                      onCameraMove: (cameraPosition) async {
                        fnolBloc?.onCameraMove(
                            cameraPositionValue: cameraPosition);
                      },
                      onCameraIdle: () {
                        fnolBloc?.getPlaceByCoordinates();
                        /* fnolBloc?.add(GetPlaceDetailsByCoordinatesEvent(
                          longitude: fnolBloc
                              ?.cameraMovementPosition!.longitude,
                          latitude: fnolBloc
                              ?.cameraMovementPosition!.latitude,
                          isMyLocation: false,
                        ));*/
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Column(
                        children: [
                          BlocProvider.value(
                            value: fnolBloc!,
                            child: MapSearchTextField(fnolBloc: fnolBloc),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 90.0, right: 20, left: 20),
                          child: PrimarySearchField(
                            height: 60,
                            hint: LocaleKeys.inspectionPlaceName.tr(),
                            title: '',
                            onChanged: (value) {
                              fnolBloc?.placeNameCtrl.text = value;
                            },
                            controller: fnolBloc?.placeNameCtrl,
                          ),
                        ),
                        BlocBuilder<FnolBloc, FnolState>(
                          builder: (context, state) {
                            return Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: PrimaryButton(
                                isLoading: state is UpdateFnolStepLocationLoading,
                                text: LocaleKeys.confirm.tr(),
                                onPressed: () async {
                                  if (fnolBloc!.placeNameCtrl.text.isNotEmpty) {
                                    if (fnolBloc?.currentFnolStep!.isBeforeRepair) {
                                      fnolBloc?.currentLocationFnolStep =
                                          LocationFNOLSteps.bRepair;
                                    } else if (fnolBloc?.currentFnolStep!.isAfterRepair) {
                                      fnolBloc?.currentLocationFnolStep =
                                          LocationFNOLSteps.aRepair;
                                    } else if (fnolBloc?.currentFnolStep!.isResurvey) {
                                      fnolBloc?.currentLocationFnolStep =
                                          LocationFNOLSteps.resurvey;
                                    } else if (fnolBloc?.currentFnolStep!.isRightSave) {
                                      fnolBloc?.currentLocationFnolStep =
                                          LocationFNOLSteps.rightSave;
                                    } else if (fnolBloc?.currentFnolStep!.isSupplement) {
                                      fnolBloc?.currentLocationFnolStep =
                                          LocationFNOLSteps.supplement;
                                    }
                                    debugPrint(fnolBloc?.currentLocationFnolStep.toString());
                                    await fnolBloc?.updateFnolStepLocation(
                                        stepEnum: fnolBloc?.currentLocationFnolStep,
                                        locationName: fnolBloc?.placeNameCtrl.text,
                                        address: fnolBloc?.currentFnolStepAddress,
                                        lat: fnolBloc?.currentFnolStepLatLng!.latitude,
                                        lng: fnolBloc?.currentFnolStepLatLng!.longitude,
                                        id: fnolBloc?.fnolModel!.id);
                                    fnolBloc?.getLocation();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
