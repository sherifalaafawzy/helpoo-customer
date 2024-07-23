import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Pages/MyCars/my_cars_bloc.dart';
import 'package:helpooappclient/Style/theme/colors.dart';
import 'package:helpooappclient/Widgets/spacing.dart';

import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../generated/locale_keys.g.dart';

class ShootingForMyCars extends StatefulWidget {
  final MyCarsBloc myCarsBloc;

  const ShootingForMyCars({super.key, required this.myCarsBloc});

  @override
  State<ShootingForMyCars> createState() => _ShootingState();
}

class _ShootingState extends State<ShootingForMyCars> {
  @override
  void initState() {
    super.initState();
    widget.myCarsBloc.turnOffFlash();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    if (Platform.isIOS) {
      lockCaptureScreenIOS().then((value) {});
    }
  }

  Future<void> lockCaptureScreenIOS() async {
    await widget.myCarsBloc.cameraController
        ?.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
  }

  //sksl

  @override
  void dispose() {
    super.dispose();
    widget.myCarsBloc.cameraController!.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        context.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: BlocConsumer<MyCarsBloc, MyCarsState>(
          listener: (context, state) {
            if (state is TakePictureSuccessState) {
              if (widget.myCarsBloc.licensesImages.length == 1) {
                HelpooInAppNotification.showMessage(
                    message: LocaleKeys.shoots2.tr());
              } else if (widget.myCarsBloc.licensesImages.length == 2) {
                Navigator.of(context).pop();
              } else {}
            }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [

                  // camera preview
                  CameraPreview(widget.myCarsBloc!.cameraController!),

                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManager.mainColor,
                        ),
                        margin: const EdgeInsets.only(right: 30),
                        child: state is TakePictureLoadingState
                            ? const CupertinoActivityIndicator(
                            color: ColorsManager.white)
                            : const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  // shooting buttons
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Flash button
                            InkWell(
                              onTap: () {
                                if (widget.myCarsBloc!.flashMode ==
                                    FlashMode.off) {
                                  widget.myCarsBloc!.turnOnFlash();
                                } else {
                                  widget.myCarsBloc!.turnOffFlash();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.mainColor,
                                ),
                                margin: const EdgeInsets.only(
                                  right: 30,
                                ),
                                child: Icon(
                                  widget.myCarsBloc!.flashMode == FlashMode.off
                                      ? Icons.flash_off
                                      : Icons.flash_on,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                            verticalSpace20,

                            // Shot button
                            InkWell(
                              onTap: () {
                                widget.myCarsBloc!.takePicture();
                              },
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.mainColor,
                                ),
                                margin: const EdgeInsets.only(right: 30),
                                child: state is TakePictureLoadingState
                                    ? const CupertinoActivityIndicator(
                                        color: ColorsManager.white)
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
