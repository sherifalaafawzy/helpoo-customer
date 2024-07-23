import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Style/theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CamStreamScreen extends StatefulWidget {
  final String videoUrl;

  CamStreamScreen({required this.videoUrl});

  @override
  State<CamStreamScreen> createState() => _CamStreamScreenState();
}

class _CamStreamScreenState extends State<CamStreamScreen> {
  late WebViewController controller;

  @override
  void initState() {
    // Hide the system overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    // landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(' ')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return true;
        },
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            Padding(
              padding: const EdgeInsets.all(12),
              child: FloatingActionButton(
                  mini: true,
                  backgroundColor: ColorsManager.mainColor,
                  onPressed: () async {
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                    context.pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // portraite
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
