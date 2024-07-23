import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Models/packages/package_model.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';
import 'package:intl/intl.dart';

import '../../../Configurations/Constants/api_endpoints.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Models/cars/my_cars.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/colors.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../MyCars/widgets/my_car_item.dart';
import 'add_car_to_package_button.dart';
import 'package_details_widget.dart';

class PackageDetailsPage extends StatelessWidget {
  final Package package;
   PackageDetailsPage({super.key,required this.package});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body: Container(color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           LoadSvg(
                                    width: 45.rh,
                                    image: AssetsImages.logo,
                                    height: 45.rh,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(LocaleKeys.packageDetails.tr(),style: TextStyle(fontSize: 11,color: Color(0xff0B141F),fontWeight: FontWeight.w700),),
                                  ),
                   Container(decoration: BoxDecoration(border: Border.all(color: Color(0xff39B54A)),borderRadius: BorderRadius.circular(50)),child: Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3),decoration: BoxDecoration(border: Border.all(color: Colors.white),gradient: LinearGradient(colors: [Color(0xff39B54A),Color(0xff00A651)],begin: Alignment.topCenter,end: Alignment.bottomCenter),borderRadius: BorderRadius.circular(50)),child: Text(context.locale.languageCode == 'ar' ? '${package.arName}' : "${package.enName}",style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w700),),)),
SizedBox(height: 5),
ExpansionTile(trailing: SizedBox.shrink(),leading: SizedBox.shrink(),shape: Border(),childrenPadding: EdgeInsets.fromLTRB(30, 0, 0, 0) ,tilePadding:EdgeInsets.all(0),collapsedIconColor: Colors.transparent,
  title: PackageDetailsWidget(
    firstWidget: Image.asset("assets/images/calendar.png",width: 34,height: 34),
    secondWidget: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.activeUntil.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.endDate!)),style:TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                  Text(LocaleKeys.activatedOn.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.createdAt!)),style: TextStyle(fontSize: 7,color: Color(0xffA3A3A3),fontWeight: FontWeight.w700),)
                ],
              ),
    thirdWidget: Container(decoration: BoxDecoration(border: Border.all(color:package.carPackages!.isNotEmpty && !DateTime.parse(package.endDate!).isBefore(DateTime.now()) ? Color(0xff39B54A) : Color(0xffED5500)),borderRadius: BorderRadius.circular(50)),child: Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3),decoration: BoxDecoration(border: Border.all(color: Colors.white),gradient: LinearGradient(colors: package.carPackages!.isNotEmpty && !DateTime.parse(package.endDate!).isBefore(DateTime.now()) ? [Color(0xff39B54A),Color(0xff00A651)]:[Color(0xffED5500)],begin: Alignment.topCenter,end: Alignment.bottomCenter),borderRadius: BorderRadius.circular(50)),child: Text(
  package.carPackages!.isNotEmpty && !DateTime.parse(package.endDate!).isBefore(DateTime.now()) ?LocaleKeys.active.tr()    : LocaleKeys.unActive.tr() 
      ,style: TextStyle(fontSize: 8,color: Colors.white,fontWeight: FontWeight.w700),),)),
  
  ),
),
SizedBox(height: 5),
ExpansionTile(leading: SizedBox.shrink(),trailing:SizedBox.shrink(),shape: Border(),childrenPadding: EdgeInsets.fromLTRB(30, 0, 0, 0) ,tilePadding:EdgeInsets.all(0),collapsedIconColor: Colors.transparent,
          title: Center(
            child: PackageDetailsWidget(
              firstWidget: Image.asset("assets/images/client_car2.png",width: 46,height: 18),
              secondWidget: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.vehiclesCount.tr(),style:TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                  Text(LocaleKeys.vehiclesCount.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.createdAt!)),style: TextStyle(fontSize: 7,color: Color(0xffA3A3A3),fontWeight: FontWeight.w700),)
                ],
              ),
              thirdWidget: Text("${package.assignedCars}/${package.numberOfCars}",style: TextStyle(fontSize: 27,color:package.assignedCars == package.numberOfCars? Color(0xffEC0505) : Color(0xff3FAA43),fontWeight: FontWeight.w700),),
            
            ),
          ),
          children: package.carPackages!.isEmpty ? [Row(children: [
            Text(LocaleKeys.noCars.tr(),style: TextStyle(fontSize: 8,fontWeight: FontWeight.w700,color: Color(0xffEC0505))),
      SizedBox(width: 10),   AddCarToPackageButton(
                      buttonText: LocaleKeys.addCar.tr(),
                      onTap: () {
                        NavigationService.navigatorKey.currentContext!
                            .pushNamed(PageRouteName.addCarScreen, arguments: {
                          "myCarModel": MyCarModel(),
                          "activateCarValue": false,
                          "addCarToPackageValue": false,
                          "isAddCorporateCarValue": false,
                          "isAddNewCarToPackageValue": true,
                          "editCarValue": false,
                          "selectedAddedPackage": package,
                          "isFromPayment": false,
                        });
                      },
                    )
          ],)] : List.generate(package.carPackages!.length, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Row(children: [CircleAvatar(radius: 10,
              backgroundColor:
             package.carPackages![index].car.active ? Color(0xff45B34A):Color(0xffED5500),)
              ,SizedBox(width: 10,),Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7.5,),
                  Text(package.carPackages![index].car.id.toString(),style: TextStyle(fontSize: 7,fontWeight: FontWeight.w700,color: Color(0xff0B141F)),),
                  package.carPackages![index].car.active ? Text(LocaleKeys.carAddingDate.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.carPackages![index].car.createdAt.toString())),style: TextStyle(fontSize: 5,fontWeight: FontWeight.w700,color: Color(0xff45B34A)),):
                  Column(crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(LocaleKeys.unActiveCar.tr(),style: TextStyle(fontSize: 5,fontWeight: FontWeight.w700,color: Color(0xffED5500)),),                    
                        ],
                      ),
                        SizedBox(height: 7.5,),
                   _buildCountDownTimer(DateTime.parse(package.carPackages![index].car.createdAt.add(Duration(days:package.activateAfterDays! )).toString())),

                    ],
                  ),
                 
                  // Spacer(),
                 
                
                ],
              ),Spacer(),Container(padding: EdgeInsets.only(top:7.5),child: Center(child: Text(package.carPackages![index].car.plateNumber,style: TextStyle(fontSize: 6,color:Color(0xff595E63),fontWeight: FontWeight.w700),)),width: 100,height: 30,decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/plate.png"))),)]),
            ),
          )),
        ),

