import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';

import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../packages_screen_bloc.dart';

class PackageDetails extends StatefulWidget {
  const PackageDetails({
    Key? key,required this.package
  }) : super(key: key);
 final Package? package;
  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  PackagesScreenBloc? packagesScreenBloc;

  @override
  void initState() {
    super.initState();
    packagesScreenBloc = context.read<PackagesScreenBloc>();
  }
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      horizontalPadding: 0,
      appBarTitle:
      LocaleKeys.packageDetails.tr(),

      body: BlocConsumer<PackagesScreenBloc, PackagesScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
//          Package package = packagesScreenBloc!.selectedPackageToDisplayDetails;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.package?.name??'',
                      style: TextStyles.bold18,
                    ),
                  ),
                ),
                verticalSpace8,
                Column(
                  children: [
                    if(widget.package?.packageBenefits!=null)
                    ... widget.package!.packageBenefits!.map(
                      (benefit) => Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                            colors: [
                              ColorsManager.mainColor.withOpacity(0.1),
                              ColorsManager.mainColor.withOpacity(0.15),
                              ColorsManager.mainColor.withOpacity(0.2),
                              ColorsManager.mainColor.withOpacity(0.25),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: ColorsManager.mainColor,
                              size: 14,
                            ),
                            horizontalSpace8,
                            Flexible(
                              child: Text(
                                benefit.name,
                                style: TextStyles.bold14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).toList(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        horizontalPadding: 22,
        onPressed: () {
         Navigator.of(context).pop();
        },
        text:
      LocaleKeys.doneOnBoarding.tr(),

      ),
    );
  }
}
