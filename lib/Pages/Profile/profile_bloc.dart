import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:meta/meta.dart';
import '../../../../Configurations/di/injection.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Models/auth/login_model.dart';
import '../../Models/promoCode.dart';
import '../../Services/cache_helper.dart';
import '../../Services/navigation_service.dart';
import '../Main/main_bloc.dart';
import 'profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository = sl<ProfileRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  TextEditingController nameController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  ProfileBloc? profileBloc;
  bool isPromoCodeVisable = false;
  PromoCode? normalPromoCodeRes;

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      // TODO: implement event handler
    });
    on<CheckPromoCode>((event, emit) async {
      // TODO: implement event handler
      emit(CheckPromoIfPackageOrNormalLoading());

      final result = await profileRepository.checkPromoIsPackageOrNormal(
        promoValue: event.promoCode!,
      );

      result.fold(
        (error) {
          emit(CheckPromoIfPackageOrNormalError(error: error));
        },
        (data) {
          emit(CheckPromoIfPackageOrNormalSuccess());
        },
      );
    });

    on<GetProfileEvent>((event, emit) async {
      // TODO: implement event handler
      emit(GetProfileLoadingState());
      final result = await profileRepository.getProfile();

      result.fold(
        (failure) {
          debugPrint(failure);
          //isGetProfileLoading = false;
          emit(GetProfileErrorState(error: failure));
        },
        (data) async {
          //  profileModel = data;
          // isGetProfileLoading = false;
          nameController.text = data.user!.name!;
          phoneNumberController.text = data.user!.phoneNumber!;
          emailController.text = data.user!.email!;
          // printMe(profileModel!.user!.promo.toString());
          if (data.user?.promo != null) {
            normalPromoCodeRes = data.user!.promo;
            isPromoCodeVisable = true;
          }
          emit(
            GetProfileSuccessState(
                profileModel: data,
                normalPromoCodeRes: data.user?.promo,
                value: data.user?.promo != null ? true : false),
          );
        },
      );
    });
    on<UpdateProfileEvent>((event, emit) async {
      // TODO: implement event handler
      emit(UpdateProfileLoadingState());
      final result = await profileRepository.updateProfile(
          email: emailController.text.isEmpty ? null:emailController.text, name: nameController.text);
      result.fold(
        (failure) {
          debugPrint(failure);
          emit(UpdateProfileErrorState(error: failure));
        },
        (data) async {
          emit(
            UpdateProfileSuccessState(),
          );

          profileBloc?.add(GetProfileEvent());
          await cacheHelper
              .put(Keys.userName, nameController.text)
              .then((value) {});
                          NavigationService.navigatorKey.currentContext!.pushReplacementNamed(PageRouteName.mainScreen);
          //   appBloc.isHomeScreenRoute = true;
          //   navigatorKey.currentContext!.pushNamed(Routes.bottomNavBarScreen);
        },
      );
    });
    on<UsePromoCode>((event, emit) async {
      // TODO: implement event handler
      emit(UseNormalPromoLoadingState());
      final result = await profileRepository.useNormalPromo(
        value: event.value!,
      );

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(UseNormalPromoErrorState(error: failure));
          profileBloc?.add(GetProfileEvent());
        },
        (data) {
          /*    isUseNormalPromoLoading = false;
          isPromoCodeVisable = true;
*/
          //  normalPromoCodeRes = data;
          //printMeLog('----------->>> ${normalPromoCodeRes!.expiryDate.toString()}');

          emit(UseNormalPromoSuccessState());
          profileBloc?.add(GetProfileEvent());
        },
      );
    });
  }

  changePromoCodeVisibilty(value) {
    isPromoCodeVisable = value;
    emit(ChangePromoCodeVisibility(value: value));
  }
}