SizedBox(height: 5),
ExpansionTile(trailing: SizedBox.shrink(),leading: SizedBox.shrink(),shape: Border(),childrenPadding: EdgeInsets.fromLTRB(30, 0, 0, 0) ,tilePadding:EdgeInsets.all(0),collapsedIconColor: Colors.transparent,
  title: PackageDetailsWidget(
    firstWidget: Image.asset("assets/images/wench_stepper.png",width: 50,height: 26),
    secondWidget: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.remainingRequests.tr(),style:TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                  Text(LocaleKeys.remainingRequests.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.createdAt!)),style: TextStyle(fontSize: 7,color: Color(0xffA3A3A3),fontWeight: FontWeight.w700),)
                ],
              ),
    thirdWidget: Text("${package.numberOfDiscountTimes! - package.requestsInThisPackage! > 0 ?package.numberOfDiscountTimes! - package.requestsInThisPackage! : 0}/${package.numberOfDiscountTimes!}",style: TextStyle(fontSize: 27,color:package.numberOfDiscountTimes! - package.requestsInThisPackage! > 0 ? Color(0xff3FAA43):Color(0xffEC0505),fontWeight: FontWeight.w700),),
  
  ),
),
SizedBox(height: 5),
ExpansionTile(trailing: SizedBox.shrink(),leading: SizedBox.shrink(),shape: Border(),childrenPadding: EdgeInsets.fromLTRB(30, 0, 0, 0) ,tilePadding:EdgeInsets.all(0),collapsedIconColor: Colors.transparent,
  title: PackageDetailsWidget(
    firstWidget: Image.asset("assets/images/n300.png",width: 50,height: 26),
    secondWidget: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.remainingOtherRequests.tr(),style:TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                  Text(LocaleKeys.remainingOtherRequests.tr()+DateFormat('yyyy-MM-dd').format(DateTime.parse(package.createdAt!)),style: TextStyle(fontSize: 7,color: Color(0xffA3A3A3),fontWeight: FontWeight.w700),)
                ],
              ),
    thirdWidget: Text("${package.numberOfDiscountTimesOther! - package.requestsInThisPackageOtherServices! > 0 ?package.numberOfDiscountTimesOther! - package.requestsInThisPackageOtherServices! : 0}/${package.numberOfDiscountTimesOther!}",style: TextStyle(fontSize: 27,color: package.numberOfDiscountTimesOther! - package.requestsInThisPackageOtherServices! > 0 ?Color(0xff3FAA43) : Color(0xffEC0505),fontWeight: FontWeight.w700),),
  
  ),
),
     
          // Text(LocaleKeys.remainingRequests.tr()+ ": ${((package.numberOfDiscountTimes! - package.requestsInThisPackage!) >= 0 ? (package.numberOfDiscountTimes! - package.requestsInThisPackage!) : 0 ).toString()}"),
          // Text(LocaleKeys.remainingOtherRequests.tr()+ ": ${((package.numberOfDiscountTimesOther! - package.requestsInThisPackageOtherServices!) >= 0 ? (package.numberOfDiscountTimesOther! - package.requestsInThisPackageOtherServices!) : 0 ).toString() }"),


        ],
      )
    ));
  }
  Widget _buildCountDownTimer(DateTime activatedDate) =>
      CountDownTimer(activatedDate: activatedDate);
}