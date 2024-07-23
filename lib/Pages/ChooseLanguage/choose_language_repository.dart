import 'package:helpooappclient/Services/Network/dio_helper.dart';

import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Services/cache_helper.dart';
import '../../Services/storage_service.dart';

class ChooseLanguageRepository{
//  final StorageService _storageService = StorageService();
  final CacheHelper cacheHelper = sl<CacheHelper>();

  Future<dynamic> changeLang(
      String lang,
      ) {
    return cacheHelper.put(Keys.languageCode, lang);
  }
}