import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:helpooappclient/Configurations/Constants/constants.dart';
import 'package:helpooappclient/Widgets/helpoo_in_app_notifications.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supercharged/supercharged.dart';

import '../../Configurations/Constants/enums.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/cars/add_car_dto.dart';
import '../../Models/cars/add_corporate_car_response.dart';
import '../../Models/cars/car_model.dart';
import '../../Models/cars/manufacturer_model.dart';
import '../../Models/cars/my_cars.dart';
import '../../Models/packages/package_model.dart';
import '../../Services/cache_helper.dart';
import '../../Services/navigation_service.dart';
import '../FNOL/fnol_bloc.dart';
import 'my_cars_repository.dart';

part 'my_cars_event.dart';

part 'my_cars_state.dart';

class MyCarsBloc extends Bloc<MyCarsEvent, MyCarsState> {
  TabController? tabController;
  final MyCarsRepository myCarsRepository = sl<MyCarsRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  String customerName = "";
  String customerPhoneNumber = "";
  CorporateUser? corporateUser;
  MyCarModel selectedCar = MyCarModel();
  bool addCarToPackage = false;
  bool isAddNewCarToPackage = false;
  bool activateCar = false;
  bool isAddCorporateCar = false;
  bool isAddCarServiceRequest = false;
  bool editCar = false;
  bool isTakeLicenseImages = false;
  bool isSubscribeCarLoading = false;
  bool isUpdateCarLoading = false;

  List<Manufacturer> manufactures = [];
  List<CarModel> models = [];
  CarModel? selectedModel;
  String? selectedCarColor;
  String? selectedCarVinNumber;
  List<Package> myPackages = [];
  TextEditingController policyCarPlateNumberController =
      TextEditingController();
  TextEditingController policyCarFirstCharController = TextEditingController();
  TextEditingController policyCarSecondCharController = TextEditingController();
  TextEditingController policyCarThirdCharController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientPhoneController = TextEditingController();
  TextEditingController insuranceCompanyName = TextEditingController();
  TextEditingController insurancePolicyNumber = TextEditingController();

  final TextEditingController carManufacturerController =
      TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  String selectedCarFirstChar = '';
  String selectedCarSecondChar = '';
  String selectedCarThirdChar = '';
  List<XFile> licensesImages = [];
  List<String> licensesBase64 = [];
  List<String> licensesPathes = [];
  String? frontLicense;
  String? backLicense;
  final ImagePicker picker = ImagePicker();
  Package selectedAddedPackage = Package();
  Manufacturer? selectedManufacturer;
  bool isGetAllManufacturesLoading = false;
  bool isGetModelsForManufacturerLoading = false;
  String? selectedCarYear;
  bool isAddCarLoading = false;
  bool isActivateCarLoading = false;
  MyCarModel? selectedCarToRequest;

  List<MyCarModel> allMyCars = [];

  List<MyCarModel> get myCarsAddedToPackage => allMyCars
      .where((element) =>
          (element.carPackages?.isNotEmpty ?? false) ||
          element.insuranceCompany?.arName != null)
      .toList();

  List<MyCarModel> get myCarsWithoutPackage => allMyCars
      .where((element) => (element.carPackages?.isEmpty ?? true)&&
      (element.insuranceCompany?.arName == null))
      .toList();

