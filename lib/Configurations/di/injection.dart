import 'package:get_it/get_it.dart';
import 'package:helpooappclient/Pages/CorprateDeals/corporate_repo.dart';
import 'package:helpooappclient/Pages/Main/main_repository.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/other_service/other_service_cubit.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/other_service/other_service_repository.dart';
import 'package:helpooappclient/Pages/auth/pages/Login/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Pages/CorprateDeals/cubit/corporate_client_cubit.dart';
import '../../Pages/FNOL/fnol_repository.dart';
import '../../Pages/Home/home_repository.dart';
import '../../Pages/InsuranceCompany/choose_insurance_company_repository.dart';
import '../../Pages/Main/main_bloc.dart';
import '../../Pages/MyCars/my_cars_repository.dart';
import '../../Pages/Packages/packages_screen_repository.dart';
import '../../Pages/Profile/profile_repository.dart';
import '../../Pages/ServiceRequest/pages/WenchService/wench_service_repository.dart';
import '../../Pages/ServiceRequest/service_request_repository.dart';
import '../../Pages/auth/pages/OTP/otp_repository.dart';
import '../../Pages/auth/pages/PhoneNumber/phone_number_repository.dart';
import '../../Pages/auth/pages/ResetPassword/reset_password_repository.dart';
import '../../Pages/auth/pages/Signup/sign_up_repository.dart';
import '../../Pages/splash/splash_repository.dart';
import '../../Services/Network/dio_helper.dart';
import '../../Services/cache_helper.dart';
import '../../Services/deep_link_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _registerCorporateCubit();

  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => MainBloc(
      repository: sl(),
    ),
  );
  sl.registerFactory(
    () => OtherServiceCubit(sl(), sl()),
  );
  // Use cases

  // Repository
  sl.registerLazySingleton<OtherServiceRepository>(
    () => OtherServiceRepositoryImpl(
      dioHelper: sl(),
      cacheHelper: sl(),
    ),
  );
  sl.registerLazySingleton<MainRepository>(
    () => MainRepository(
      dioHelper: sl(),
      cacheHelper: sl(),
    ),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<PackagesScreenRepository>(
    () => PackagesScreenRepositoryImplementation(
        cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<PhoneNumberRepository>(
    () =>
        PhoneNumberRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<OTPRepository>(
    () => OTPRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<MyCarsRepository>(
    () => MyCarsRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImplementation(
        cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<SignUpRepository>(
    () => SignUpRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<ServiceRequestRepository>(
    () => ServiceRequestRepositoryImplementation(
        cacheHelper: sl(), dioHelper: sl()),
  );

  sl.registerLazySingleton<WenchServiceRepository>(
    () => WenchServiceRepositoryImplementation(
        cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<ChooseInsuranceCompanyRepository>(
    () => ChooseInsuranceCompanyRepositoryImplementation(
        cacheHelper: sl(), dioHelper: sl()),
  );
  sl.registerLazySingleton<FNOLRepository>(
    () => FNOLRepositoryImplementation(cacheHelper: sl(), dioHelper: sl()),
  );

  // Data sources

  // Core
  sl.registerLazySingleton<DioHelper>(
    () => DioImpl(),
  );

  sl.registerLazySingleton<CacheHelper>(
    () => CacheImpl(
      sl(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //deep link

  sl.registerSingleton<DynamicLinkService>(DynamicLinkServiceImpl());
}

void _registerCorporateCubit() {
  sl.registerLazySingleton<CorporateClientCubit>(() => CorporateClientCubit(
        splashRepository: sl<SplashRepository>(),
        corporateRepo: sl<CorporateRepo>(),
      ));
  sl.registerLazySingleton<CorporateRepo>(
      () => CorporateRepoImplem(cacheHelper: sl(), dioHelper: sl()));
}
