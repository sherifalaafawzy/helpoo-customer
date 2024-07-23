import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';

import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';


class DesignSystem {
  DesignSystem._();

  static Widget emptyWidget({
    String emptyText = 'No Data',
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.doc,
              size: 100,
              color: ColorsManager.gray30,
            ),
            verticalSpace10,
            Text(
              emptyText,
              style: TextStyles.medium14,
            ),
          ],
        ),
      ),
    );
  }
  static Widget emptySelectCarWidget({
    String emptyText = 'No Data',
   required BuildContext? context,
    required Function? onTab
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.doc,
              size: 100,
              color: ColorsManager.gray30,
            ),
            verticalSpace10,
            Text(
              emptyText,
              style: TextStyles.medium14,
            ),
            verticalSpace10,
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryButton(
                  text: LocaleKeys.addCar.tr(),
                  width:
                  MediaQuery.of(context!).size.width / 2,
                  onPressed: () {
                    if(onTab!=null) {
                      onTab();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