  MyCarsBloc() : super(CarsWithoutPackageInitialState()) {
    on<MyCarsEvent>((event, emit) {});
    on<HandleIntroEvent>((event, emit)async {
      if (ModalRoute.of(event.context!)?.settings.arguments is Map) {
        activateCar = (ModalRoute.of(event.context!)?.settings.arguments
        as Map)['activateCarValue'];
        selectedCar = (ModalRoute.of(event.context!)?.settings.arguments
            as Map)['myCarModel'];
        selectedManufacturer=selectedCar.manufacturer;
        activateCar = (ModalRoute.of(event.context!)?.settings.arguments
            as Map)['activateCarValue'];
        addCarToPackage = (ModalRoute.of(event.context!)?.settings.arguments
            as Map)['addCarToPackageValue'];
        print('addCarToPackage');
        print(addCarToPackage);
        editCar = (ModalRoute.of(event.context!)?.settings.arguments
            as Map)['editCarValue'];
        isAddCorporateCar = (ModalRoute.of(event.context!)?.settings.arguments
            as Map)['isAddCorporateCarValue'];
        isAddNewCarToPackage = (ModalRoute.of(event.context!)
            ?.settings
            .arguments as Map)['isAddNewCarToPackageValue'];
            if(selectedManufacturer != null){
              await getModelsForManufacturer();
            }
        if ((ModalRoute.of(event.context!)?.settings.arguments
                as Map)['selectedAddedPackage'] !=
            null) {
          selectedAddedPackage = (ModalRoute.of(event.context!)
              ?.settings
              .arguments as Map)['selectedAddedPackage'];
        }
        List<String>? plateNumberChars = selectedCar.plateNumber?.split("-");
        if (plateNumberChars?.asMap()[0] != null) {
          if (plateNumberChars?.asMap()[0]?.contains(RegExp(r'[a-zA-Z]')) ??
              false) {
            plateNumberChars = plateNumberChars?.reversed.toList();
          }
        }
        if (plateNumberChars?.asMap()[0]?.isEmpty == true) {
          plateNumberChars = plateNumberChars?.reversed.toList();
        }

        if (plateNumberChars?.asMap()[0] != null &&
            (plateNumberChars?.asMap()[0]?.isNotEmpty ?? false)) {
          policyCarFirstCharController.text = plateNumberChars?[0] ?? '';
        }
        if (plateNumberChars?.asMap()[1] != null &&
            (plateNumberChars?.asMap()[1]?.isNotEmpty ?? false)) {
          policyCarSecondCharController.text = plateNumberChars?[1] ?? '';
        }
        if (plateNumberChars?.asMap()[2] != null &&
            (plateNumberChars?.asMap()[2]?.isNotEmpty ?? false)) {
          policyCarThirdCharController.text = plateNumberChars?[2] ?? '';
        }
        if (plateNumberChars?.asMap()[3] != null &&
            (plateNumberChars?.asMap()[3]?.isNotEmpty ?? false)) {
          policyCarPlateNumberController.text = plateNumberChars?[3] ?? '';
        }

        carYearController.text = selectedCar.year?.toString() ?? '';
        carModelController.text = selectedCar.carModel?.enName.toString() ?? '';
        carColorController.text = selectedCar.color?.toString() ?? '';
        //addCarToPackage = true;
        // selectedCarVinNumber=selectedCar.vinNumber??'';
        if ((ModalRoute.of(event.context!)?.settings.arguments
        as Map)['isAddCarServiceRequest'] !=
            null) {
          isAddCarServiceRequest = (ModalRoute.of(event.context!)
              ?.settings
              .arguments as Map)['isAddCarServiceRequest'];
        }
      }
    });
    on<GetMyCarsEvent>((event, emit) async {
      // TODO: implement event handler
      emit(GetMyCarsLoadingState());

      final result = await myCarsRepository.getMyCars();
      result.fold((l) {
        debugPrint(l);
        //   isGetMyCarsLoading = false;
        emit(GetMyCarsErrorState(error: l));
      }, (r) {
        allMyCars = r.myCars ?? [];
        //  isGetMyCarsLoading = false;
        //  allMyCars = r.myCars ?? [];
        //  printMeLog('myCars: ${allMyCars.length}');
        emit(GetMyCarsSuccessState());
      });
    });
  }

