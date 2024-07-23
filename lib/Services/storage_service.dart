
/*
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
//shared preference and SQL,MySql,...etc (database).
//lang
//location
//token
//refresh  token (if any)
  String? lang;
  String? lat;
  String? lan;
  String? currentLocation;
  String storageKeyToken = "access_token";
  String storageEmail = "email";
  String rememberMe = "remember_me";
  String storageRefreshKeyToken = "refresh_token";
  String? myToken;
  String? userEmail;
  bool? rememberMeValue;
  String? refreshToken;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> changeLanguage(String language) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("lang", language);
    print('from web service change lang fun : $language \n');
    //en_US
    //ar_EG
    lang = language;
    return lang;
  }

  Future<bool?> setRememberMeValue(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(rememberMe, value);
    rememberMeValue = value;
    return rememberMeValue;
  }

  Future<String?> getCurrentLang() async {
    final SharedPreferences prefs = await _prefs;
    lang = prefs.getString('lang');
    return prefs.getString('lang');
  }

  Future<String?> getCurrentLocation() async {
    final SharedPreferences prefs = await _prefs;
    currentLocation = prefs.getString('location');
    lat = prefs.getString('lat');
    lan = prefs.getString('lan');
    return prefs.getString('location');
  }

  Future<String?> changeLocation(
      String location, String lat, String lan) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("location", location);
    prefs.setString("lat", lat);
    prefs.setString("lan", lan);
    currentLocation = location;
    return lang;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    myToken = prefs.getString(storageKeyToken);
    getRefreshToken();
    return prefs.getString(storageKeyToken);
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    userEmail = prefs.getString(storageEmail);
    return prefs.getString(storageEmail);
  }

  Future<bool?> getRememberMeValue() async {
    final SharedPreferences prefs = await _prefs;
    rememberMeValue = prefs.getBool(rememberMe);
    getRefreshToken();
    return prefs.getBool(rememberMe);
  }

  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await _prefs;
    refreshToken = prefs.getString(storageRefreshKeyToken);
    return prefs.getString(storageRefreshKeyToken);
  }

  Future<bool> clearToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(storageKeyToken);
  }

  Future<bool> clearRememberMeValue() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(rememberMe);
  }

  Future<bool> clearRefreshToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(storageRefreshKeyToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------

  Future<bool> setToken(String token) async {
    myToken = token;

    final SharedPreferences prefs = await _prefs;

    return prefs.setString(storageKeyToken, token);
  }

  Future<bool> setEmail(String email) async {
    userEmail = email;

    final SharedPreferences prefs = await _prefs;

    return prefs.setString(storageEmail, email);
  }

  Future<bool> setRefreshToken(String token) async {
    refreshToken = token;

    final SharedPreferences prefs = await _prefs;

    return prefs.setString(storageRefreshKeyToken, token);
  }
}
*/
