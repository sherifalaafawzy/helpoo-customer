part of 'choose_insurance_company_bloc.dart';

@immutable
abstract class ChooseInsuranceCompanyEvent {}
class GetAllInsuranceCompaniesEvent extends ChooseInsuranceCompanyEvent{
  final BuildContext? context;
  GetAllInsuranceCompaniesEvent({required this.context});
}
class GetInsurancepackageCarEvent extends ChooseInsuranceCompanyEvent{
  final String? VINNo;
  GetInsurancepackageCarEvent({required this.VINNo});

}