  Future selectImages() async {
    licensesBase64.clear();
    licensesImages.clear();
    licensesPathes.clear();
    licensesImages = await picker.pickMultiImage();

    if (licensesImages.length == 2) {
      for (var i = 0; i < licensesImages.length; i++) {
        Uint8List imagebytes = await licensesImages[i].readAsBytes();
        String _base64String = base64.encode(imagebytes);
        licensesBase64.add(_base64String);
        licensesPathes.add(licensesImages[i].path);
      }
      isTakeLicenseImages = true;
    } else {
      isTakeLicenseImages = false;
      HelpooInAppNotification.showErrorMessage(
          message: LocaleKeys.pleaseAddRequiredData.tr());
      debugPrint('No Image Selected');
    }
    emit(TakeLicenseImagesState());
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
        emit(CameraErrorState(error: 'Camera is not initialized'));
      } else {
        emit(CameraInitializedState());
      }
    });
  }

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

  void takePicture() async {
    emit(TakePictureLoadingState());

    XFile? img = await cameraController?.takePicture();

    licensesImages.add(img!); // TODO: take 2 images

    Uint8List imagebytes = await img.readAsBytes();
    String _base64String = base64.encode(imagebytes);
    licensesBase64.add(_base64String);
    licensesPathes.add(img.path);
    isTakeLicenseImages = true;

    emit(TakePictureSuccessState());
  }

  void updateCar() async {
    isUpdateCarLoading = true;
    emit(UpdateCarLoadingState());
    selectedCar.plateNumber = policyCarFirstCharController.text +
        "-" +
        policyCarSecondCharController.text +
        "-" +
        policyCarThirdCharController.text +
        "-" +
        policyCarPlateNumberController.text;
    AddCarDTO editCarDTO = AddCarDTO(
      ManufacturerId: selectedCar.manufacturer!.id.toString(),
      CarModelId: selectedCar.carModel!.id.toString(),
      year: selectedCar.year!.toString(),
      color: selectedCar.color!.toString(),
      vin_number: selectedCar.vinNumber.toString(),
      plateNumber: selectedCar.plateNumber,
      ClientId: await cacheHelper.get(Keys.generalID),
    );

    //  printWarning('=======>  ${editCarDTO.toJson(clientIdKey: "ClientId")}');
    final result = await myCarsRepository.updateCar(
        editCarDTO: editCarDTO, carId: selectedCar.id.toString());
    result.fold(
      (l) {
        debugPrint(l);
        isUpdateCarLoading = false;
        emit(UpdateCarErrorState(error: l));
      },
      (r) {
        isUpdateCarLoading = false;
        // subscribeCarToPackage();
        emit(UpdateCarSuccessState());
      },
    );
  }

  Future<void> getAllManufactures() async {
    isGetAllManufacturesLoading = true;
    emit(GetAllManufacturesLoadingState());
    final result = await myCarsRepository.getAllManufactures();

    result.fold(
      (failure) {
        debugPrint(failure);
        isGetAllManufacturesLoading = false;
        emit(GetAllManufacturesErrorState(error: failure));
      },
      (data) {
        manufactures = data.manufacturers ?? [];
        //printMeLog('manufactures List ${manufactures.length}');
        isGetAllManufacturesLoading = false;
        emit(GetAllManufacturesSuccessState());
      },
    );
  }

  Future<void> getModelsForManufacturer() async {
    isGetModelsForManufacturerLoading = true;
    emit(GetModelsForManufacturerLoadingState());
    final result = await myCarsRepository.getModelsForManufacturer(
      manufacturerId: selectedManufacturer!.id!,
    );

    result.fold(
      (failure) {
        debugPrint(failure);
        isGetModelsForManufacturerLoading = false;
        emit(GetModelsForManufacturerErrorState(error: failure));
      },
      (data) {
        models = data.models ?? [];
        isGetModelsForManufacturerLoading = false;
        emit(GetModelsForManufacturerSuccessState());
      },
    );
  }

  void addCar() async {
    isAddCarLoading = true;
    emit(AddCarLoadingState());
    String selectedPlateNumber = policyCarFirstCharController.text +
        "-" +
        policyCarSecondCharController.text +
        "-" +
        policyCarThirdCharController.text +
        "-" +
        policyCarPlateNumberController.text;
    AddCarDTO addCarDTO = AddCarDTO(
      ManufacturerId: selectedManufacturer!.id.toString(),
      CarModelId: selectedModel!.id.toString(),
      year: selectedCarYear ?? "",
      color: selectedCarColor ?? "",
      vin_number: selectedCarVinNumber ?? "",
      plateNumber: selectedPlateNumber == "---" ? "" : selectedPlateNumber,
      ClientId: await cacheHelper.get(Keys.generalID),
    );

    //  printWarning('=======>  ${addCarDTO.toJson(clientIdKey: "ClientId")}');
    final result = await myCarsRepository.addCar(addCarDTO: addCarDTO);
    result.fold(
      (l) {
        debugPrint(l);
        isAddCarLoading = false;
        emit(AddCarErrorState(error: l));
      },
      (r) {
        selectedCar = r;
        isAddCarLoading = false;
        emit(AddCarSuccessState(selectedCar: r));
      },
    );
  }

  void activateCarMothod() async {
    isActivateCarLoading = true;

    emit(ActivateCarLoadingState());
    AddCarDTO activateCarDTO = AddCarDTO(
      ManufacturerId: selectedCar.manufacturer!.id.toString(),
      CarModelId: selectedCar.carModel!.id.toString(),
      year: selectedCar.year!.toString(),
      color: selectedCar.color!.toString(),
      vin_number: selectedCar.vinNumber.toString(),
      plateNumber: selectedCar.plateNumber,
      ClientId: await cacheHelper.get(Keys.generalID),
      active: true,
      fl: licensesBase64[0],
      bl: licensesBase64[1],
      insuranceCompanyId: selectedCar.insuranceCompany!.id.toString(),
    );
    final result = await myCarsRepository.activateCar(
        activateCarDTO: activateCarDTO, carId: selectedCar.id.toString());

    result.fold(
      (l) {
        isActivateCarLoading = false;
        debugPrint(l);
        emit(ActivateCarErrorState(error: l));
      },
      (r) {
        isActivateCarLoading = false;
        emit(ActivateCarSuccessState());
      },
    );
  }

  bool get isAddCarValidWithPackage {
    return selectedManufacturer != null &&
        selectedModel != null &&
        selectedCarYear != null &&
        selectedCarColor != null && 
        selectedCarVinNumber!= null&&
        // selectedCarVinNumber!.length >=5 &&
        // selectedCarVinNumber!.length <=17&&
        // RegExp(r'^[a-zA-Z0-9]+$').hasMatch(selectedCarVinNumber!)&&
        selectedAddedPackage.packageId != null;
  }

  bool get isAddCarValidNoVin {
    return selectedManufacturer != null &&
        selectedModel != null &&
        selectedCarYear != null &&
        selectedCarColor != null;
  }
  bool get isAddCarValid {
    if(selectedCarVinNumber!= null){
      return isAddCarValidNoVin && 
      selectedCarVinNumber!.length >=5 &&
      selectedCarVinNumber!.length <=17&&
      RegExp(r'^[a-zA-Z0-9]+$').hasMatch(selectedCarVinNumber!);
    }else{
      return isAddCarValidNoVin;
    }
  }

  void addCorporateCar() async {
    isAddCarLoading = true;
    emit(AddCarLoadingState());
    String selectedPlateNumber = policyCarFirstCharController.text +
        "-" +
        policyCarSecondCharController.text +
        "-" +
        policyCarThirdCharController.text +
        "-" +
        policyCarPlateNumberController.text;
    AddCarDTO addCarDTO = AddCarDTO(
      ManufacturerId: selectedManufacturer!.id.toString(),
      CarModelId: selectedModel!.id.toString(),
      year: selectedCarYear!.toString(),
      color: selectedCarColor!.toString(),
      vin_number: selectedCarVinNumber.toString(),
      plateNumber: selectedPlateNumber,
      ClientId: "",
    );

    //   printWarning('=======>  ${addCarDTO.toJson(clientIdKey: "ClientId")}');
    final result = await myCarsRepository.addCorporateCar(
        name: customerName,
        phoneNumber: customerPhoneNumber,
        addCarDTO: addCarDTO);
    result.fold(
      (l) {
        debugPrint(l);
        isAddCarLoading = false;
        emit(AddCarErrorState(error: l));
      },
      (r) async {
        isAddCarLoading = false;
        selectedCarToRequest = r.car;
        corporateUser = r.user;
        print('corporateUser?.toJson()');
        await cacheHelper
            .put(Keys.currentCompanyId, corporateUser?.id)
            .then((value) {
          print(corporateUser?.toJson());
          emit(AddCarSuccessState(selectedCar: r.car));
        });
      },
    );
  }

  handleAddCarIntro(
      {required bool addCarToPackageValue,
      required bool isAddNewCarToPackageValue,
      required bool activateCarValue,
      required bool editCarValue,
      required bool isAddCorporateCarValue}) {
    addCarToPackage = addCarToPackageValue;
    isAddNewCarToPackage = isAddNewCarToPackageValue;
    activateCar = activateCarValue;
    isAddCorporateCar = isAddCorporateCarValue;
    editCar = editCarValue;
  }

  Future<void> getMyPackages() async {
    //isGetMyPackagesLoading = true;
    emit(GetMyPackagesFromMyCarsLoadingState());
    final result = await myCarsRepository.getMyPackages();

    result.fold(
      (failure) {
        debugPrint(failure);
        //   isGetMyPackagesLoading = false;
        emit(GetMyPackageFromMyCarsErrorState(error: failure));
      },
      (data) {
        myPackages = data.packages ?? [];
        // isGetMyPackagesLoading = false;
        //   printMeLog('myPackages ${myPackages.length}');
        emit(GetMyPackagesFromMyCarsSuccessState());
      },
    );
  }

  void subscribeCarToPackage() async {
    isSubscribeCarLoading = true;

    emit(SubscribeCarToPackageLoadingState());

    final result = await myCarsRepository.subscribeCarToPackage(
      carId: selectedCar.id.toString(),
      clientPackageId: selectedAddedPackage.id.toString(),
      clientId: await cacheHelper.get(Keys.generalID),
      packageId: selectedAddedPackage.packageId.toString(),
    );
    result.fold((l) {
      isSubscribeCarLoading = false;

      debugPrint(l);
      emit(SubscribeCarToPackageErrorState(error: l));
    }, (r) {
      isSubscribeCarLoading = false;
      final isInsurancePackage =
          selectedAddedPackage.insuranceCompanyId != null;
      emit(SubscribeCarToPackageSuccessState(
          isInsurancePackage: isInsurancePackage));
    });
  }
}
