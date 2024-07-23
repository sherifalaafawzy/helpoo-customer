import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/di/injection.dart';
import 'package:helpooappclient/Pages/CorprateDeals/pages/corparte_client_page.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/tracking/tracking.dart';
import 'package:helpooappclient/Pages/splash/splash_repository.dart';
import 'package:uni_links/uni_links.dart';

import '../Pages/Home/home_bloc.dart';
import '../Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'navigation_service.dart';

abstract class DynamicLinkService {
  Future<String?> getLink();
  Stream<String?> getLinkStream();
  String createLink(String path, {Map<String, dynamic> queryParameters});
  void handleInitialLink();
}

class DynamicLinkServiceImpl implements DynamicLinkService {
  @override
  void handleInitialLink() async {
    String? initialLink = await getLink();
    if (initialLink != null) _handleRedirection(initialLink);
  }

  @override
  Future<String?> getLink() async {
    try {
      final initialLink = await getInitialLink();
      return initialLink;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<String?> getLinkStream() {
    linkStream.listen((link) {
      if (link != null) _handleRedirection(link);
    }, onError: (error) {});

    return linkStream.handleError((error) {});
  }

  @override
  String createLink(String path, {Map<String, dynamic>? queryParameters}) {
    //path=tracking
    //{trackId:requestId}
    //final link=sl<DynamicLinkService>.createLink(path,parms)
    if (queryParameters != null) {
      queryParameters.removeWhere((key, value) => value == null);
      queryParameters.forEach((key, value) {
        if (value is String)
          queryParameters[key] = value;
        else
          queryParameters[key] = value.toString();
      });
    }
    return Uri.https('open.helpooapp.net', path, queryParameters).toString();
  }

  void _handleRedirection(String initialLink) async {
    await Future.delayed(const Duration(seconds: 1));
    final uri = Uri.parse(initialLink);
    final isDetailsPage = uri.pathSegments.contains('tracking');
    if (isDetailsPage) {
      _handleDetailsPage(uri);
      return;
    }
    if (uri.queryParameters.containsKey('vendor')) {
      _handleVendorClientPage(uri);
    }
  }

  void _handleDetailsPage(Uri uri) {
    final trackingRequestId = uri.queryParameters['trackId'];
    if (trackingRequestId == null) return;

    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        settings: RouteSettings(name: 'tracking'),
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WenchServiceBloc(),
            ),
            BlocProvider(
              create: (context) => HomeBloc(),
            ),
          ],
          child: TrackingPage(trackingRequestId),
        ),
      ),
      (route) {
        // check if tracking page is already in the stack
        if (route.settings.name == 'tracking') return false;
        return true;
      },
    );
  }

  void _handleVendorClientPage(Uri uri) async {
    final corporateName = uri.queryParameters['vendor'];
    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                CorporateClientPage(corporateName: corporateName ?? '')),
        (route) => false);
  }
}
