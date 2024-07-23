import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:supercharged/supercharged.dart';
import '../../../Configurations/Constants/api_endpoints.dart';
import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/network_image_card.dart';
import '../../../Widgets/online_image_viewer.dart';
import '../../../Widgets/primary_padding.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../Main/main_bloc.dart';

class PaymentWebViewWidget extends StatefulWidget {
  PaymentWebViewWidget(
      {Key? key,
      required this.url,
      this.callBack,
      this.successCallBack,
      required this.amountPercentageShell,
      required this.logoShell})
      : super(key: key);
  final String? url;
  String? amountPercentageShell;
  String? logoShell;
  final Function? callBack;
  final Function? successCallBack;

  @override
  State<PaymentWebViewWidget> createState() => _PaymentWebViewWidgetState();
}

class _PaymentWebViewWidgetState extends State<PaymentWebViewWidget> {
  WebViewController webViewController = WebViewController();
  MainBloc? mainBloc;

  @override
  void initState() {
    super.initState();
    mainBloc = context.read<MainBloc>();

    // debugPrint('web view page ==========> IFrameUrl: ${Uri.parse(appBloc.IFrameUrl)}');

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('web view page ==========> onPageStarted $url');
          },
          onProgress: (int progress) {
            debugPrint('web view page ===============> onProgress : ($progress%)');
            if (progress < 100) {
              //  appBloc.isPaymentLoading = true;
            } else {
              // appBloc.isPaymentLoading = false;
            }
          },
          onPageFinished: (String url) {
            debugPrint('web view page ==========> onPageFinished $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('web view page ==========> onWebResourceError');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint(
                'web view page ==========> onNavigationRequest ${request.url}');
            String route = "";
            if (apiRoute == stagingRoute || apiRoute == devRoute) {
              route = devRoute;
            } else {
              route = apiRoute;
            }
            // printMeLog("route =====> ${route}");
            if (request.url.contains("success=true") && widget.successCallBack != null) {
              widget.successCallBack!();
            } else if (request.url.startsWith('https://$route.helpooapp.net/api/v2/paymob/callback')) {
              // if (request.url.startsWith('https://$apiRoute.helpooapp.net/api/v2/paymob/callback')) {
              mainBloc?.onlinePaymentSuccess();
              startTimer(mainBloc!.state);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));
  }

  Timer? timer;
  int currentTime = 10;

  startTimer(state) async {
    if (currentTime == 10) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          if (currentTime > 1) {
            if (mounted) {
              setState(() {
                currentTime = currentTime - 1;
              });
            }
          } else {
            stopTimer();
            if (widget.callBack != null) {
              widget.callBack!();
            } else {
              context.pop();
            }
          }
        },
      );
    }
  }

  stopTimer() {
    currentTime = 10;
    timer!.cancel();
  }

  @override
  void dispose() {
    super.dispose();

    if (timer != null) {
      stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            if (widget.logoShell != null &&
                widget.amountPercentageShell != null) ...[
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: InterActiveOnlineImage(imgUrl: widget.logoShell!),
              ),
              Text(
                ' تم تطبيق خصم مخصص لشركة Shell بقيمة ${double.parse(widget.amountPercentageShell!).toStringAsFixed(0)} %',
                //$currentTime ${LocaleKeys.second.tr()}",
                textAlign: TextAlign.center,
                style: TextStyles.bold14.copyWith(color: ColorsManager.black),
              ),
            ],
            Text(
              LocaleKeys.returnToApp.tr(),
              //$currentTime ${LocaleKeys.second.tr()}",
              textAlign: TextAlign.center,
              style: TextStyles.bold14.copyWith(color: ColorsManager.black),
            ),
            // if (!appBloc.isPaymentLoading)
            Expanded(
              child: WebViewWidget(
                controller: webViewController,
              ),
            ),
            // if (appBloc.isPaymentLoading)
          ],
        );
      },
    );
  }
}
