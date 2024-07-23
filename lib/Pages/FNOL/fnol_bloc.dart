import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';
import 'package:location/location.dart' as ll;
import 'package:geocoding/geocoding.dart' as GeocodingForCountry;

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/enums.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/cars/car_model.dart';
import '../../Models/cars/manufacturer_model.dart';
import '../../Models/cars/my_cars.dart';
import '../../Models/fnol/accident_report_details_model.dart';
import '../../Models/fnol/accident_types_model.dart';
import '../../Models/fnol/fnol_image_model.dart';
import '../../Models/fnol/latestFnolModel.dart';
import '../../Models/map_place_details_model.dart';
import '../../Models/maps/google_map_model.dart';
import '../../Services/cache_helper.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import 'fnol_repository.dart';
import 'widgets/mediaControllers.dart';

part 'fnol_event.dart';

part 'fnol_state.dart';

class FnolBloc extends Bloc<FnolEvent, FnolState> {
  final FNOLRepository fnolRepository = sl<FNOLRepository>();
  FnolBloc? fnolBloc;
  final CacheHelper cacheHelper = sl<CacheHelper>();
  TextEditingController policyCarPlateNumberController =
      TextEditingController();
  TextEditingController policyCarFirstCharController = TextEditingController();
  TextEditingController policyCarSecondCharController = TextEditingController();
  TextEditingController policyCarThirdCharController = TextEditingController();
  String selectedCarFirstChar = '';
  String selectedCarSecondChar = '';
  String selectedCarThirdChar = '';
  GlobalKey<FormFieldState> carFirstCharKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> carSecondCharKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> carThirdCharKey = GlobalKey<FormFieldState>();
  MapPlaceDetailsCoordinatesModel? mapPlaceDetailsCoordinatesModel;

  TextEditingController mapSearchFnolTextFieldCtrl = TextEditingController();
  var dir;
  GoogleMapsModel googleMapsModel = GoogleMapsModel();
  TextEditingController placeNameCtrl = TextEditingController();
  GetAccidentDetailsModel? accidentDetailsModel;

  bool isGetAccidentDetailsLoading = false;

  int fnolDetailsLastIndex = 0;

  bool _isSent = false;

  bool get isSent => _isSent;

  set isSent(bool value) {
    _isSent = value;
    emit(IsSentChanged());
  }

