import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Models/companies/corporate_company_model.dart';
import 'package:helpooappclient/Pages/Packages/packages_screen_repository.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/packages/package_model.dart';
import '../../Models/packages/promo_model.dart';
import '../../Models/packages/use_promo_on_package_res.dart';
import '../../Models/promoCode.dart';
import '../../Services/cache_helper.dart';

part 'packages_screen_event.dart';

part 'packages_screen_state.dart';

class PackagesScreenBloc
    extends Bloc<PackagesScreenEvent, PackagesScreenState> {
  TextEditingController promoCodeController = TextEditingController();
  List<Package> helpooPackages = [];
  List<Package> myPackages = [];
  List<Promo> fetchedPromos = [];
  int selectedPackage = -1;
  Package selectedPackageToDisplayDetails = Package();
  bool? userLoginStatus = false;
  bool isPromoPackageActive = false;
  bool isValidatePromoPackageLoading = false;
  bool isUsePromoOnPackageLoading = false;
  UsePromoOnPackageRes? usePromoOnPackageRes;
  String? amountPercentageShell;
  String? logoShell =
      "https://apidev.helpooapp.net/public/users/companies/shell.png";
  List<({int? discountPercent, int? discountFees})>? discount;

  final PackagesScreenRepository packagesScreenRepository =
      sl<PackagesScreenRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();

  PackagesScreenBloc() : super(PackagesScreenInitial()) {
    on<UseByCorporateEvent>(_userByCorporate);
    on<GetPackagesByCorporate>(_getPackagesByCorporate);

    on<PackagesScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetIframePackagesEvent>((event, emit) async {
      // TODO: implement event handler
      emit(GetIFrameUrlLoadingPackagesState());

      ///  print('lsslsls');
      print(event.selectedPackage);
      final result = await packagesScreenRepository.getPaymentIframe(
        serviceRequestId: null,
        packageId: event.selectedPackage,
        amount: event.amount!,
      );

      result.fold(
        (failure) {
          debugPrint('-----failure------');
          debugPrint(failure.toString());
          //  isGetIFrameUrlLoading = false;
          emit(GetIFrameUrlErrorPackagesState(error: failure));
        },
        (data) {
          // printMeLog('-----data--- ${data.toJson()}');
          //  IFrameUrl = data.frameUrl ?? '';
          debugPrint('-----IFrameUrl------');
          debugPrint(data.frameUrl ?? '');
          //   isGetIFrameUrlLoading = false;
          emit(GetIFrameUrlSuccessPackagesState(
              url: data.frameUrl ?? '', fromCorporate: event.fromCorporate));
        },
      );
    });
    on<ChangePromoCodeVisibilityEvent>((event, emit) async {
      isPromoPackageActive = false;
      promoCodeController.clear();
      emit(PromoCodeVisibilityState());
    });
    on<GetPromoEvent>((event, emit) async {
      emit(ValidatePromoPackageLoading());

      final result = await packagesScreenRepository.getPromoState(
        promoValue: promoCodeController.text,
      );

      result.fold(
        (failure) {
          debugPrint(failure);
          isPromoPackageActive = false;

          emit(ValidatePromoPackageError(error: failure));
        },
        (data) {
          fetchedPromos = data.promos ?? [];

          if (data.promos?.isNotEmpty ?? false) {
            isPromoPackageActive = data.promos?.isNotEmpty ?? false;
            print(data.promos?.first.corporateCompany?.photo);
            promoCodeController.text =
                fetchedPromos.first.percentage?.toString() ?? '';
          }
          emit(ValidatePromoPackageSuccess());
        },
      );
    });
    on<GetMyPackagesEvent>((event, emit) async {
      if (await cacheHelper
          .get(Keys.generalID)
          .then((value) => value != null)) {
        userLoginStatus = true;
      }
      emit(GetMyPackagesLoadingState());
      final result = await packagesScreenRepository.getMyPackages();

      result.fold(
        (failure) {
          debugPrint(failure);
          // isGetMyPackagesLoading = false;
          emit(GetMyPackagesErrorState(error: failure));
        },
        (data) {
          myPackages = data.packages ?? [];
          //   isGetMyPackagesLoading = false;
          // printMeLog('myPackages ${myPackages.length}');
          emit(GetMyPackagesSuccessState());
        },
      );
    });
    on<GetAllPackagesEvent>((event, emit) async {
      emit(GetAllPackagesLoadingState());
      final result = await packagesScreenRepository.getAllPackages(
          //isPublic: false
          );

      result.fold(
        (failure) {
          debugPrint(failure);
          //  isGetAllPackagesLoading = false;
          emit(GetAllPackagesErrorState(error: failure));
        },
        (data) {
          helpooPackages = data.packages ?? [];
          // isGetAllPackagesLoading = false;

          emit(GetAllPackagesSuccessState());
        },
      );
    });
  }

  Future<void> usePromoOnPackage() async {
    isUsePromoOnPackageLoading = true;
    final resultProfile = await packagesScreenRepository.getProfile();

    resultProfile.fold(
      (failure) {
        debugPrint(failure);
        //isGetProfileLoading = false;
      },
      (data) async {
        emit(UsePromoOnPackageLoadingState());
        final resultUsePromo = await packagesScreenRepository.usePromoOnPackage(
          packageId: helpooPackages[selectedPackage].id!,
          promoId: fetchedPromos[0].id!,
          userId: data.user!.id!,
          // userId: loginModel!.user!.userId!,
        );
        resultUsePromo.fold(
          (failure) {
            debugPrint(failure);
            isUsePromoOnPackageLoading = false;
            emit(UsePromoOnPackageErrorState(error: failure));
          },
          (data) {
            isUsePromoOnPackageLoading = false;
            usePromoOnPackageRes = data;

            print(
                'usePromoOnPackageRes ${usePromoOnPackageRes!.promo?.fees ?? 0.00}');
            emit(UsePromoOnPackageSuccessState(
                amount: usePromoOnPackageRes!.promo?.fees?.toDouble() ?? 0.00));
          },
        );
      },
    );
  }

  Future<void> usePromoOnPackageShell() async {
    isUsePromoOnPackageLoading = true;
    final resultProfile = await packagesScreenRepository.getProfile();

    resultProfile.fold(
      (failure) {
        debugPrint(failure);
        //isGetProfileLoading = false;
      },
      (data) async {
        emit(UsePromoOnPackageLoadingState());
        final resultUsePromo =
            await packagesScreenRepository.usePromoOnPackageShell(
          amount: helpooPackages[selectedPackage].fees!.toInt(),
          packageId: helpooPackages[selectedPackage].id!,
          promoId: promoCodeController.text,
          userId: data.user!.id!,
          // userId: loginModel!.user!.userId!,
        );
        resultUsePromo.fold(
          (failure) {
            debugPrint(failure);
            isUsePromoOnPackageLoading = false;
            emit(UsePromoOnPackageErrorState(error: failure));
          },
          (data) {
            isUsePromoOnPackageLoading = false;
            usePromoOnPackageRes = data;
            print(data);
            amountPercentageShell = (100 -
                    ((usePromoOnPackageRes!.amountShell! /
                            helpooPackages[selectedPackage].fees!.toInt()) *
                        100))
                .toString();
            print(
                'usePromoOnPackageRes ${usePromoOnPackageRes!.amountShell ?? 0.00}');
            //getIframe with amount.
            emit(UsePromoOnPackageSuccessState(
                amount: usePromoOnPackageRes!.amountShell!.toDouble(),
                percentageShell: amountPercentageShell,
                shellLogo: logoShell));
          },
        );
      },
    );
  }

  CorporateCompany? corporateCompany;
  FutureOr<void> _getPackagesByCorporate(
      GetPackagesByCorporate event, Emitter<PackagesScreenState> emit) async {
    emit(GetAllPackagesLoadingState());
    final result = await packagesScreenRepository.getPackagesByCorporate(
        corporateName: event.corporateName);

    result.fold(
      (failure) {
        debugPrint(failure);
        //  isGetAllPackagesLoading = false;
        emit(GetAllPackagesErrorState(error: failure));
      },
      (data) {
        helpooPackages = data.deals.map((e) => e.package).toList();
        // isGetAllPackagesLoading = false;
        corporateCompany = data.corporateCompany;
        discount = data.deals
            .map((e) => (
                  discountFees: e.discountFees,
                  discountPercent: e.discountPercent
                ))
            .toList();
        ;
        emit(GetAllPackagesSuccessState());
      },
    );
  }

  FutureOr<void> _userByCorporate(
      UseByCorporateEvent event, Emitter<PackagesScreenState> emit) async {
    final resultProfile = await packagesScreenRepository.getProfile();
    resultProfile.fold((l) => null, (r) async {
      emit(UsePromoOnPackageLoadingState());
      final response = await packagesScreenRepository.useByCorporate(
          pkgId: event.packageId,
          userId: r.user!.id!,
          dealId: event.dealId!,
          corporateName: event.corporateName);

      response.fold((l) {
        emit(UsePromoOnPackageErrorState(error: l));
      }, (r) {
        add(GetIframePackagesEvent(
            fromCorporate: true,
            requestId: event.packageId,
            amount: r.promo!.fees!.toDouble(),
            selectedPackage: event.packageId));
      });
    });
  }
}
