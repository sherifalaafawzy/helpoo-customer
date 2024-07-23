import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';

// clickable image widget
class InterActiveOnlineImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const InterActiveOnlineImage({required this.imgUrl, Key? key, this.errorBuilder, this.width, this.height, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.pushTo(OnlineImageViewer(imgUrl: imgUrl, errorBuilder: errorBuilder,)),
        child: Image.network(imgUrl, errorBuilder: errorBuilder, fit: fit, width: width, height: height),
      );
  }
}

// full image screen
class OnlineImageViewer extends StatelessWidget {
  final String imgUrl;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const OnlineImageViewer({required this.imgUrl, Key? key, this.errorBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.clear)),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.8,
          maxScale: 4.5,
          child: Image.network(imgUrl, errorBuilder: errorBuilder),
        ),
      ),
    );
  }
}
