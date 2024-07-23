import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Widgets/load_asset_image.dart';
import 'package:helpooappclient/Widgets/spacing.dart';

import '../Configurations/Constants/assets_images.dart';
import '../Style/theme/colors.dart';
import '../Style/theme/text_styles.dart';
import '../generated/locale_keys.g.dart';

class StartedSheetOtherService extends StatefulWidget {
  const StartedSheetOtherService({
    required this.startTime,
    required this.allowanceTime,
    this.isDone = false,
    super.key,
  });
  final DateTime startTime;
  final int allowanceTime;
  final bool isDone;
  @override
  State<StartedSheetOtherService> createState() =>
      _StartedSheetOtherServiceState();
}

class _StartedSheetOtherServiceState extends State<StartedSheetOtherService> {
  int elapsedTimeInSeconds = 0;
  int waitingTimeInSeconds = 0;
  int allowanceTimeInSeconds = 0;
  late String expectedFinishTime;
  late Timer timer;
  @override
  void initState() {
    allowanceTimeInSeconds = widget.allowanceTime * 60;
    expectedFinishTime =
        DateFormat('hh:mm a').format(widget.startTime.add(Duration(
      minutes: widget.allowanceTime,
    )));

    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTimeInSeconds =
            DateTime.now().difference(widget.startTime).inSeconds;
        waitingTimeInSeconds = elapsedTimeInSeconds - allowanceTimeInSeconds;
        waitingTimeInSeconds =
            waitingTimeInSeconds < 0 ? 0 : waitingTimeInSeconds;
      });
    });
    if (widget.isDone) timer.cancel();
  }

  @override
  void didUpdateWidget(covariant StartedSheetOtherService oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDone) timer.cancel();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasWaitingTime = waitingTimeInSeconds > 0;
    final color = hasWaitingTime ? ColorsManager.red : ColorsManager.mainColor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.rSp),
      decoration: BoxDecoration(
        borderRadius: 20.rSp.br,
        color: ColorsManager.lightGreyColor,
      ),
      child: Column(
        children: [
          Text(
            widget.isDone
                ? LocaleKeys.done.tr()
                : LocaleKeys.makingService.tr(),
            style: TextStyles.bold16,
          ),
          _buildLoading(context, color),
          Divider(color: Colors.grey[300], thickness: 1),
          Row(
            children: [
              _customItem(
                title: LocaleKeys.expectedFinishTime.tr(),
                value: expectedFinishTime,
              ),
              _customItem(
                title: LocaleKeys.executionTimeInMinutes.tr(),
                value: '${formatElapsedTime(elapsedTimeInSeconds)}',
                color: hasWaitingTime ? ColorsManager.red : null,
              ),
              _customItem(
                title: LocaleKeys.waitingTime.tr(),
                value: '${formatElapsedTime(waitingTimeInSeconds)}',
                color: hasWaitingTime ? ColorsManager.red : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Directionality _buildLoading(BuildContext context, Color color) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: LoadAssetImage(
              image: AssetsImages.clientCarStepper2,
              fit: BoxFit.none,
            ),
          ),
          if (widget.isDone)
            _buildDone()
          else
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ),
          Expanded(
            child: LoadAssetImage(
              image: AssetsImages.n300Stepper,
              fit: BoxFit.none,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the elapsed time as HH:MM:SS
  String formatElapsedTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secondsStr = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$secondsStr";
  }

  Widget _customItem({
    required String title,
    required String value,
    Color? color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyles.bold10,
          ),
          verticalSpace10,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.rSp,
              vertical: 5.rSp,
            ),
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: 8.rSp.br,
            ),
            child: Text(
              value,
              textDirection: TextDirection.ltr,
              style: TextStyles.medium10.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDone() {
    return Expanded(
      child: Icon(
        Icons.check_circle,
        color: ColorsManager.mainColor,
        size: 50.rh,
      ),
    );
  }
}
