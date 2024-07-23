import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/MyCars/my_cars.dart';
import 'package:helpooappclient/Pages/MyCars/pages/add_car_or_select_car_package.dart';
import 'package:helpooappclient/Pages/MyCars/pages/add_car_view.dart';

import '../Models/packages/package_model.dart';
import '../Pages/Home/home_bloc.dart';
import '../Pages/MyCars/pages/select_car_for_add_it_to_package.dart';
import '../Pages/Profile/pages/profile_screen_user_not_active.dart';
import '../Pages/Profile/profile_bloc.dart';
import 'Constants/page_route_name.dart';
import 'Constants/pages_exports.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRouteName.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => SplashBloc(),
            child: const SplashScreen(),
          ),
        );
      case PageRouteName.oTPScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => OtpBloc(),
            child: OTPScreen(
              fromCorporate: (settings.arguments as Map?)?['fromCorporate'],
              corporateName: (settings.arguments as Map?)?['corporateName'],
              fullName: (settings.arguments as Map?)?['fullName'],
            ),
          ),
        );
      case PageRouteName.resetPasswordScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ResetPasswordBloc(),
              ),
              BlocProvider(
                create: (context) => LoginBloc(),
              ),
            ],
            child: const ResetPasswordScreen(),
          ),
        );
      case PageRouteName.mainScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MainScreen(),
        );
      case PageRouteName.profileScreenNotActiveUser:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
              create: (context) => ProfileBloc(),
              child: const ProfileScreenNotActiveUser()),
        );
      case PageRouteName.chooseLanguageScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => ChooseLanguageBloc(),
            child: const ChooseLanguageScreen(),
          ),
        );
      case PageRouteName.welcomeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => PhoneNumberBloc(),
            child: const EnterPhoneNumScreen(),
          ),
        );
      case PageRouteName.registerFillDataScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => SignUpBloc(),
            child: const RegisterFillDataScreen(),
          ),
        );
      case PageRouteName.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: const LoginScreen(),
          ),
        );
      case PageRouteName.enterPhoneNumScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => PhoneNumberBloc(),
            child: const EnterPhoneNumScreen(),
          ),
        );
      case PageRouteName.onBoardingScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => OnBoardingBloc(),
            child: const OnBoardingScreen(),
          ),
        );
      case PageRouteName.roadServicePage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ServiceRequestBloc(),
              ),
              BlocProvider(
                create: (context) => HomeBloc(),
              )
            ],
            child: const RoadServicePage(),
          ),
        );
      case PageRouteName.selectCarScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => MyCarsBloc(),
            child: const SelectCarScreen(),
          ),
        );
      case PageRouteName.authPackagesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => PackagesScreenBloc(),
            child: AuthPackagesScreen(
              corporateName: (settings.arguments as Map)['corporateName'],
              fromCorporate: (settings.arguments as Map)['fromCorporate'],
            ),
          ),
        );
      case PageRouteName.addCarScreen:
        final arguments = settings.arguments as Map?;
        final selectedAddedPackage = arguments?['selectedAddedPackage'] != null
            ? arguments!['selectedAddedPackage']
            : null;
        final isFromPayment = arguments?['isFromPayment'] != null
            ? arguments!['isFromPayment']
            : false;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => MyCarsBloc(),
            child: AddCarScreen(
              selectedAddedPackage:
                  selectedAddedPackage is Package ? selectedAddedPackage : null,
              isFromPayment: isFromPayment,
            ),
          ),
        );

      case PageRouteName.addCarOrSelectCarPackage:
        final arguments = settings.arguments as Map?;
        final isFromPayment = arguments?['isFromPayment'] != null
            ? arguments!['isFromPayment']
            : false;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => MyCarsBloc(),
            child: AddCarOrSelectCarPackage(isFromPayment: isFromPayment),
          ),
        );
      case PageRouteName.myCarsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => MyCarsBloc(),
            child: const MyCarsScreen(),
          ),
        );
      /* case PageRouteName.packageDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => PackagesScreenBloc(),
            child: const PackageDetails(),
          ),
        );*/
      //fnolCommentPage: (context) => const FnolCommentPage(),
      //       shooting: (context) => const Shooting(),
      //       chooseAccidentType: (context) => const ChooseAccidentType(),
      //       fNOLStepAskShoot: (context) => const FNOLStepAskShoot(),
      //       additionalAskShoot: (context) => const AdditionalAskShoot(),

      //     fnolConfirmaionPage: (context) => const FnolConfirmaionPage(),
      //       photographyInstructionsPage: (context) => const PhotographyInstructionsPage(),
      //       accidentDescription: (context) => const AccidentDescription(),
      //       uploadFNOLFilesPage: (context) => const UploadFNOLFilesPage(),
      //       fNOLStepsPage: (context) => const FNOLStepsPage(),
      //       requestFnolBillPage: (context) => const BillRequest(),
      //       fnolSummaryPage: (context) => const FnolSummary(),
      //       fNOLMapPage: (context) => const FNOLMapPage(),
      //       fNOLStepsPhotographyInstructions: (context) => const FNOLStepsPhotographyInstructions(),
      //       fNOLPreviewImage: (context) => const FnolPreviewImage(),
      /* case PageRouteName.fnolCommentPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FnolCommentPage(),
          ),
        );*/
      /*  case PageRouteName.shooting:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const Shooting(),
          ),
        );*/
      case PageRouteName.chooseAccidentType:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const ChooseAccidentType(),
          ),
        );
      /* case PageRouteName.fNOLStepAskShoot:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child:  FNOLStepAskShoot(),
          ),
        );*/
      /*  case PageRouteName.additionalAskShoot:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const AdditionalAskShoot(),
          ),
        );
*/
      /*  case PageRouteName.fnolConfirmaionPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FnolConfirmaionPage(),
          ),
        );*/
      /*  case PageRouteName.photographyInstructionsPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child:  PhotographyInstructionsPage(),
          ),
        );*/
      case PageRouteName.accidentDescription:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const AccidentDescription(),
          ),
        );
      /* case PageRouteName.uploadFNOLFilesPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child:  UploadFNOLFilesPage(),
          ),
        );*/
      /* case PageRouteName.fNOLStepsPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child:  FNOLStepsPage(fnol: null),
          ),
        );*/
      /* case PageRouteName.requestFnolBillPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const BillRequest(),
          ),
        );*/
      /*  case PageRouteName.fnolSummaryPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FnolSummary(),
          ),
        );*/
      /*  case PageRouteName.fNOLMapPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FNOLMapPage(),
          ),
        );*/
      case PageRouteName.fNOLStepsPhotographyInstructions:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FNOLStepsPhotographyInstructions(),
          ),
        );
      /* case PageRouteName.fNOLPreviewImage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => FnolBloc(),
            child: const FnolPreviewImage(),
          ),
        );*/
      case PageRouteName.chooseInsuranceCompany:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => ChooseInsuranceCompanyBloc(),
            child: const ChooseInsuranceCompany(),
          ),
        );
      case PageRouteName.selectCarForAddItToPackage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => MyCarsBloc(),
            child: const SelectCarForAddItToPackage(),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => SplashBloc(),
            child: const SplashScreen(),
          ),
        );
    }
  }
}
