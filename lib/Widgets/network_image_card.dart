import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Style/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../Configurations/Constants/api_endpoints.dart';
import 'error_imge_holder.dart';

class NetworkImageCard extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double height;
  final double? width;

  const NetworkImageCard({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.fill,
    this.height = 80,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$imagesBaseUrl$imageUrl',
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              image: DecorationImage(image: imageProvider)),
        );
      },
      fit: BoxFit.fill,
      height: height,
      width: width ?? MediaQuery.of(context).size.width / 2.2,
      placeholder: (context, url) => Shimmer(
        gradient: ColorsManager.shimmerGradient,
        period: const Duration(milliseconds: 1000),
        child: Container(
          decoration: BoxDecoration(
            gradient: ColorsManager.shimmerGradient,
          ),
        ),
      ),
      errorWidget: (context, url, error) => const ErrorImageHolder(),
    );
  }
}
