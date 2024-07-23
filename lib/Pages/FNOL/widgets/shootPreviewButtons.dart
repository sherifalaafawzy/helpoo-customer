import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';

import '../../../Widgets/primary_button.dart';
import '../../../generated/locale_keys.g.dart';

Widget buildDoneButton(FnolBloc fnolBloc) {
  return Visibility(
    visible: (fnolBloc.imageTaken && fnolBloc.isSupplementShot) ||
        fnolBloc.isAllImagesCaptured,
    maintainSize: false,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PrimaryButton(
        text: LocaleKeys.done.tr(),
        onPressed: () async {
          await fnolBloc.cameraController?.setFlashMode(FlashMode.off);
          // set device orientation to portrait
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          fnolBloc.doneImageButton();
        },
      ),
    ),
  );
}

Widget buildNextPhotoButton(FnolBloc fnolBLoc) {
  return Visibility(
    visible: true, //fnolBLoc.imageTaken,
    maintainSize: false,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PrimaryButton(
        text: LocaleKeys.next.tr(),
        onPressed: () {
          fnolBLoc.nextAndUploadImageButton();
        },
      ),
    ),
  );
}

Widget buildRetakePhotoButton(FnolBloc fnolBLoc) {
  return Visibility(
    visible: fnolBLoc.imageTaken,
    maintainSize: false,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PrimaryButton(
        text: LocaleKeys.reTake.tr(),
        onPressed: () {
          fnolBLoc.retakeImageButton();
          // bloc.fnol.imageCounter--;
          // bloc.fnol.allImagesCounter--;
        },
      ),
    ),
  );
}
