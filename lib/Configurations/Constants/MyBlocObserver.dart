import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
// import 'package:quick_log/quick_log.dart';

Logger logger = Logger(
  level: Level.debug,
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
    noBoxingByDefault: true,
  ),
  output: ConsoleOutput(),
);

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    //printMeLog('onCreate -- ${bloc.runtimeType}');
     logger.d('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // printMeLog('onChange -- ${bloc.runtimeType}, $change');
    logger.d('onChange -- , $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
 //   printMeLog('onError -- ${bloc.runtimeType}, $error');
    logger.e('onError -- ${bloc.runtimeType}, $error');
    // super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // printMeLog('onClose -- ${bloc.runtimeType}');
    logger.f('onClose -- ${bloc.runtimeType}');
  }
}
