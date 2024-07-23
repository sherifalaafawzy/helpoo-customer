import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/types_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:shimmer/shimmer.dart';
import '../../../main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../Style/theme/colors.dart';
import '../../Widgets/error_imge_holder.dart';
import 'api_endpoints.dart';

// bool isEnglish = false;
double bottomPaddingToAvoidBottomNav = 8.0;
bool isArabic =
    NavigationService.navigatorKey.currentContext?.locale.isArabic ?? true;
String emailPattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
String passwordPatternSpecial =
    r"(?=^.{8,}$)(?=.*[!@#$%^&*]+)(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"; //Registration (1 upper case, 1 lower case, 1 special character) length = 8
String passwordPatternNumeric =
    r"(?=^.{8,}$)(?=.*\\d)(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"; //Registration (1 upper case, 1 lower case, 1 number) length = 8

String encryptData({
  required String plainText,
}) {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(8);
  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

  return encrypter.encrypt(plainText, iv: iv).base64;
}

String? decryptData({
  String? base64,
}) {
  if (base64 == null) return null;

  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(8);
  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

  return encrypter.decrypt(encrypt.Encrypted.fromBase64(base64), iv: iv);
}

bool isRTL = true;
bool isDark = false;
String languageCode = 'ar';

// List<BoxShadow> primaryShadow = [
//   BoxShadow(
//     color: ColorsManager.black.withOpacity(0.25),
//     blurRadius: 5,
//     offset: const Offset(0, 2),
//   ),
// ];
List<BoxShadow> primaryShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.25),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, 4), // changes position of shadow
  ),
];

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: borderGrey,
    );
  }
}

///* Supported Localization `List<Locale>[]`
List<Locale> localizeLanguages = const [
  Locale('ar', 'EG'),
  Locale('en', 'US'),
];

List<String> allFnolImages = [
  'id_img1',
  'id_img2',
  'id_img3',
  'id_img4',
  'img2',
  'img3',
  'img4',
  'img6',
  'img8',
  'img9',
  'img11',
  'img12',
  'img13',
  'img14',
  'img15',
  'img17',
  'img18',
  'img20',
  'img21',
  'img22',
  'img5',
  'glass_img1',
  'glass_img2',
  'air_bag_images',
];

Map<String, String> imagesNamesEn = {
  "img1": "Vin Number",
  "img2": "Odometer",
  "img3": "Hood, Grilles and Headlights",
  "img4": "Front Bumper",
  "img5": "Windshield",
  "img6": "Front Right corner",
  // "img7": "Right Front Fender and Right Front Rim",
  "img8": "Front Right Door, Fender & Rim",
  "img9": "Rear Right Door, Fender & Rim",
  // "img10": "Right Rear Fender and Right Rear Rim",
  "img11": "Rear Right corner",
  "img12": "Trunk and Tail Lights",
  "img13": "Rear Bumper",
  "img14": "Rear Glass",
  "img15": "Rear Left corner",
  // "img16": "Left Rear Fender and Left Rear Rim",
  "img17": "Rear Left Door, Fender & Rim",
  "img18": "Front Left Door, Fender & Rim",
  // "img19": "Left Front Fender and Left Front Rim",
  "img20": "Front Left corner",
  "img21": "Roof of the vehicle from the Left side",
  "img22": "Roof of the vehicle from the Right side",
  "img23": "vehicle Engine Basin",
  "img24": "Trunk of the vehicle from the inside",
  "internal_img1": "Front Salon",
  "internal_img2": "Rear Salon",
  "internal_img3": "Steering Wheel",
  "internal_img4": "Transmission",
  "internal_img5": "vehicle Engine Basin",
  "internal_img6": "Trunk of the vehicle from inside",
  "id_img1": "Front of Driver's License",
  "id_img2": "Back of  Driver's License",
  "id_img3": "Front of vehicle License",
  "id_img4": "Back of vehicle License",
  "id_img5": "Front of National ID",
  "id_img6": "Back of National ID",
  "glass_img1": "Right Corner Windshield",
  "glass_img2": "Left Corner Windshield",
  "glass_img3": "Windshield from the corner of the driver's seat",
  "glass_img4": "Passenger seat angle front windshield",
};

