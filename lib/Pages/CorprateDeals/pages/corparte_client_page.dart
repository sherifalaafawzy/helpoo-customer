import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/di/injection.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/CorprateDeals/cubit/corporate_client_cubit.dart';
import 'package:helpooappclient/Widgets/primary_form_field.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../generated/locale_keys.g.dart';

class CorporateClientPage extends StatefulWidget {
  const CorporateClientPage({super.key, required this.corporateName});

  final String corporateName;

  @override
  State<CorporateClientPage> createState() => _CorporateClientPageState();
}

class _CorporateClientPageState extends State<CorporateClientPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CorporateClientCubit>()..getAuthStatus(),
        ),
        BlocProvider(
          create: (context) => PhoneNumberBloc(),
        )
      ],
      child: Builder(builder: (context) {
        final phoneNumberBloc = context.read<PhoneNumberBloc>();
        return BlocListener<PhoneNumberBloc, PhoneNumberState>(
          listener: (context, state) {
            if (state is PhoneNumberSendOtpSuccessState) {
              phoneNumberBloc.add(NavigateToVerifyOTPEvent(
                  context: context,
                  otpModel: state.otpModel,
                  phoneNumber: phoneNumberBloc.phoneController.text,
                  fullName: _fullNameController.text,
                  corporateName: widget.corporateName,
                  fromCorporate: true));
            }
          },
          child: ScaffoldWithBackground(
            withBack: false,
            body: _buildBody(phoneNumberBloc),
          ),
        );
      }),
    );
  }

  Widget _buildBody(PhoneNumberBloc phoneNumberBloc) {
    return BlocBuilder<CorporateClientCubit, CorporateClientState>(
        builder: (context, state) => switch (state.status) {
              CorporateClientStatus.loading => CircularProgressIndicator(),
              CorporateClientStatus.auth ||
              CorporateClientStatus.unAuth =>
                _buildContent(phoneNumberBloc, state),
            });
  }

  Padding _buildContent(
      PhoneNumberBloc phoneNumberBloc, CorporateClientState state) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.rh,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.rw),
            child: LoadSvg(
              width: double.infinity,
              image: AssetsImages.logo,
              height: 106.rh,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 30.rh,
          ),
          Text('${LocaleKeys.helloClient.tr()} ${widget.corporateName}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith()),
          SizedBox(
            height: 30.rh,
          ),
          _buildForm(phoneNumberBloc, state),
          SizedBox(
            height: 30.rh,
          ),
          _buildConfirmButton(phoneNumberBloc)
        ],
      ),
    );
  }

  Widget _buildConfirmButton(PhoneNumberBloc phoneNumberBloc) {
    phoneNumberBloc.fullName = _fullNameController.text;
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
      builder: (context, state) => PrimaryButton(
        isLoading: state is PhoneNumberSendOtpLoadingState,
        text: LocaleKeys.confirm.tr(),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // appBloc.checkIfUserExist();
            phoneNumberBloc.add(PhoneNumberConfirmButtonEvent(
                mobileNumber: phoneNumberBloc.phoneController.text));
          }
        },
      ),
    );
  }

  Widget _buildForm(
      PhoneNumberBloc phoneNumberBloc, CorporateClientState state) {
    final enabled = state.status != CorporateClientStatus.auth;
    if (!enabled) {
      _fullNameController.text = state.userName ?? '';
      phoneNumberBloc.fullName = state.userName;
      phoneNumberBloc.phoneController.text = state.phoneNumber!;
    }
    return Form(
        key: _formKey,
        child: Column(
          children: [
            PrimaryFormField(
              enabled: enabled,
              validationError: LocaleKeys.nameRequired.tr(),
              label: LocaleKeys.fullName.tr(),
              controller: _fullNameController,
            ),
            SizedBox(
              height: 16,
            ),
            PrimaryFormField(
              enabled: enabled,
              validationError: LocaleKeys.phoneNumberIsRequired.tr(),
              controller: phoneNumberBloc.phoneController,
              /* keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],*/
              label: LocaleKeys.phoneNumber.tr(),
              suffixIcon: const Icon(Icons.phone),
            ),
          ],
        ));
  }
}
