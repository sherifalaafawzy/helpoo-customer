import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Configurations/Constants/assets_images.dart';

class LoadSvg extends StatelessWidget {
  final String image;

  // final String rootPath;
  final Color? color;
  final bool rotate;
  final int rotationValue;
  final bool isIcon;
  final double? height;
  final double? width;
  final BoxFit fit;

  const LoadSvg({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.rotate = false,
    this.isIcon = false,
    this.fit = BoxFit.cover,
    this.rotationValue = 2,
    required this.image,
    // required this.rootPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate
          ? Directionality.of(context) == TextDirection.rtl
              ? rotationValue
              : 0
          : 0,
      child: SvgPicture.asset(
        '${isIcon ? AssetsImages.iconsPath : AssetsImages.imagePath}/$image.svg',
        fit: fit,
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}