Map<String, String> imagesNamesAr = {
  "img1": "رقم الشاسية",
  "img2": "عداد الكيلومتر",
  "img3": "الكبوت و الشبكة و الكشافات الأمامية",
  "img4": "الاكصدام الأمامي",
  "img5": "الزجاج الأمامي",
  "img6": "الزاوية الأمامية اليمنى",
  // "img7": "الرفرف الأمامي الايمن و الجنط الأمامي الايمن",
  "img8": "الباب و الرفرف و الجنط الأمامي الايمن",
  "img9": "الباب و الرفرف و الجنط الخلفي الايمن",
  // "img10": "الرفرف الخلفي الايمن و الجنط الخلفي الايمن",
  "img11": "الزاوية الخلفية اليمنى",
  "img12": "الشنطة و الكشافات الخلفية",
  "img13": "الاكصدام الخلفي",
  "img14": "الزجاج الخلفي",
  "img15": "الزاوية الخلفية اليسرى",
  // "img16": "الرفرف الخلفي الايسر و الجنط الخلفي الايسر",
  "img17": "الباب و الرفرف و الجنط الخلفي الايسر",
  "img18": "الباب و الرفرف و الجنط الأمامي الايسر",
  // "img19": "الرفرف الأمامي الايسر و الجنط الأمامي الايسر",
  "img20": "الزاوية الأمامية اليسرى",
  "img21": "سقف السيارة من الجانب الايسر",
  "img22": "سقف السيارة من الجانب الايمن",
  "img23": "حوض موتور السيارة",
  "img24": "شنطة السيارة من الداخل",
  "internal_img1": "الصالون الأمامي",
  "internal_img2": "الصالون الخلفي",
  "internal_img3": "عجلة القيادة",
  "internal_img4": "ناقل الحركة",
  "internal_img5": "حوض موتور السيارة",
  "internal_img6": "شنطة السيارة من الداخل",
  "id_img1": "صورة رخصة السائق الأمامية",
  "id_img2": "صورة رخصة السائق الخلفية",
  "id_img3": "صورة رخصة السيارة الأمامية",
  "id_img4": "صورة رخصة السيارة الخلفية",
  "id_img5": "صورة الرقم القومي الأمامية",
  "id_img6": "صورة الرقم القومي الخلفية",
  "glass_img1": "الزجاج الأمامي من الزاوية اليمنى",
  "glass_img2": "الزجاج الأمامي من الزاوية اليسرى",
  "glass_img3": "الزجاج الأمامي من زاوية مقعد السائق",
  "glass_img4": "الزجاج الأمامي من زاوية مقعد الراكب",
  "air_bag_images": "صور الوسادات الهوائية",
};

List<String> shootingInstructionsAr = [
  "التأكد من أن الاضاءة جيدة حول السيارة",
  "البعد عن السيارة مسافة لاتقل عن متر ولاتزيد عن  متران",
  "وضع التصوير في الوضع الافقي مع اتباع تعليمات التطبيق",
];
List<String> shootingInstructionsEn = [
  "Make sure that the lighting around the car is good.",
  "The distance from the car should not be less than one meter and not more than two meters.",
  "Place the camera in horizontal mode while following the application's instructions.",
];
List<String> additionalShootingInstructionsAr = [
  'الوسادات الهوائيىة المنفجرة',
  'اي نقر أو شرخ بالزجاج الأمامى و غير واضح بالصور',
  'اى تلفيات اخرى و غير واضحه بالصور'
];
List<String> additionalShootingInstructionsEn = [
  "Deployed airbags.",
  "Any chip or crack in the front windshield that is unclear in the photos.",
  "Any other damages not clear in the photos.",
];
List<String> documentsShootInstructionsAr = [
  'يرجى التصوير بشكل واضح',
  'يرجى التصوير تباعاً صفحة صفحة',
  'يرجى التصوير فى إضاءة مناسبة'
];
List<String> documentsShootInstructionsEn = [
  "Please take clear photos.",
  "Please take photos one page at a time.",
  "Please take photos in proper lighting.",
];

Duration duration300 = const Duration(milliseconds: 300);
Duration duration500 = const Duration(milliseconds: 500);
Duration durationSecond = const Duration(seconds: 1);

void launchMap({required double latitude, required double longitude}) async {
  String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  if (!await launchUrl(
    Uri.parse(googleMapsUrl),
  )) {
    throw Exception(
      'Could not launch $googleMapsUrl',
    );
  }
}

Future<List<File>> pickImagesFromGallery() async {
  final picker = ImagePicker();
  List<File> imageFiles = [];
  final pickedImages = await picker.pickMultiImage();

  if (pickedImages != null) {
    imageFiles =
        pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    // Process or display the selected image files as desired
    return imageFiles;
  } else {
    // User canceled the image picking
    return imageFiles;
  }
}