  FnolBloc() : super(FnolInitial()) {
    on<FnolEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitialFNOLEvent>((event, emit) async {
      //print(ModalRoute.of(event.context!)!.settings.arguments as MyCarModel);
      if ((ModalRoute.of(event.context!)?.settings.arguments) != null) {
        if ((ModalRoute.of(event.context!)!.settings.arguments is Map)) {
          selectedCar = (ModalRoute.of(event.context!)!.settings.arguments
              as Map)['MyCarModel'];
          print('object omar ${selectedCar?.insuranceCompany?.id}');
          selectedAccidentTypes = (ModalRoute.of(event.context!)!
              .settings
              .arguments as Map)['selectedAccidentTypes'];
          List<String> plateNumberChars = selectedCar!.plateNumber!.split("-");
          // check if the car plate number is start with number or not
          if (plateNumberChars[0].contains(RegExp(r'[0-9]')) ||
              plateNumberChars[0].isEmpty) {
            policyCarPlateNumberController.text = plateNumberChars[0];
            policyCarFirstCharController.text = plateNumberChars[1];
            policyCarSecondCharController.text = plateNumberChars[2];
            policyCarThirdCharController.text = plateNumberChars[3];
          } else {
            policyCarFirstCharController.text = plateNumberChars[0];
            policyCarSecondCharController.text = plateNumberChars[1];
            policyCarThirdCharController.text = plateNumberChars[2];
            policyCarPlateNumberController.text = plateNumberChars[3];
          }
        } else {
          selectedCar =
              (ModalRoute.of(event.context!)!.settings.arguments as MyCarModel);
        }
        emit(FnolInitial());
      }
    });
    on<GetLocationFromFnolEvent>((event, emit) async {
      emit(FNOLGetLocationLoading());

      //getLocationLoading = true;
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      cameraPosition = CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 14);
      var res2 = await GoogleMapsGeocoding(
          apiKey: MapApiKey,
          apiHeaders: {"accept-language": "ar"}).searchByLocation(
        Location(
          lat: currentPosition!.latitude,
          lng: currentPosition!.longitude,
        ),
      );
      debugPrint("res2 ================ ${MapApiKey}");
      debugPrint("res2 ================ ${res2.status}");
      debugPrint("res2 ================ ${res2.isDenied}");
      debugPrint("res2 ================ ${res2.errorMessage}");
      String address = res2.results[0].formattedAddress!;
      mapSearchFnolTextFieldCtrl.text = address;
      currentAddress = address;
      billDeliveryLocation = address;
      currentFnolStepAddress = address;
      billDeliveryLocation = address;
      LatLng x = await getLatLang(currentFnolStepAddress!);
      currentFnolStepLatLng = x;
      billDeliveryLatLng = x;
      currentLatLng =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);

      //setSRMapData();
      // setFnolMapData();

      //   getLocationLoading = false;
      emit(FNOLGetLocationDone());
      //  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      /* emit(GetLocationLoading());
      serviceEnabled = await location.serviceEnabled();
      if (!(serviceEnabled ?? false)) {
        //  ToastService.showErrorToast('Please Allow Location Access');
        HelpooInAppNotification.showErrorMessage(message: 'Please Allow Location Access');
        serviceEnabled = await location.requestService().then((value) async {
        if (!(value)) {
          HelpooInAppNotification.showErrorMessage(message: 'Please Allow Location Access');
        //  ToastService.showErrorToast('Please Allow Location Access');
        } else {
          locationData = await location.getLocation().then((value) async{
            GeocodingForCountry.Placemark? placemarks;
            if (value.latitude != null &&
                value.longitude != null) {
              placemarks = await GeocodingForCountry.placemarkFromCoordinates(
                  value.latitude!, value.longitude!,
                  localeIdentifier: await cacheHelper.get(Keys.languageCode).then((value) => value)).then((value) => value.first);
            String currentAddress2 =
            '${placemarks?.street}, ${placemarks?.subLocality},${placemarks?.subAdministrativeArea}, ${placemarks?.postalCode}';
            currentAddress = currentAddress2;//res2.results[0].formattedAddress!;
              print('address ya omar');
              print(currentAddress);

              currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.best);
            currentLatLng =
            LatLng(value.latitude!, value.longitude!);
            cameraPosition = CameraPosition(
            target: LatLng(value.latitude!, value.longitude!),
            zoom: 14);
            */
      /* var res2 = await GoogleMapsGeocoding(apiKey: MapApiKey).searchByLocation(
            pl.Location(
              lat: currentPosition!.latitude,
              lng: currentPosition!.longitude,
            ),
          );*/
      /*   debugPrint("res2 ================ ${MapApiKey}");
          debugPrint("res2 ================ ${res2.status}");
          debugPrint("res2 ================ ${res2.isDenied}");
          debugPrint("res2 ================ ${res2.errorMessage}");
          String address = res2.results[0].formattedAddress!;*/
      /*



            emit(GetPermissionAllowedState(
            selectedAddress: currentAddress,
            lang: value.longitude!,
            lat: value.latitude!));
             emit(GetLocationDone());

            }
            return value;
          });



        }
        return serviceEnabled;
      });
      }*/
    });
  }

  BillDeliveryTime billDeliveryTime = BillDeliveryTime.first;
  DateTime billDeliveryDate = DateTime.now();
  String billDeliveryTimeString = '09:00 AM - 1:00 PM';
  String billDeliveryLocation = "";
  String billDeliveryNotes = "";
  LatLng? billDeliveryLatLng;
  bool showFinalDeliveryData = false;
  int fnolImagesTaken = 0;
  int fnolImagesUploaded = 0;
  FNOLSteps? currentFnolStep;
  String? currentFnolStepAddress;
  LatLng? currentFnolStepLatLng;
  LocationFNOLSteps? currentLocationFnolStep;
  String fnolNamePrefix = "";
  List<AccidentTypeModel> selectedAccidentTypes = [];
  TextEditingController fnolCommentCtrl = TextEditingController();
  List<AccidentTypeModel> accidentTypes = [];
  List<LatestFnolModel> latestFnols = [];
  LatestFnolModel? fnolModel;
  MediaController mediaController = MediaController();
  bool? serviceEnabled;
  ll.LocationData? locationData;
  ll.Location location = ll.Location();
  String currentAddress = "";
  Position? currentPosition;

  LatLng? currentLatLng;
  LatLng initialCameraPosition = const LatLng(30.0595581, 31.223445);
  MapPickerController mapPickerController = MapPickerController();
  MyCarModel? selectedCar;
  LatLng? cameraMovementPosition;
  CameraPosition? cameraPosition;
  GoogleMapController? mapController;
  List<Manufacturer> manufactures = [];
  List<CarModel> models = [];

  void changeBillTime(BillDeliveryTime status) {
    billDeliveryTime = status;
    if (billDeliveryTime == BillDeliveryTime.first) {
      billDeliveryTimeString = '09:00 AM - 1:00 PM';
    } else {
      billDeliveryTimeString = '01:00 PM - 5:00 PM';
    }
    emit(ChangeBillTime());
  }

  void renderFinalBillData(value) {
    showFinalDeliveryData = value;
    emit(RenderBillDeliveryFinalData());
  }

  Future updateFnolStepLocation(
      {required stepEnum,
      required locationName,
      required lat,
      required lng,
      required address,
      required id}) async {
    emit(UpdateFnolStepLocationLoading());
    print('locationName $locationName}');
    final result = await fnolRepository.updateFnolStepLocation(
        stepEnum: stepEnum,
        locationName: locationName,
        lat: lat,
        lng: lng,
        address: address,
        id: id);
    result.fold((l) {
      debugPrint(l);
      emit(UpdateFnolStepLocationError(error: l.toString()));
    }, (r) {
      emit(UpdateFnolStepLocationSuccess());
    });
  }

  void updateFnolBill() async {
    emit(UpdateFnolBillLoading());

    final result = await fnolRepository.updateFnolBill(
        id: fnolModel!.id!,
        date: billDeliveryDate,
        notes: billDeliveryNotes,
        time: billDeliveryTimeString,
        address: billDeliveryLocation,
        lat: billDeliveryLatLng!.latitude,
        lng: billDeliveryLatLng!.longitude);
    result.fold((l) {
      debugPrint(l);
      emit(UpdateFnolBillError(error: l.toString()));
    }, (r) {
      emit(UpdateFnolBillSuccess());
    });
  }

  Future<void> updateFnolAdditionalFields(Map<String, dynamic> data) async {
    emit(UpdateFnolAdditionalFieldsLoading());
    final result = await fnolRepository.updateFnolAdditionalFields(
        accidentId: fnolModel!.id!, data: data);
    result.fold((l) {
      debugPrint(l);
      emit(UpdateFnolAdditionalFieldsError(error: l.toString()));
    }, (r) {
      emit(UpdateFnolAdditionalFieldsSuccess());
    });
  }

  // get required images
  List<String> requiredImagesTags = [];

  bool isGetRequiredImagesTagsLoading = false;

  void getRequiredImagesTags() async {
    emit(GetRequiredImagesTagsLoading());
    isGetRequiredImagesTagsLoading = true;

    requiredImagesTags.clear();

    final result =
        await fnolRepository.getFnolRequiredImagesBasedOnSelectedTypes(
            accidentTypes: selectedAccidentTypes.map((e) => e.id!).toList());

    result.fold((l) {
      debugPrint(l);

      emit(GetRequiredImagesTagsError(error: l.toString()));
      isGetRequiredImagesTagsLoading = false;
    }, (r) {
      requiredImagesTags = r.requiredImages!;
      isGetRequiredImagesTagsLoading = false;
      emit(GetRequiredImagesTagsSuccess());
    });
  }

  bool isAllCarAccidentSelected = false;

  void addAccidentType({
    required AccidentType accidentType,
  }) {
    //  printMeLog("accidentType   " + accidentType.toString());

    if (selectedAccidentTypes
        .map((e) => e.type)
        .toList()
        .contains(accidentType)) {
      if (accidentType == AccidentType.allCarAccident) {
        selectedAccidentTypes.clear();
        isAllCarAccidentSelected = false;
      } else {
        selectedAccidentTypes.remove(selectedAccidentTypes
            .where((element) => element.type == accidentType)
            .first);
      }

      emit(AccidentTypeRemoved());
    } else if (accidentType == AccidentType.allCarAccident) {
      selectedAccidentTypes.clear();
      isAllCarAccidentSelected = true;
      selectedAccidentTypes.add(
          accidentTypes.where((element) => element.type == accidentType).first);
      emit(AccidentTypeAdded());
    } else {
      selectedAccidentTypes.add(
          accidentTypes.where((element) => element.type == accidentType).first);
      emit(AccidentTypeAdded());
    }
    for (var i = 0; i < selectedAccidentTypes.length; i++) {
      print("selectedAccidentTypes $i " +
          selectedAccidentTypes[i].arName.toString());
    }
  }

  bool isAccidentSelected({
    required AccidentType accidentType,
  }) {
    return selectedAccidentTypes
        .map((e) => e.type)
        .toList()
        .contains(accidentType);
  }

  // handle accident types enum based on id

  AccidentType getAccidentTypeById({
    required int id,
  }) {
    // print("id: $id");
    switch (id) {
      case 1:
        return AccidentType.general;
      case 2:
        return AccidentType.checkIn;
      case 3:
        return AccidentType.frontAccident;
      case 4:
        return AccidentType.backAccident;
      case 5:
        return AccidentType.rightSideAccident;
      case 6:
        return AccidentType.leftSideAccident;
      case 7:
        return AccidentType.frontClassAccident;
      case 8:
        return AccidentType.allCarAccident;
      case 9:
        return AccidentType.checkIn;
      case 10:
        return AccidentType.checkOut;
      case 11:
        return AccidentType.carRoofAccident;
      case 13:
        return AccidentType.backClassAccident;
      default:
        return AccidentType.general;
    }
  }

  String getImageDescription(String requiredImage) {
    try {
      if (isArabic) {
        return imagesNamesAr[requiredImage] ?? requiredImage;
      } else {
        return imagesNamesEn[requiredImage] ?? requiredImage;
      }
    } catch (e) {
      return requiredImage;
    }
  }

  List<Images> mainImages = [];
  List<Images> additionalImages = [];
  List<Images> policeImages = [];
  List<Images> beforeImages = [];
  List<Images> supplementImages = [];
  List<Images> reservayImages = [];

  void setFnolSummaryImages() {
    for (var i = 0; i < fnolModel!.images!.length; i++) {
      if (fnolModel!.images![i].additional == false) {
        mainImages.add(fnolModel!.images![i]);
      }
      if (fnolModel!.images![i].additional == true &&
          (!fnolModel!.images![i].imageName!.contains("police") &&
              !fnolModel!.images![i].imageName!.contains("repair_before") &&
              !fnolModel!.images![i].imageName!.contains("supplement") &&
              !fnolModel!.images![i].imageName!.contains("resurvey"))) {
        additionalImages.add(fnolModel!.images![i]);
      }
      if (fnolModel!.images![i].additional == true &&
          fnolModel!.images![i].imageName!.contains("police")) {
        policeImages.add(fnolModel!.images![i]);
      }
      if (fnolModel!.images![i].additional == true &&
          fnolModel!.images![i].imageName!.contains("repair_before")) {
        beforeImages.add(fnolModel!.images![i]);
      }
      if (fnolModel!.images![i].additional == true &&
          fnolModel!.images![i].imageName!.contains("supplement")) {
        supplementImages.add(fnolModel!.images![i]);
      }
      if (fnolModel!.images![i].additional == true &&
          fnolModel!.images![i].imageName!.contains("resurvey")) {
        reservayImages.add(fnolModel!.images![i]);
      }
    }
    emit(HandleFnolImagesLists());
  }

  List<String> capturedImages = [];

  void addCapturedImage({
    required String image,
  }) {
    if (!capturedImages.contains(image)) {
      capturedImages.add(image);
      emit(CapturedImageAdded());
    }
  }

  // check if all images are captured
  bool isAllImagesCaptured = false;
  bool isAskAdditionalAppear = false;

  // show required images one by one to user

  int currentImageIndex = 0;

  void nextImage() {
    //printMeLog("currentImageIndex" + currentImageIndex.toString());
    //printMeLog(requiredImagesTags.length.toString());

    if (currentImageIndex < requiredImagesTags.length - 1) {
      currentImageIndex++;
      emit(NextImage());
    } else {
      isAllImagesCaptured = true;
      emit(AllImagesCaptured());
    }
  }

  // get images type from assets

  String getImageType({
    required String image,
  }) {
    String imageType = '';

    if (image.contains('id_img')) {
      imageType = 'png';
    } else if (image.contains('air_bag_images')) {
      imageType = 'jpg';
    } else {
      imageType = 'gif';
    }
    return imageType;
  }

  // handle camera

  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  void initCameraController() async {
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
    if (!await Permission.photos.isGranted) {
      await Permission.photos.request();
    }
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }

    // cameraController = CameraController(
    //   // cameras[0],
    //   cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.back),
    //   ResolutionPreset.veryHigh,
    // );
    CameraDescription cam = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back);
    cam = CameraDescription(
      name: cam.name,
      lensDirection: cam.lensDirection,
      sensorOrientation: 90,
    );
    cameraController = CameraController(cam, ResolutionPreset.veryHigh);

    cameraController?.initialize().then((_) {
      if (!(cameraController?.value.isInitialized ?? false)) {
        emit(CameraError(error: 'Camera is not initialized'));
      } else {
        emit(CameraInitialized());
      }
    });
  }

  bool isSupplementShot = false;
  bool isFnolAdditional = false;
  bool fnolAdditionalImagesUploded = false;
  FlashMode flashMode = FlashMode.off;

  void turnOnFlash() async {
    await cameraController?.setFlashMode(FlashMode.torch);
    flashMode = FlashMode.torch;
    //  emit(FlashOn());
  }

  Future<void> turnOffFlash() async {
    await cameraController?.setFlashMode(FlashMode.off);
    flashMode = FlashMode.off;
    // emit(FlashOff());
  }

  // take picture

  late XFile? imageFile;
  late Uint8List imagebytes;
  late String base64String;

  File? _image;

  File? get imageFnol => _image;

  set setImage(File file) {
    _image = file;
    emit(ImagePicked());
  }

  int index = 0;
  bool imageTaken = false;

  void takePicture() async {
    emit(TakePictureLoading());
    try {
      imageFile = await cameraController?.takePicture();
      imageTaken = true;
      emit(TakeImageRender());

      setImage = File(imageFile?.path ?? '');

      imagebytes = await File(imageFile?.path ?? '').readAsBytes();
      base64String = base64.encode(imagebytes);

      emit(TakePictureSuccess());
    } catch (e) {
      emit(TakePictureError(error: e.toString()));
    }
  }

  bool isStillShooting = false;
  void nextAndUploadImageButton() async {
    isStillShooting = true;
    fnolImagesTaken++;
    imageTaken = false;
    emit(TakeImageRender());

    if (isSupplementShot) {
      setAdditionalNamePrefix();
    }
    base64String = await convertImageToFile(image: base64String);
    index++;
    imageTaken = false;
    emit(TakeImageRender());

    if (!isSupplementShot) {
      fnolNamePrefix = requiredImagesTags[currentImageIndex];
    }
    FnolImageModel image = FnolImageModel(
        additional: isSupplementShot || isFnolAdditional ? true : false,
        imageName: isSupplementShot || isFnolAdditional
            ? fnolNamePrefix + index.toString()
            : fnolNamePrefix,
        image: base64String);
    if (!isSupplementShot) {
      nextImage();
    }
    final result = await fnolRepository.uploadFnolImages(
      image: image,
      id: fnolModel!.id!,
    );
    result.fold((failure) {
      // debugPrint(failure);
      // fnolRepository.uploadFnolImages(
      //   image: image,
      //   id: fnolModel!.id!,
      // );
      emit(uploadFnolImageErrorState(error: failure));
    }, (data) {
      fnolImagesUploaded++;
      if (isFnolAdditional) {
        emit(UploadAdditionalImagesSuccess());
      } else {
        emit(UploadImagesSuccess());
      }
    });
    // if (isSupplementShot) {
    //   await fnolRepository.updateFnolStatus(
    //       status: currentFnolStep!.apiName, id: fnolModel!.id!);
    // }
    isStillShooting = false;
  }

  void retakeImageButton() {
    imageTaken = false;
    emit(TakeImageRender());

    base64String = "";
    emit(RetakeFnolImage());
  }

  void doneImageButton() async {
    emit(DonaCameraImagesTaked());
    //flashMode = FlashMode.off;
    await cameraController?.setFlashMode(FlashMode.off);
    emit(FlashOff());
    isAllImagesCaptured = true;
    fnolAdditionalImagesUploded = true;
    fnolImagesTaken++;
    imageTaken = false;
    emit(TakeImageRender());

    if (isSupplementShot) {
      setAdditionalNamePrefix();
    } else {
      fnolNamePrefix = requiredImagesTags[currentImageIndex];
    }
    base64String = await convertImageToFile(image: base64String);
    index++;
    imageTaken = false;
    emit(TakeImageRender());

    FnolImageModel image = FnolImageModel(
        additional: isSupplementShot || isFnolAdditional ? true : false,
        imageName: isSupplementShot || isFnolAdditional
            ? fnolNamePrefix + index.toString()
            : fnolNamePrefix,
        image: base64String);
    final result = await fnolRepository.uploadFnolImages(
      image: image,
      id: fnolModel!.id!,
    );
    result.fold((failure) {
      debugPrint(failure);
      fnolRepository.uploadFnolImages(
        image: image,
        id: fnolModel!.id!,
      );
      emit(uploadFnolImageErrorState(error: failure));
    }, (data) {
      fnolImagesUploaded++;

      if (isFnolAdditional) {
        emit(UploadAdditionalImagesSuccess());
      } else {
        emit(UploadImagesSuccess());
      }
    });
    if (isSupplementShot) {
      await fnolRepository.updateFnolStatus(
          status: currentFnolStep!.apiName, id: fnolModel!.id!);
    }
    emit(DoneAllCameraFnolImageUpload());
  }

  void uploadFnolCommentAndVoice(FnolBloc? fnolBloc2, Function callBack) async {
    fnolImagesTaken++;
    //emit(UpdateFnolCommentAndVoiceStart());
    //emit(UpdateFnolCommentAndVoiceLoading());
    debugPrint('record file path>>>>>>>>>: ${mediaController.audioFilePath}');
    if (mediaController.recordState == RecordState.record ||
        mediaController.recordState ==
            RecordState.pause) if (mediaController.audio64 == null) {
      mediaController.timer?.cancel();
      mediaController.recordDuration = 0;
      final path = await mediaController.audioRecorder.stop();
      debugPrint('Recorded file path>>>>>>>>>: $path');
      if (path != null) {
        mediaController.audioFilePath = path;
        await mediaController.convertAudioTo64(
            mediaController.audioFilePath, fnolBloc2!);
        mediaController.amplitudeSub!.cancel();
      }
    }

    final result = await fnolRepository.uploadFnolCommentAndVoice(
        comment: fnolCommentCtrl.text,
        id: fnolModel!.id!,
        voice: mediaController.audio64 ?? '');
    result.fold((l) {
      debugPrint(l);
      fnolRepository.uploadFnolCommentAndVoice(
          comment: fnolCommentCtrl.text,
          id: fnolModel!.id!,
          voice: mediaController.audio64!);
      //    emit(UpdateFnolCommentAndVoiceError(error: l.toString()));
    }, (r) {
      fnolImagesUploaded++;
      callBack();

//     emit(UpdateFnolCommentAndVoiceSuccess());
    });
  }

  Future<String> convertImageToFile({
    required String image,
  }) async {
    Uint8List imageBytes = base64.decode(image);

    Uint8List compressedImage = await compressImage(
      bytes: imageBytes,
    );

    //  debugPrint("compressed image size: ${compressedImage.lengthInBytes}");
    // final XFile image=await cameraController!.takePicture();
    return base64.encode(compressedImage);
  }

  int minHeightCompress = 1000;
  int minWidthCompress = 1000;
  int qualityCompress = 75;

  Future<Uint8List> compressImage({
    required Uint8List bytes,
  }) async {
    var compressedImageBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: minHeightCompress,
      minWidth: minWidthCompress,
      quality: qualityCompress,
    );

    if (!checkCompressedImageSize(compressed: compressedImageBytes)) {
      minHeightCompress -= 100;
      minWidthCompress -= 100;

      qualityCompress -= 5;

      compressedImageBytes = await compressImage(bytes: compressedImageBytes);
    }

    return compressedImageBytes;
  }

  bool checkCompressedImageSize({
    required Uint8List compressed,
  }) {
    return compressed.lengthInBytes <= 1000000;
  }

  List<File>? _pickedImages;

  List<File>? get pickedImages => _pickedImages;

  set setPickedImages(List<File> files) {
    _pickedImages = files;
    emit(ImagesPicked());
  }

  void uploadPhotosFromGallery() async {
    emit(UploadImagesLoading());
    try {
      setPickedImages = await pickImagesFromGallery();
      if (pickedImages!.isNotEmpty) {
        for (int i = 0; i < pickedImages!.length; i++) {
          Uint8List imagebytes = await pickedImages![i].readAsBytes();
          String base64String = base64.encode(imagebytes);

          setAdditionalNamePrefix();
          base64String = await convertImageToFile(image: base64String);
          FnolImageModel image = FnolImageModel(
              additional: true,
              imageName: fnolNamePrefix + (i + 1).toString(),
              image: base64String);
          final result = await fnolRepository.uploadFnolImages(
            image: image,
            id: fnolModel!.id!,
          );
          result.fold((failure) {
            debugPrint(failure);
            fnolRepository.uploadFnolImages(
              image: image,
              id: fnolModel!.id!,
            );
            emit(uploadFnolImageErrorState(error: failure));
          }, (data) {
            emit(UploadImagesSuccess());
          });
        }
        await fnolRepository.updateFnolStatus(
            status: currentFnolStep!.apiName, id: fnolModel!.id!);
      }
      // emit(UploadImagesSuccess());
    } catch (e) {
      emit(UploadImagesError(error: e.toString()));
    }
  }

  setAdditionalNamePrefix() {
    switch (currentFnolStep) {
      case FNOLSteps.policeReport:
        fnolNamePrefix = 'police';
      case FNOLSteps.bRepair:
        fnolNamePrefix = 'repair_before';

      case FNOLSteps.supplement:
        fnolNamePrefix = 'supplement';

      case FNOLSteps.resurvey:
        fnolNamePrefix = 'resurvey';

      case FNOLSteps.additional:
        fnolNamePrefix = 'air_bag_images';

      default:
        fnolNamePrefix = '';
    }
    //  printMe("fnolNamePrefix    " + fnolNamePrefix);
  }

  Map<String, String> imagesInstructions = {
    "img1": "رقم الشاسية",
    "img2": "عداد الكيلومتر",
    "img3": "الكبوت و الشبكة و الكشافات الأمامية",
    "img4": "الاكصدام الأمامي",
    "img5": "الزجاج الأمامي",
    "img6": "الزاوية الأمامية اليمنى",
    "img7": "الرفرف الأمامي الايمن و الجنط الأمامي الايمن",
    "img8": "الباب و الرفرف و الجنط الأمامي الايمن",
    "img9": "الباب و الرفرف و الجنط الخلفي الايمن",
    "img10": "الرفرف الخلفي الايمن و الجنط الخلفي الايمن",
    "img11": "الزاوية الخلفية اليمنى",
    "img12": "الشنطة و الكشافات الخلفية",
    "img13": "الاكصدام الخلفي",
    "img14": "الزجاج الخلفي",
    "img15": "الزاوية الخلفية اليسرى",
    "img16": "الرفرف الخلفي الايسر و الجنط الخلفي الايسر",
    "img17": "الباب و الرفرف و الجنط الخلفي الايسر",
    "img18": "الباب و الرفرف و الجنط الأمامي الايسر",
    "img19": "الرفرف الأمامي الايسر و الجنط الأمامي الايسر",
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
    'air_bag_images': 'صورة الوسدات الهوائية',
  };

  Future<void> getLocation() async {
    emit(FNOLGetLocationLoading());
    serviceEnabled = await location.serviceEnabled();
    if (!(serviceEnabled ?? false)) {
      //  ToastService.showErrorToast('Please Allow Location Access');
      HelpooInAppNotification.showErrorMessage(
          message: LocaleKeys.pleaseAllowLocationAccess.tr());
      serviceEnabled = await location.requestService().then((value) async {
        if (!(value)) {
          HelpooInAppNotification.showErrorMessage(
              message: LocaleKeys.pleaseAllowLocationAccess.tr());
          //  ToastService.showErrorToast('Please Allow Location Access');
        } else {
          locationData = await location.getLocation().then((value) async {
            GeocodingForCountry.Placemark? placemarks;
            if (value.latitude != null && value.longitude != null) {
              placemarks = await GeocodingForCountry.placemarkFromCoordinates(
                      value.latitude!, value.longitude!,
                      localeIdentifier: await cacheHelper
                          .get(Keys.languageCode)
                          .then((value) => value))
                  .then((value) => value.first);
              String currentAddress2 =
                  '${placemarks?.street}, ${placemarks?.locality}'; //${placemarks?.subAdministrativeArea}, ${placemarks?.postalCode}';
              currentAddress =
                  currentAddress2; //res2.results[0].formattedAddress!;
              print('address ya omar');
              print(currentAddress);
              currentLatLng = LatLng(value.latitude!, value.longitude!);

              /*   emit(GetPermissionAllowedState(
                  selectedAddress: currentAddress,
                  lang: value.longitude!,
                  lat: value.latitude!));

           */
              emit(FNOLGetLocationDone());
            }
            return value;
          });
        }
        return serviceEnabled;
      });
    }
  }

  void getAllAccidentTypes() async {
    accidentTypes = [];
    emit(GetAllAccidentTypesLoading());

    final result = await fnolRepository.getAllAccidentTypes();
    result.fold((l) {
      debugPrint(l);
      emit(GetAllAccidentTypesError(error: l.toString()));
    }, (r) {
      accidentTypes = r.types!;

      for (var element in accidentTypes) {
        print(element.enName);
        print(element.id);
        element.type = getAccidentTypeById(id: element.id!);
      }
      emit(GetAllAccidentTypesSuccess());
    });
  }

  onCameraMoveStarted() async {
    mapPickerController.mapMoving!();
  }

  onCameraMove({
    required CameraPosition cameraPositionValue,
  }) async {
    cameraPosition = cameraPositionValue;
    cameraMovementPosition = cameraPositionValue.target;
  }

  void setMapController({
    required GoogleMapController controller,
  }) async {
    mapController = controller;

    //request?.requestLocationModel.clientAddress = currentAddress;
    //request?.requestLocationModel.clientPoint = currentLatLng;

    if (mapController != null && cameraPosition != null) {
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    }

    emit(FNOLSetMapControllerSuccess());
  }

  void createFnol() async {
    emit(CreateFnolLoading());
    List<String> listSelectedTypesIds = [];
    for (var i = 0; i < selectedAccidentTypes.length; i++) {
      listSelectedTypesIds.add(selectedAccidentTypes[i].id.toString());
    }
    final result = await fnolRepository.createFnol(date: {
      "createdByUser": await cacheHelper.get(Keys.currentUserId),
      "phoneNumber": await cacheHelper.get(Keys.userPhone),
      "carId": selectedCar!.id,
      "insuranceCompanyId": selectedCar!.insuranceCompany!.id.toString(),
      "accidentTypeId": json.encode(listSelectedTypesIds),
      "location": json.encode({
        "address": currentAddress,
        "lat": currentLatLng!.latitude,
        "lng": currentLatLng!.longitude,
      }),
    });
    result.fold((l) {
      emit(CreateFnolError(error: l.toString()));
    }, (r) {
      fnolModel = r;

      emit(CreateFnolSuccess());
    });
  }

  saveCurrentFnolStepAddressLatLngFromAddress(
      {required String controllerText}) async {
    currentFnolStepAddress = controllerText;
    billDeliveryLocation = controllerText;
    LatLng x = await getLatLang(currentFnolStepAddress!);
    currentFnolStepLatLng = x;
    billDeliveryLatLng = x;
  }

  Future<LatLng> getLatLang(String address) async {
    try {
      dir =
          await GoogleMapsGeocoding(apiKey: MapApiKey).searchByAddress(address);
      googleMapsModel.destination = LatLng(dir.results[0].geometry.location.lat,
          dir.results[0].geometry.location.lng);
      return googleMapsModel.destination!;
    } catch (e) {
      print(e.toString());
      return googleMapsModel.destination!;
    }
  }

  void getPlaceDetails({required Prediction option}) async {
    //  emit(GetPlacesDetailsLoading());
    //  isGetPlacesDetailsLoading = true;

    final result = await fnolRepository.getPlaceDetails(
      placeId: option.placeId!,
    );
    result.fold(
      (failure) {
        debugPrint(failure.toString());
      },
      (data) {
        if (mapController != null)
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  data.result.latitude.toDouble(),
                  data.result.longitude.toDouble(),
                ),
                zoom: 15.0,
              ),
            ),
          );

