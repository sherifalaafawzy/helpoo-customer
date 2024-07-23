import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Widgets/load_svg.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/scaffold_bk.dart';
import '../../Widgets/spacing.dart';
import 'choose_language_bloc.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  ChooseLanguageBloc? _languageBloc;

  @override
  void initState() {
    super.initState();
    _languageBloc = context.read<ChooseLanguageBloc>();
    //   _signUpBloc?.add(InitialEvent());
    _languageBloc?.chooseLanguageBloc = _languageBloc;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      withBack: false,
      body: BlocListener<ChooseLanguageBloc, ChooseLanguageState>(
        listener: (context, state) {
          // TODO: implement listener
          if(state is LanguageChangedState){
            _languageBloc?.add(NavigateToOnBoardingEvent(context: context));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.rw),
              child: LoadSvg(
                width: double.infinity,
                image: AssetsImages.logo,
                height: 106.rh,
                fit: BoxFit.fill,
              ),
            ),
            verticalSpace140,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.rw),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'عربي',
                    onPressed: () {
                      _languageBloc?.add(ChangeLanguageEvent(
                          language: 'arabic', context: context));
                    },
                  ),
                  verticalSpace16,
                  PrimaryButton(
                    text: 'English',
                    onPressed: () {
                      _languageBloc?.add(ChangeLanguageEvent(
                          language: 'english', context: context));
                    },
                  ),
                  verticalSpace20,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
