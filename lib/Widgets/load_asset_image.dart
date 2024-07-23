import 'package:flutter/material.dart';

import '../Configurations/Constants/assets_images.dart';


class LoadAssetImage extends StatelessWidget {
  final String image;
  final Color? color;
  final bool rotate;
  final int rotationValue;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String? extension;

  const LoadAssetImage({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.rotate = false,
    this.fit = BoxFit.cover,
    this.rotationValue = 2,
    required this.image,
    this.extension="png"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate
          ? Directionality.of(context) == TextDirection.rtl
              ? rotationValue
              : 0
          : 0,
      child: Image.asset(
        '${AssetsImages.imagePath}/$image.$extension',
        fit: fit,
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}
