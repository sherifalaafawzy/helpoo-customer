import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/keys.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../packages_screen_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
class InfoDialog extends StatefulWidget {
   bool accepted;
 final Function buttonAction;
 final Function(bool s) onChanged;
 final Package package;
 final PackagesScreenBloc packagesScreenBloc;
  InfoDialog({required this.accepted ,required this. buttonAction,required this. onChanged,required this.package,required this.packagesScreenBloc});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
     Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
  children: <Widget>[
    Expanded(
      child: Padding(
        padding:  EdgeInsets.only(left: 50.rh),
        child:                   LoadSvg(
                                    width: 50.rh,
                                    image: AssetsImages.logo,
                                    height: 50.rh,
                                    fit: BoxFit.fitHeight,
                                  )
      ),
    ),
    IconButton(padding: EdgeInsets.all(0),onPressed: () => context.pop, icon: Icon(Icons.clear))
  ],
)
              // Row(mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //       LoadSvg(
              //                       width: double.infinity,
              //                       image: AssetsImages.logo,
              //                       height: 50.rh,
              //                       fit: BoxFit.fill,
              //                     ),
              //     Align(alignment: Alignment.centerRight,child: IconButton(onPressed: () => context.pop, icon: Icon(Icons.clear))),
                   
              //   ],
              // ),
            
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
   
                Row(
                  children: [Icon(Icons.info),SizedBox(width: 5,),
                    Text(LocaleKeys.packageInfo.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyles.semiBold16,
                    ),
                  ],
                ),
                Container(width: MediaQuery.of(context).size.width-10,height: widget.package.packageBenefits!.length*40,child: ListView.builder(itemBuilder:(context, index){
                   List<PackageBenefit> benefits = widget.package.packageBenefits!..toList();
                return  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Icon(
                              Icons.circle,
                              color: ColorsManager.black,
                              size: 12,
                            ),
                            horizontalSpace8,
                      Flexible(child: Text( context.locale.languageCode == 'ar'? benefits[index].arName! :
                       benefits[index].enName!)),
                    ],
                  ),
                );
                }, itemCount: widget.package.packageBenefits!.length))
              ],
            ),
          ),
          actions: <Widget>[          
                Column(
                  children: [
                    ShakeWidget(key: key,accepted: widget.accepted,
                      child: Row(
                        children: [
                          Checkbox(activeColor: ColorsManager.mainColor,value: widget.accepted, onChanged: (newValue) {
                            if(widget.package.packageBenefits!.isNotEmpty){
                            setState(() {
                                widget.accepted = newValue!;
                              });
                            }
                            
                            })
                          ,Flexible(child: Row(
                          children: [
                            Text(LocaleKeys.acceptSubscriptionInfo.tr()),
                          ],
                        )),
                      
                        ],
                      ),
                    ),SizedBox(height: 15),
                    SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: ()async{
                          if(widget.accepted){
                              if(widget.package.packageBenefits!.isNotEmpty){
  if (widget.packagesScreenBloc?.selectedPackage == -1) {
                                HelpooInAppNotification.showErrorMessage(
                                    message:
                                        LocaleKeys.pleaseChoosePackage.tr());
                              } else {
                                if (widget.packagesScreenBloc?.isPromoPackageActive ??
                                    false) {
                                  if (widget.packagesScreenBloc!
                                      .promoCodeController.text
                                      .toLowerCase()
                                      .startsWith('sh')) {
                                    await widget.packagesScreenBloc
                                        ?.usePromoOnPackageShell();
                                  } else {
                                    await widget.packagesScreenBloc
                                        ?.usePromoOnPackage();
                                  }

                                  // after the response => look at the listener
                                } else {
                                  widget.packagesScreenBloc?.add(
                                      GetIframePackagesEvent(
                                          amount: widget.packagesScreenBloc
                                                  ?.helpooPackages[
                                                      widget.packagesScreenBloc!
                                                          .selectedPackage]
                                                  .fees
                                                  ?.toDouble() ??
                                              0,
                                          requestId: widget.packagesScreenBloc
                                              ?.helpooPackages[
                                                  widget.packagesScreenBloc!
                                                      .selectedPackage]
                                              .id,
                                          selectedPackage: widget.packagesScreenBloc!
                                              .helpooPackages[
                                                  widget.packagesScreenBloc!
                                                      .selectedPackage]
                                              .id));
                                  /* await packagesScreenBloc?.getIFrameUrl(
                                    isServiceReq: false,
                                    amount: packagesScreenBloc?.helpooPackages[packagesScreenBloc!.selectedPackage].fees?.toDouble() ?? 0,
                                  );*/
                                  // appBloc.isFromPackageOnline = true;
                                  // appBloc.isFromServiceRequestOnline = false;
                                }
                              }
                                }
                          }else{
                            setState(() {
                              key = UniqueKey();
                            });

                          }

                      },
                      text: LocaleKeys.next.tr(),
                    ),
                                  ),
                  ],
                )
            

          ],
        );
  }
}

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget? child;
  final Curve curve;
  bool? accepted;

   ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    this.child,
    this.accepted
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}