const apiKey = 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc';
String MapApiKey = Platform.isIOS
    ? 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc'
    : 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc'; //test key

String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjE0NzUsImlhdCI6MTY5MDk4MDg5NH0.cLUQCVzxtIC4cZI6nLymdogGIVAm1Xz-nFQAZHlQ4UU';
String userRoleName = '';
String userName = '';
int currentCompanyId = 0;
int inspectorId = 0;
String clientId = '';
String userId = '';
String userPhone = '';
String userEmail = ''; // 01010101010

Map<String, bool> availablePayments = {};

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

double getYPosition(GlobalKey key) {
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);

  return position.dy;
}

double getXPosition(GlobalKey key) {
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);

  return position.dx;
}

enum CarColors {
  red('أحمر', 'Red'),
  Orange('برتقالي', 'Orange'),
  Black('أسود', 'Black'),
  White('أبيض', 'White'),
  Silver('فضي', 'Silver'),
  Brown('بني', 'Brown'),
  Green('أخضر', 'Green'),
  Yellow('أصفر', 'Yellow'),
  Purple('بنفسجي', 'Purple'),
  Gold('ذهبي', 'Gold'),
  Beige('بيج', 'Beige'),
  Blue('أزرق', 'Blue'),
  Gray('رمادي', 'Gray');

  final String nameAr;
  final String nameEn;

  const CarColors(this.nameAr, this.nameEn);
}

List<String> days = List.generate(31, (index) => (index + 1).toString());
List<String> months = List.generate(12, (index) => (index + 1).toString());
List<String> years =
    List.generate(50, (index) => (DateTime.now().year - index + 1).toString());

///* arabic letters list
// ///* years list
// List<String> years =
//     List.generate(50, (index) => (DateTime.now().year - index).toString());

///* arabic letters list
const List<String> arabicLetters = [
  'ا',
  'ب',
  'ت',
  'ث',
  'ج',
  'ح',
  'خ',
  'د',
  'ذ',
  'ر',
  'ز',
  'س',
  'ش',
  'ص',
  'ض',
  'ط',
  'ظ',
  'ع',
  'غ',
  'ف',
  'ق',
  'ك',
  'ل',
  'م',
  'ن',
  'ه',
  'و',
  'ي',
  'ء',
];

Color popUpShadow = const Color(0xff000000).withOpacity(0.36);

const String mainColor = '44B649';
const String mainColor2 = '04101B';
const Color secondary = Color.fromRGBO(5, 16, 39, 1.0);
const Color secondaryVariant = Color.fromRGBO(5, 16, 39, 0.6);
const Color secondaryGrey = Color.fromRGBO(5, 16, 39, 0.4);
const Color borderGrey = Color.fromRGBO(45, 45, 45, 0.13);

const String darkerGreyColor = '989898';
const String darkGreyColor = '67718A';
const String regularGrey = 'E9E8E7';
const String liteGreyColor = 'F9F8F7';
const Color regularBlack = Color.fromRGBO(45, 49, 66, 1.0);
const Color backgroundColor = Color(0xfff7f7f9);
const Color textColor = Color(0xff636578);
const Color textGrayColor = Color(0xffa9a1a4);
const String greenColor = '07B055';
const String blueColor = '0E72ED';
const String transparentBg = 'F2F4F7';
const String textBlack = '0B141F';
const Color whiteColor = Colors.white;

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

void debugPrintFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

// TranslationModel get appTranslation => appBloc.translationModel;

enum TOAST { success, error, info, warning }

String appVersion = '';
String appBuildNumber = '';

// IconData chooseIcon(TOAST toast) {
//   late IconData iconData;
//
//   switch (toast) {
//     case TOAST.success:
//       iconData = FontAwesomeIcons.check;
//       break;
//     case TOAST.error:
//       iconData = FontAwesomeIcons.exclamation;
//       break;
//     case TOAST.info:
//       iconData = FontAwesomeIcons.info;
//       break;
//     case TOAST.warning:
//       iconData = FontAwesomeIcons.exclamation;
//       break;
//   }
//
//   return iconData;
// }

const successColor = ColorsManager.mainColor;
const errorColor = Colors.red;
const infoColor = Colors.blue;
const warningColor = Colors.amber;

Color chooseColor(TOAST toast) {
  late Color color;

  switch (toast) {
    case TOAST.success:
      color = successColor;
      break;
    case TOAST.error:
      color = errorColor;
      break;
    case TOAST.info:
      color = infoColor;
      break;
    case TOAST.warning:
      color = warningColor;
      break;
  }

  return color;
}
