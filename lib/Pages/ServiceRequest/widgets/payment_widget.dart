import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';

import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/spacing.dart';

class PaymentWidget extends StatelessWidget {
  final bool isSelected;
  final String image;
  final String title;
  final VoidCallback onTap;
  final bool? visiablity;

  const PaymentWidget(
      {super.key,
      required this.isSelected,
      required this.image,
      required this.title,
      required this.onTap,
      required this.visiablity});

  @override
  Widget build(BuildContext context) {
    return visiablity!
        ? BlocBuilder<WenchServiceBloc, WenchServiceState>(
            builder: (context, state) {
              return InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    Container(
                      width: 10.rw,
                      height: 10.rh,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorsManager.mainColor
                            : ColorsManager.darkGreyColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorsManager.black,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    horizontalSpace(9),
                    LoadSvg(
                      image: image,
                      isIcon: true,
                    ),
                    horizontalSpace16,
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyles.regular11
                            .copyWith(color: ColorsManager.black, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Container();
  }
}
