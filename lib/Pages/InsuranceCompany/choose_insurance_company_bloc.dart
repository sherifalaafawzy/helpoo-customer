import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/page_route_name.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/cars/my_cars.dart';
import '../../Models/companies/insurance.dart';
import '../../Services/navigation_service.dart';
import 'choose_insurance_company_repository.dart';

part 'choose_insurance_company_event.dart';

part 'choose_insurance_company_state.dart';

class ChooseInsuranceCompanyBloc
    extends Bloc<ChooseInsuranceCompanyEvent, ChooseInsuranceCompanyState> {
  final ChooseInsuranceCompanyRepository chooseInsuranceCompanyRepository =
      sl<ChooseInsuranceCompanyRepository>();
  List<InsuranceModel> insuranceCompanies = [];
  MyCarModel selectedCar = MyCarModel();
  TextEditingController vinNumberCtrl = TextEditingController();

  ChooseInsuranceCompanyBloc() : super(ChooseInsuranceCompanyInitial()) {
    on<ChooseInsuranceCompanyEvent>((event, emit) {});
    on<GetInsurancepackageCarEvent>((event, emit) async {
      emit(GetInsurancepackageCarLoadingState());
      final result = await chooseInsuranceCompanyRepository.insurancePackagecar(
          VINNo: event.VINNo!,
          insuranceCompanyId: selectedCar.insuranceCompany!.id.toString());

      result.fold(
        (failure) {
          //  debugPrint(failure);
          //  isInsurancePackageLoading = false;
          emit(GetInsurancepackageCarErrorState(error: failure));
        },
        (data) {
          selectedCar = data;
          // appBloc.activateCar = true;
           /// navigatorKey.currentContext!.pushNamedAndRemoveUntil(Routes.addCarScreen);
          NavigationService.navigatorKey.currentContext!.pushNamed(PageRouteName.addCarScreen, arguments: {
            "myCarModel": selectedCar,
            "activateCarValue": true,
            "addCarToPackageValue": false,
            "isAddCorporateCarValue": false,
            "isAddNewCarToPackageValue": false,
            "editCarValue": false
          });
          // isInsurancePackageLoading = false;
          emit(GetInsurancepackageCarSuccessState());
        },
      );
    });
    on<GetAllInsuranceCompaniesEvent>((event, emit) async {
      if(ModalRoute.of(event.context!)!.settings.arguments is MyCarModel){
        selectedCar=ModalRoute.of(event.context!)!.settings.arguments as MyCarModel;
      }

      if (selectedCar.vinNumber != null || selectedCar.vinNumber != "") {
        vinNumberCtrl.text = selectedCar.vinNumber ?? "";
      }

      emit(GetAllInsuranceCompaniesLoading());

      final result =
          await chooseInsuranceCompanyRepository.getAllInsuranceCompanies();
      result.fold((l) {
        //  debugPrint(l);
        //   isGetInsuranceCompaniesLoading = false;

        emit(GetAllInsuranceCompaniesError(error: l.toString()));
      }, (r) {
        insuranceCompanies = r.insuranceCompanies!;
        // isGetInsuranceCompaniesLoading = false;

        emit(GetAllInsuranceCompaniesSuccess());
      });
    });
  }
}
// void insurancePackageCar({required String VINNo}) async {
//     isInsurancePackageLoading = false;
//

//   }
