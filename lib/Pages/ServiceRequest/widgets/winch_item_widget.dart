import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'package:helpooappclient/Widgets/load_asset_image.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

// ignore: must_be_immutable
class WinchItemWidget extends StatelessWidget {
  bool isCorpRequest;
  final String winchName;
  String? winchPrice;
  String? originalPrice;
  final String? imageName;
  final VoidCallback onTap;
  final bool isWithCloseButton;
  Color? color = ColorsManager.lightGreyColor;
  double? width;
  double? height;
  bool? isColumn;

  WinchItemWidget(
      {super.key,
      required this.winchName,
      required this.winchPrice,
      this.originalPrice,
      this.imageName,
      required this.onTap,
      this.isWithCloseButton = false,
      this.color = ColorsManager.lightGreyColor,
      this.width,
      this.height,
      this.isColumn = false,this.isCorpRequest = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WenchServiceBloc, WenchServiceState>(
      builder: (context, state) {
        return SizedBox(
          width: width,
          height: height,
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: 10.rSp.br,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(8.rSp),
              child: isColumn!
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("isCorpRequest: $isCorpRequest"),
                        Expanded(
                          child: Text(
                            winchName,
                            style: TextStyles.regular14.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (originalPrice != null && originalPrice != "")
                          Container(
                            //  height: 25.rh,
                            width: 100.rh,
                            // padding: EdgeInsets.all(4.rSp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: 10.rSp.br,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  originalPrice != null
                                      ? LocaleKeys.beforeDiscount.tr()
                                      : LocaleKeys.price.tr(),
                                  style: TextStyles.regular11.copyWith(
                                    color: Colors.black,
                                    fontSize: 8.rSp,
                                  ),
                                ),
                                // verticalSpace5,
                                Text(
                                  ' ${originalPrice!} ',
                                  style: TextStyles.bold16.copyWith(
                                    fontSize: 14.rSp,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        verticalSpace5,
                        Container(
                          width: 100.rw,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 10.rSp.br,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.price.tr(),
                                style: TextStyles.regular13.copyWith(
                                  color: Colors.black,
                                  fontSize: 9.rSp,
                                ),
                              ),
                              horizontalSpace10,
                              // verticalSpace5,
                              Text(
                                '${winchPrice ?? ''} ${'EGP'.tr()}',
                                style: TextStyles.bold16.copyWith(
                                  fontSize: 14.rSp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        horizontalSpace4,
                        if (imageName != null) LoadSvg(image: imageName!),
                        if (isWithCloseButton) ...{
                          horizontalSpace4,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 17.rw,
                                  height: 17.rh,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.rw),
                                  ),
                                  padding: EdgeInsets.all(2.rSp),
                                  alignment: Alignment.center,
                                  child: const LoadSvg(
                                    image: AssetsImages.close,
                                    isIcon: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        }
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            winchName,
                            style: TextStyles.regular14.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (originalPrice != null && originalPrice != "")
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.rSp, vertical: 2.rSp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: 10.rSp.br,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  originalPrice != null
                                      ? LocaleKeys.beforeDiscount.tr()
                                      : LocaleKeys.price.tr(),
                                  style: TextStyles.regular11.copyWith(
                                    color: Colors.black,
                                    fontSize: 8.rSp,
                                  ),
                                ),
                                // verticalSpace5,
                                Text(
                                  ' ${originalPrice!} ',
                                  style: TextStyles.bold16.copyWith(
                                    fontSize: 14.rSp,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        horizontalSpace4,
                        Container(padding: EdgeInsets.symmetric(horizontal: 4.rSp, vertical: 2.rSp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 10.rSp.br,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.price.tr(),
                                style: TextStyles.regular13.copyWith(
                                  color: Colors.black,
                                  fontSize: 9.rSp,
                                ),
                              ),
                              horizontalSpace10,
                              // verticalSpace5,
                              Text(
                                '${winchPrice ?? ''} ${'EGP'.tr()}',
                                style: TextStyles.bold16.copyWith(
                                  fontSize: 14.rSp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        horizontalSpace4,
                        if (imageName != null)
                          imageName == AssetsImages.n300Stepper
                              ? LoadAssetImage(
                                  image: imageName!,
                                  height: 25,
                                )
                              : LoadSvg(image: imageName!),
                        if (isWithCloseButton) ...{
                          horizontalSpace4,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 17.rw,
                                  height: 17.rh,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.rw),
                                  ),
                                  padding: EdgeInsets.all(2.rSp),
                                  alignment: Alignment.center,
                                  child: const LoadSvg(
                                    image: AssetsImages.close,
                                    isIcon: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        }
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
