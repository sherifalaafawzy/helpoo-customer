import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../fnol_bloc.dart';

class MediaController {
  String? audioFilePath;
  String? audio64;
  bool working = false;
  int recordDuration = 0;
  Timer? timer;
  final audioRecorder = Record();
  StreamSubscription<RecordState>? recordSub;
  RecordState recordState = RecordState.stop;
  StreamSubscription<Amplitude>? amplitudeSub;
  Amplitude? amplitude;

  Future<String?> convertAudioTo64(path,FnolBloc fnolBloc) async {
    debugPrint('convertAudioTo64');
    debugPrint('convertAudioTo64 : $path');

    File tempFile = File('${path}');

    tempFile.readAsBytes().then((fileBytes) {
      debugPrint('fileBytes: $fileBytes');
       fnolBloc?.mediaController.audio64 = base64Encode(fileBytes);
      // debugPrint('audio64: ${appBloc.mediaController.audio64}');
      return base64Encode(fileBytes);
    }).catchError((error) {
      debugPrint('onErrorReadBytes: $error');
      return error;
    });
    return null;
  }
}
