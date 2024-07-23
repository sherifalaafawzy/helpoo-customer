import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Services/deep_link_service.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'Configurations/Constants/api_endpoints.dart';
import 'Configurations/Constants/constants.dart';
import 'Configurations/Constants/keys.dart';
import 'Configurations/app_router.dart';
import 'Configurations/di/injection.dart';
import 'Configurations/extensions/size_extension_utils/sizer_wrapper.dart';
import 'Pages/Main/main_bloc.dart';
import 'Services/cache_helper.dart';
import 'Configurations/di/injection.dart' as di;
import 'Services/device_info_service.dart';
import 'Services/navigation_service.dart';
import 'Style/theme/theme.dart';
import 'Widgets/primary_button.dart';
import 'firebase_options.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  /// Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) async {
    await FirebaseMessaging.instance.requestPermission();
  });

  _requestPermissions();
  _getFcmToken();
  _configureForegroundMessageHandler();
  _configureOpenedMessageHandler();
  _configureLocalNotification();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  await di.init();
  sl<DynamicLinkService>().getLinkStream();

  await DeviceInfoService().initPlatformState();

  ///* 2- isDark
  bool isDark = false;
  await di.sl<CacheHelper>().get('isDark').then((value) {
    debugPrint('isDark ------------- $value');
    if (value != null) {
      isDark = value;
    }
  });

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    RequestsInspector(
      navigatorKey: NavigationService.navigatorKey,
      enabled: apiRoute != productionRoute,
      showInspectorOn: ShowInspectorOn.Both,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext _) =>
                  di.sl<MainBloc>()..add(SetThemeEvent(isDark: isDark))
              //..getLocation(),
              ),
        ],
        child: EasyLocalization(
          path: "assets/translations",
          supportedLocales: localizeLanguages,
          saveLocale: true,
          useOnlyLangCode: true,
          fallbackLocale: localizeLanguages.first,
          assetLoader: const CodegenLoader(),
          startLocale: localizeLanguages.first,
          child: MyApp(isDark: isDark),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    AppTheme.setLocale = context.locale;
    if (AppTheme.currentLocale.languageCode == "ar") {
      isArabic = true;
    } else {
      isArabic = false;
    }
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is ChangeLanguageState) {
          context.setLocale(state.locale);
          sl<CacheHelper>().put(Keys.languageCode, state.locale.languageCode);
        }
      },
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return SizerMainWidget(
            builder: (context, orientation) {
              return MaterialApp(
                builder: BotToastInit(),
                debugShowCheckedModeBanner: false,
                navigatorKey: NavigationService.navigatorKey,
                title: 'Helpoo',
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: const [
                  Locale('ar', 'EG'),
                  Locale('en', 'US'),
                ],
                locale: context.locale,
                theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                onGenerateRoute: (settings) =>
                    AppRouter().generateRoute(settings),
              );
            },
          );
        },
      ),
    );
  }
}

/// ========================== fcm configurations =============================
/// ===========================================================================

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print("Background message received!");

  // Parse the message if needed
  // final Map<String, dynamic> data = message.data;

  // Display a notification
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.max,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await _flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'Background notification',
    message.notification?.body ?? '',
    platformChannelSpecifics,
  );

  // Perform other tasks if needed, such as saving to local storage, making network requests, etc.
}

void _requestPermissions() {
  _fcm.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

void _getFcmToken() async {
  String? fcmToken = await _fcm.getToken();
  debugPrintFullText("FCM Token: $fcmToken");
  // fcmtoken = fcmToken!;
}

void _configureForegroundMessageHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message received!");
    _showNotificationDialog(message);
  });
}

void _configureOpenedMessageHandler() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification tapped while app in background or terminated!");
    _showNotificationDialog(message);
  });
}

void _showNotificationDialog(RemoteMessage message) {
  showDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(message.notification?.title ?? "Notification"),
      content: Text(message.notification?.body ?? "Notification Content"),
      actions: [
        PrimaryButton(
          text: 'ok',
          backgroundColor: Colors.green,
          onPressed: () {
            NavigationService.navigatorKey.currentContext!.pop();
          },
        ),
      ],
    ),
  );
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _configureLocalNotification() async {
  final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/app_icon');

  final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    onDidReceiveLocalNotification: (x, _, __, ___) {
      debugPrint('*** notify in foreground');
      _configureForegroundMessageHandler();
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await _flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      debugPrint('*** payload: ${notificationResponse.payload}');
    },
  );
}

/// ======