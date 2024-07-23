import 'package:flutter/material.dart';

import '../Configurations/Constants/api_endpoints.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.boxFit,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagesBaseUrl + path,
      fit: boxFit,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      return IndexedStack(
        index: loadingProgress == null ? 0 : 1,
        alignment: Alignment.center,
        children: <Widget>[
          child,
          CircularProgressIndicator(
            value: _calcProgress(loadingProgress),
          ),
        ],
      );
    },
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
          size: height,
        ),
      ),
    );
  }

  double? _calcProgress(ImageChunkEvent? loadingProgress) {
    return loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null;
  }
}
