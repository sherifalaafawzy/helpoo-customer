import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

extension UnitConverterExtension on num {
  String toDistanceKM() {
    return '${(this / 1000).toStringAsFixed(1)} KM';
  }

  String toTimeMin() {
    final hours = (this / 3600).floor();
    final minutes = ((this % 3600) / 60).floor();
    final hourText = hours > 0 ? '${hours} ${LocaleKeys.hours.tr()}' : '';
    final minuteText = '${minutes} ${LocaleKeys.mins.tr()}';
    return '$hourText $minuteText';
  }
}
