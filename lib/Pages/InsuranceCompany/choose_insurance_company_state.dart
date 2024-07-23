part of 'choose_insurance_company_bloc.dart';

@immutable
abstract class ChooseInsuranceCompanyState {}

class ChooseInsuranceCompanyInitial extends ChooseInsuranceCompanyState {}
class GetInsurancepackageCarLoadingState extends ChooseInsuranceCompanyState {}

class GetInsurancepackageCarSuccessState extends ChooseInsuranceCompanyState {}

class GetInsurancepackageCarErrorState extends ChooseInsuranceCompanyState {
  final String error;

  GetInsurancepackageCarErrorState({
    required this.error,
  });
}

class GetAllInsuranceCompaniesLoading extends ChooseInsuranceCompanyState {}

class GetAllInsuranceCompaniesSuccess extends ChooseInsuranceCompanyState {}

class GetAllInsuranceCompaniesError extends ChooseInsuranceCompanyState {
  final String error;

  GetAllInsuranceCompaniesError({
    required this.error,
  });
}
