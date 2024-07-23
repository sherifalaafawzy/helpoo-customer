import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';

import 'package:maps_launcher/maps_launcher.dart';

import '../../../Configurations/Constants/api_endpoints.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/fnol/latestFnolModel.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/online_image_viewer.dart';
import '../../../Widgets/spacing.dart';


class FnolWidgetSummary extends StatelessWidget {
  String? title;
  double? lat;
  double? lng;
  String? locationName;
  String? locationAddress;
  List<Images>? images;
  String? icon;
  Widget? button;
  Widget? voiceComment;
  FnolWidgetSummary({
    Key? key,
    this.title,
    this.lat,
    this.lng,
    this.locationName,
    this.locationAddress,
    this.images,
    this.icon,
    this.button,
    this.voiceComment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.gray20,
        borderRadius: 14.rSp.br,
        boxShadow: primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon != null
                  ? LoadAssetImage(
                      image: AssetsImages.pin,
                      height: 25,
                      color: ColorsManager.mainColor,
                    )
                  : Container(),
              Text(
                title ?? "",
                style: TextStyles.bold20,
              ),
              Spacer(),
              button != null ? button! : Container(),
            ],
          ),
          verticalSpace6,
          Column(
            children: [
              Visibility(
                visible: locationName != null && locationName != "",
                child: Text(
                  locationName ?? "",
                  style: TextStyles.bold14,
                ),
              ),
              verticalSpace8,
              if(voiceComment!=null)voiceComment!,
            ],
          ),
          verticalSpace6,
          Visibility(
            visible: locationAddress != null && locationAddress != "",
            child: GestureDetector(
              onTap: () async {
                if (lat != null && lng != null) await MapsLauncher.launchCoordinates(double.parse(lat.toString()), double.parse(lng.toString()));
              },
              child: Text(
                locationAddress ?? "",
                style: TextStyles.bold14Location,
              ),
            ),
          ),
          images != null && images != []
              ? SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: InterActiveOnlineImage(imgUrl: imagesBaseUrl + images![index].imagePath!),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
