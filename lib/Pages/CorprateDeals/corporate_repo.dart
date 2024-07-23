import 'package:helpooappclient/Models/packages/package_model.dart';
import 'package:helpooappclient/Models/user/user_model.dart';
import 'package:helpooappclient/Services/Network/dio_helper.dart';
import 'package:helpooappclient/Services/cache_helper.dart';

import '../../Configurations/Constants/keys.dart';

typedef UserData = ({String? userName, String? phoneNumber});

abstract class CorporateRepo {
  List<Package> getCorporatePackages(String corporateName);
  Future<UserData> getUserData();
}

class CorporateRepoImplem implements CorporateRepo {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  CorporateRepoImplem({required this.dioHelper, required this.cacheHelper});

  @override
  List<Package> getCorporatePackages(String corporateName) {
    // TODO: implement getCorporatePackages
    throw UnimplementedError();
  }

  @override
  Future<UserData> getUserData() async {
    final String? userName = await cacheHelper.get(Keys.userName);
    final String? userPhone = await cacheHelper.get(Keys.userPhone);
    return (userName: userName, phoneNumber: userPhone);
  }
}
