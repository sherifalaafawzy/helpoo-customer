import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Widgets/spacing.dart';
import '../../Home/home_bloc.dart';
import '../fnol_bloc.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/shootPreviewButtons.dart';
import 'upload_fnol_files_page.dart';

class Shooting extends StatefulWidget {
  const Shooting({super.key, required this.controller});

  final CameraController? controller;

  @override
  State<Shooting> createState() => _ShootingState();
}

class _ShootingState extends State<Shooting> {
  FnolBloc? fnolBloc;

  @override
  void initState() {
    super.initState();
    fnolBloc = context.read<FnolBloc>();
    fnolBloc?.cameraController = widget.controller!;
    fnolBloc!.isAskAdditionalAppear = false;
    //fnolBloc?.initCameraController();

    {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      if (Platform.isIOS) {
        lockCaptureScreenIOS().then((value) {});
      }
    }
  }

  Future<void> lockCaptureScreenIOS() async {
    await fnolBloc?.cameraController
        ?.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
  }

  @override
  void dispose() async {
    super.dispose();
    // fnolBloc?.turnOffFlash();
    // fnolBloc!.cameraController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    fnolBloc!.isAskAdditionalAppear = false;
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
        if (!fnolBloc!.isSupplementShot) {
          context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: fnolBloc!,
                child: FNOLStepAskShoot(
                  fnolBloc: fnolBloc,
                ),
              ),
            ),
          );
          //   context.pushNamedAndRemoveUntil(PageRouteName.fNOLStepAskShoot);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<FnolBloc, FnolState>(
          listener: (context, state) async {
            if (fnolBloc!.isAllImagesCaptured) {
              // if (state is DonaCameraImagesTaked) {
              if (fnolBloc!.isFnolAdditional) {
                fnolBloc!.isFnolAdditional = false;
                fnolBloc!.isSupplementShot = false;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: fnolBloc!,
                      child: FnolCommentPage(fnolBloc: fnolBloc!),
                    ),
                  ),
                );
                /* context
                      .pushNamedAndRemoveUntil(PageRouteName.fnolCommentPage);*/
              } else if (fnolBloc!.isSupplementShot) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: fnolBloc!,
                        ),
                        /* BlocProvider(
                                create: (context) => HomeBloc(),
                              ),*/
                      ],
                      child: UploadFNOLFilesPage(
                        fnolBloc: fnolBloc,
                      ),
                    ),
                  ),
                );
                /*  context.pushNamedAndRemoveUntil(
                      PageRouteName.uploadFNOLFilesPage);*/
              } else if (ModalRoute.of(context)!.isCurrent) {
                print('omaaar ${ModalRoute.of(context)!.isCurrent}');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                        value: fnolBloc!,
                        child: AdditionalAskShoot(
                          fnolBloc: fnolBloc,
                        )),
                  ),
                );
                /*      context.pushNamedAndRemoveUntil(
                      PageRouteName.additionalAskShoot);*/
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // camera preview
                Positioned.fill(
                  child: fnolBloc!.imageTaken
                      ? Image.file(fnolBloc!.imageFnol!)
                      : CameraPreview(
                          fnolBloc!.cameraController!,
                        ),
                ),
                // shooting button

                Align(
                  alignment: Alignment.bottomCenter,
                  child: fnolBloc!.imageTaken
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Directionality.of(context) == TextDirection.rtl
                                ? Row(
                                    children: [
                                      Expanded(child: buildNextPhotoButton(fnolBloc!)),
                                      Expanded(child: buildRetakePhotoButton(fnolBloc!)),
                                    ],
                                  )
                                : Row(
                                  children: [
                                    Expanded(child: buildRetakePhotoButton(fnolBloc!)),
                                    Expanded(child: buildNextPhotoButton(fnolBloc!)),
                                  ],
                                ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: BlocProvider.value(
                                  value: fnolBloc!,
                                  child: buildDoneButton(fnolBloc!),
                                )),
                              ],
                            )
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: Platform.isIOS
                                ? EdgeInsets.symmetric(horizontal: 30.0)
                                : EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Flash button
                                InkWell(
                                  onTap: () {
                                    if (fnolBloc!.flashMode == FlashMode.off) {
                                      fnolBloc!.turnOnFlash();
                                    } else {
                                      fnolBloc!.turnOffFlash();
                                    }
                                  },
                                  child: RotatedBox(
                                    quarterTurns:
                                        fnolBloc!.isSupplementShot ? 0 : 1,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      margin: const EdgeInsets.only(
                                        right: 30,
                                      ),
                                      child: Icon(
                                        fnolBloc!.flashMode == FlashMode.off
                                            ? Icons.flash_off
                                            : Icons.flash_on,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpace20,
                                InkWell(
                                  onTap: () {
                                    fnolBloc!.takePicture();
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    margin: const EdgeInsets.only(right: 30),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                fnolBloc!.isSupplementShot
                    ? Container()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Visibility(
                          visible: !fnolBloc!.isSupplementShot,
                          child: Container(
                            height: 250,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 30.0, left: Platform.isIOS ? 30 : 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                '${AssetsImages.cameraImages}${fnolBloc!.requiredImagesTags[fnolBloc!.currentImageIndex]}.${fnolBloc!.getImageType(image: fnolBloc!.requiredImagesTags[fnolBloc!.currentImageIndex])}'),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        fnolBloc!.imagesInstructions[
                                            fnolBloc!.requiredImagesTags[
                                                fnolBloc!.currentImageIndex]]!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                verticalSpace10,
                                /* Text(
                                  fnolBloc!.imagesInstructions[
                                      fnolBloc!.requiredImagesTags[
                                          fnolBloc!.currentImageIndex]]!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
