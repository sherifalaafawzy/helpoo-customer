import 'package:dartz/dartz.dart';

import '../../Models/auth/login_model.dart';
import '../../Services/Network/dio_helper.dart';
import '../../Services/cache_helper.dart';

class MainRepository {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  MainRepository({
    required this.dioHelper,
    required this.cacheHelper,
  });
}

abstract class MainRepositoryAbstract{
  Future<Either<String, LoginModel>> login({
    required String identifier,
    required String password,
  });
}