import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';
import 'package:helpooappclient/Pages/InsuranceCompany/choose_insurance_company_bloc.dart';
import 'package:searchfield/searchfield.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../main.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Models/companies/insurance.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/load_svg.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/primary_form_field.dart';
import '../../Widgets/primary_loading.dart';
import '../../Widgets/scaffold_bk.dart';
import '../../Widgets/spacing.dart';
import '../FNOL/fnol_bloc.dart';
import '../FNOL/pages/choose_accident_type.dart';
import '../MyCars/my_cars_bloc.dart';

class ChooseInsuranceCompany extends StatefulWidget {
  const ChooseInsuranceCompany({Key? key}) : super(key: key);

  @override
  State<ChooseInsuranceCompany> createState() => _ChooseInsuranceCompanyState();
}

class _ChooseInsuranceCompanyState extends State<ChooseInsuranceCompany> {
  ChooseInsuranceCompanyBloc? chooseInsuranceCompanyBloc;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // appBloc.getAllInsuranceCompanies();
    super.initState();
    chooseInsuranceCompanyBloc = context.read<ChooseInsuranceCompanyBloc>();
    chooseInsuranceCompanyBloc
        ?.add(GetAllInsuranceCompaniesEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      appBarTitle: LocaleKeys.chooseInsuranceCompany.tr(),
      onBackTab: () {
        // appBloc.selectedCar.insuranceCompany = null;
        context.pop;
      },
      body:
          BlocConsumer<ChooseInsuranceCompanyBloc, ChooseInsuranceCompanyState>(
        listener: (context, state) {
          if (state is GetInsurancepackageCarErrorState) {
            HelpooInAppNotification.showErrorMessage(message: state.error);
          }
        },
        builder: (context, state) {
          return state is GetInsurancepackageCarLoadingState
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.pleaseAddInsuranceCompany.tr(),
                          style: TextStyles.bold20,
                        ),
                        verticalSpace5,

                        verticalSpace10,

                        Text(
                          LocaleKeys.insuranceCompany.tr(),
                          style: TextStyles.bold14,
                        ),
                        verticalSpace8,
                        AnimatedContainer(
                          duration: duration500,
                          // height: 50,
                          decoration: BoxDecoration(
                            borderRadius: 10.rSp.br,
                            color: ColorsManager.white,
                            boxShadow: primaryShadow,
                          ),
                          child: PrimaryLoading(
                            isLoading: state is GetAllInsuranceCompaniesLoading,
                            child: Center(
                              child: Stack(
                                children: [
                                  SearchField<InsuranceModel>(
                                    controller: _controller,
                                    validator: (text) {
                                      bool isValid = false;
                                      chooseInsuranceCompanyBloc!.insuranceCompanies.forEach((x) {
                                        if (x.arName == text) {
                                          isValid = true;
                                        }
                                      });
                                      if (!isValid) {
                                        return LocaleKeys.pleaseAddInsuranceCompany.tr();
                                      }
                                    },
                                    onSuggestionTap: (p0) {
                                      chooseInsuranceCompanyBloc?.selectedCar.insuranceCompany = p0.item;
                                    },
                                    hint: LocaleKeys.insuranceCompany.tr(),
                                    itemHeight: 50,
                                    suggestions: chooseInsuranceCompanyBloc!.insuranceCompanies.map(
                                          (e) =>
                                          SearchFieldListItem<InsuranceModel>(
                                            e.arName!,
                                            item: e,
                                            // Use child to show Custom Widgets in the suggestions
                                            // defaults to Text widget
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(e.arName!),
                                            ),
                                          ),
                                    )
                                        .toList(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => _controller.clear(),
                                        icon: Icon(Icons.clear, size: 17,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        verticalSpace40,

                        Text(
                          LocaleKeys.vinNumber.tr(),
                          style: TextStyles.bold14,
                        ),
                        verticalSpace8,
                        PrimaryFormField(
                          validationError: '',
                          controller:
                          chooseInsuranceCompanyBloc?.vinNumberCtrl,
                          label: '',
                          enabled: chooseInsuranceCompanyBloc
                              ?.selectedCar.vinNumber ==
                              null ||
                              chooseInsuranceCompanyBloc
                                  ?.selectedCar.vinNumber ==
                                  ""
                              ? true
                              : false,
                        ),

                        verticalSpace70,
                        PrimaryButton(
                          text: LocaleKeys.confirm.tr(),
                          onPressed: () {
                            bool isValid = _formKey.currentState!.validate();
                            if (isValid == false) {
                              return;
                            }

                            if (chooseInsuranceCompanyBloc?.selectedCar.insuranceCompany != null) {
                              if ((chooseInsuranceCompanyBloc?.selectedCar.vinNumber != null || chooseInsuranceCompanyBloc?.selectedCar.vinNumber != "")
                                  && chooseInsuranceCompanyBloc?.vinNumberCtrl.text != "") {
                                //    if (chooseInsuranceCompanyBloc?.activateCarFromPackage) {
                                if (chooseInsuranceCompanyBloc!.vinNumberCtrl.text.length < 5
                                    || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(chooseInsuranceCompanyBloc!.vinNumberCtrl.text)) {
                                  HelpooInAppNotification.showErrorMessage(message: LocaleKeys.pleaseAddValidVin.tr());
                                } else {
                                  if(ModalRoute.of(context)?.settings.arguments is MyCarModel) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            return MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) => FnolBloc(),
                                                ),
                                                BlocProvider(
                                                  create: (context) => MyCarsBloc(),
                                                ),
                                              ],
                                              child: const ChooseAccidentType(),
                                            );
                                          },
                                          settings: RouteSettings(
                                              arguments: chooseInsuranceCompanyBloc
                                                  ?.selectedCar)),
                                    );
                                  }else {
                                    chooseInsuranceCompanyBloc?.add(GetInsurancepackageCarEvent(
                                            VINNo: chooseInsuranceCompanyBloc
                                                ?.vinNumberCtrl.text
                                                .trim()
                                                .substring(chooseInsuranceCompanyBloc!
                                                .vinNumberCtrl.text.length -
                                                5)));
                                  }
                                }
                              } else {
                                HelpooInAppNotification.showErrorMessage(
                                    message: LocaleKeys.addVinNumberPlease.tr());
                              }
                            } else {
                              HelpooInAppNotification.showErrorMessage(
                                  message:
                                      LocaleKeys.pleaseAddInsuranceCompany.tr());
                            }
                          },
                        ),
                        verticalSpace40,
                      ],
                    ),
                ),
              );
        },
      ),
    );
  }
}
