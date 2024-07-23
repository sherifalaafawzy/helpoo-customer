import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../fnol_bloc.dart';
import 'audio/audioPlayer.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  AudioRecorder({Key? key, required this.onStop, required this.fnolBloc})
      : super(key: key);
  FnolBloc? fnolBloc;

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FnolBloc? fnolBloc;

  // int _recordDuration = 0;
  // Timer? _timer;
  // final _audioRecorder = Record();
  // StreamSubscription<RecordState>? _recordSub;
  // RecordState _recordState = RecordState.stop;
  // StreamSubscription<Amplitude>? _amplitudeSub;
  // Amplitude? _amplitude;

  @override
  void initState() {
    //fnolBloc = context.read<FnolBloc>();
    super.initState();
    fnolBloc = widget.fnolBloc;

  }

  Future<void> _start() async {
    try {
      if (await fnolBloc!.mediaController.audioRecorder.hasPermission()) {
        {
          widget.fnolBloc?.mediaController.recordSub = widget
              .fnolBloc?.mediaController.audioRecorder
              .onStateChanged()
              .listen((recordState) {
            widget.fnolBloc?.mediaController.recordState = recordState;
          });
        }
        {
          widget.fnolBloc?.mediaController.amplitudeSub = widget
              .fnolBloc?.mediaController.audioRecorder
              .onAmplitudeChanged(const Duration(milliseconds: 300))
              .listen((amp) =>widget.fnolBloc?.mediaController.amplitude = amp);
        }
        // We don't do anything with this but printing
        final isSupported =
            await fnolBloc?.mediaController.audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          debugPrint('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        Directory tempDir = await getTemporaryDirectory();

        Record r = fnolBloc!.mediaController.audioRecorder;

        await r.start(
          path: '${tempDir.path}/myFile.m4a',
        );

        fnolBloc?.mediaController.recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    fnolBloc?.mediaController.timer?.cancel();
    fnolBloc?.mediaController.recordDuration = 0;

    final path = await fnolBloc?.mediaController.audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {

    await fnolBloc?.mediaController.audioRecorder.pause().then((value) {
      setState(() {
        fnolBloc?.mediaController.timer?.cancel();
      });
    });

  }

  Future<void> _resume() async {

    await fnolBloc?.mediaController.audioRecorder.resume().then((value) {
      setState(() {
        _startTimer();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRecordStopControl(),
            const SizedBox(width: 20),
            _buildPauseResumeControl(),
            const SizedBox(width: 20),
            _buildText(),
          ],
        ),
        // if (fnolBloc?.mediaController.amplitude != null) ...[
        // const SizedBox(height: 40),
        // Text('Current: ${_amplitude?.current ?? 0.0}'),
        // Text('Max: ${_amplitude?.max ?? 0.0}'),
        //  ],
      ],
    );
  }

  @override
  void dispose() {
    fnolBloc?.mediaController.timer?.cancel();
    fnolBloc?.mediaController.recordSub?.cancel();
    fnolBloc?.mediaController.amplitudeSub?.cancel();
    fnolBloc?.mediaController.audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (fnolBloc?.mediaController.recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: ColorsManager.mainColor, size: 30);
      color = ColorsManager.mainColor.withOpacity(0.1);
    } else {
      icon = Icon(Icons.mic, color: ColorsManager.mainColor, size: 30);
      color = ColorsManager.mainColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            setState(() {
              (fnolBloc?.mediaController.recordState != RecordState.stop)
                  ? _stop()
                  : _start();
            });

          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (fnolBloc?.mediaController.recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }
    late Icon icon;
    late Color color;
    if (fnolBloc?.mediaController.recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: ColorsManager.mainColor, size: 30);
      color = ColorsManager.mainColor.withOpacity(0.1);
    } else {
      icon = const Icon(Icons.play_arrow,
          color: ColorsManager.mainColor, size: 30);
      color = ColorsManager.mainColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (fnolBloc?.mediaController.recordState == RecordState.pause)
                ? _resume()
                : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (fnolBloc?.mediaController.recordState != RecordState.stop) {
      return _buildTimer();
    }

    return Text(
     LocaleKeys.accidentDescription.tr(),
      style: TextStyles.bold20,
    );
  }

  Widget _buildTimer() {
    final String minutes =
        _formatNumber(fnolBloc!.mediaController.recordDuration ~/ 60);
    final String seconds =
        _formatNumber(fnolBloc!.mediaController.recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: ColorsManager.mainColor),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _startTimer() {
    fnolBloc?.mediaController.timer?.cancel();

    fnolBloc?.mediaController.timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (fnolBloc?.mediaController.recordDuration != null) {
        setState(() => fnolBloc!.mediaController.recordDuration++);
      }
      if (fnolBloc!.mediaController.recordDuration > 300) {
        fnolBloc?.mediaController.audioRecorder.stop();
      }
    });
  }
}

class voiceInputWidget extends StatefulWidget {
  @override
  voiceInputWidgetState createState() => voiceInputWidgetState();

  voiceInputWidget({required this.fnolBloc});

  FnolBloc? fnolBloc;
}

class voiceInputWidgetState extends State<voiceInputWidget> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
 /*   widget.fnolBloc?.mediaController.recordSub = widget
        .fnolBloc?.mediaController.audioRecorder
        .onStateChanged()
        .listen((recordState) {
      widget.fnolBloc?.mediaController.recordState = recordState;
    });

    widget.fnolBloc?.mediaController.amplitudeSub = widget
        .fnolBloc?.mediaController.audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) =>widget.fnolBloc?.mediaController.amplitude = amp);*/

    showPlayer = false;
    super.initState();

  }

  @override
  void dispose() {
    widget.fnolBloc?.mediaController.audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showPlayer
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: audioPlayer(
              source: audioPath!,
              onDelete: () {
                setState(() {
                  showPlayer = false;
                });
                //  fnolBloc?.mediaController.audioRecorder.dispose();
              },
            ),
          )
        : BlocProvider.value(
            value: widget.fnolBloc!,
            child: AudioRecorder(
              fnolBloc: widget.fnolBloc,
              onStop: (path) {
                debugPrint('Recorded file path: $path');
                if (kDebugMode) debugPrint('Recorded file path: $path');
                setState(() {
                  audioPath = path;
                  widget.fnolBloc?.mediaController.audioFilePath = path;
                  showPlayer = true;
                });
                debugPrint('start converting');
                widget.fnolBloc?.mediaController
                    .convertAudioTo64(path, widget.fnolBloc!);
              },
            ),
          );
  }
}