        //  saveSRLocationAddressLatLng(option: option);

        // saveCurrentFnolStepAddressLatLng(option: option);

        // isGetPlacesDetailsLoading = false;
      },
    );
  }

  Future<PlacesAutocompleteResponse> searchPlace(String placeName) async {
    var searchKeyWord;
    var res = await GoogleMapsPlaces(
      apiKey: MapApiKey,
    ).autocomplete(placeName,
        radius: 1000,
        components: [Component(Component.country, 'eg')],
        origin: Location(
            lat: currentPosition!.latitude, lng: currentPosition!.longitude),
        location: Location(
            lat: currentPosition!.latitude, lng: currentPosition!.longitude));

    // printWarning('===================${res.isDenied}');
    // printWarning('===================${res.status}');
    // printWarning('===================${res.errorMessage}');

    try {
      res.predictions.sort((a, b) => a.distanceMeters == null
          ? -1
          : b.distanceMeters == null
              ? 1
              : a.distanceMeters!.compareTo(b.distanceMeters!));
      for (var item in res.predictions) {
        // debugPrint(item.description! +
        //     " distance:" +
        //     item.distanceMeters.toString() +
        //     " meters");
        searchKeyWord = res.predictions;
      }
    } catch (e) {
      debugPrint("Error sort predictions by distance in meters");
    }
    return res;
  }

  Future<String?> getForceLocation() async {
    emit(GetLocationFnolLoadingState());
    locationData = await location.getLocation().then((value) async {
      print(value.latitude);
      print(value.longitude);
      GeocodingForCountry.Placemark? placemarks;
      if (value.latitude != null && value.longitude != null) {
        placemarks = await GeocodingForCountry.placemarkFromCoordinates(
                value.latitude!, value.longitude!,
                localeIdentifier:
                    await cacheHelper.get(Keys.languageCode).then((value) {
                  print("locale ${value}");
                  return value;
                }))
            .then((value) => value.first);
        String currentAddress2 =
            '${placemarks?.street}, ${placemarks?.locality}'; //,${placemarks?.subAdministrativeArea}, ${placemarks?.postalCode}';
        currentAddress = currentAddress2; //res2.results[0].formattedAddress!;
        print('address ya omar');
        print(currentAddress);

        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        currentLatLng = LatLng(value.latitude!, value.longitude!);
        cameraPosition = CameraPosition(
            target: LatLng(value.latitude!, value.longitude!), zoom: 14);

        emit(GetLocationFnolDone());
      }
      return value;
    }).catchError((e) {
      emit(GetLocationFnolErrorState());
    }).timeout(Duration(seconds: 5), onTimeout: () {
      emit(GetLocationFnolErrorState());
      return Future.error('Timeout');
    });

    if (currentAddress.isEmpty) {
      emit(GetLocationFnolErrorState());
    }
    return currentAddress;
  }

  Future<void> getPlaceByCoordinates() async {
    final result = await fnolRepository.getPlaceDetailsByCoordinates(
      latLng:
          '${cameraPosition?.target.latitude},${cameraPosition?.target.longitude}',
    );

    result.fold(
      (failure) {
        debugPrint(failure.toString());
        /* emit(
          GetMapPlaceCoordinatesDetailsError(
            error: failure,
          ),
        );*/
      },
      (data) {
        mapPlaceDetailsCoordinatesModel = data;
        mapSearchFnolTextFieldCtrl.text = data.placeName;
        currentLatLng = LatLng(
            cameraPosition!.target.latitude, cameraPosition!.target.longitude);
        emit(ChangeLocationState());
      },
    );
  }

  bool isSendFnolStepPdfLoading = false;

  void sendFnolStepPdf({
    required String pdfReportId,
    required String accidentId,
    required String pdf,
    required String type,
    required String carId,
    required String subject,
    required String body,
  }) async {
    isSendFnolStepPdfLoading = true;

    emit(SendFnolStepPdfLoading());

    final result = await fnolRepository.sendFnolStep(
      pdfReportId: pdfReportId,
      AccidentReportId: accidentId,
      carId: carId,
      pdfReport: pdf,
      Type: type,
      subject: subject,
      body: body,
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isSendFnolStepPdfLoading = false;
        emit(
          SendFnolStepPdfError(
            error: failure,
          ),
        );
      },
      (data) {
        isSendFnolStepPdfLoading = false;
        emit(
          SendFnolStepPdfSuccess(),
        );
      },
    );
  }

  void getAccidentDetails({
    required accidentId,
    bool forceRefresh = true,
    bool isFirstTime = false,
    required String from,
  }) async {
    isGetAccidentDetailsLoading = true;

    emit(AccidentDetailsLoading());

    final result =
        await fnolRepository.getAccidentDetails(accidentId: accidentId);

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isGetAccidentDetailsLoading = false;
        emit(
          AccidentDetailsError(
            error: failure,
          ),
        );
      },
      (data) {
        accidentDetailsModel = data;
        isGetAccidentDetailsLoading = false;

        debugPrint('-----------=====>>>> $from');

        emit(
          AccidentDetailsSuccess(
            from: from,
          ),
        );
      },
    );
  }
}
