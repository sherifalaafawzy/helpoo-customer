import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';


class BasicFeesWidget extends StatelessWidget {
  const BasicFeesWidget({Key? key,required this.request}) : super(key: key);
  final ServiceRequest? request;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 29,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(11)),
            border: Border.all(color: const Color(0xff707070), width: 1),
            color: const Color(0xff909090).withOpacity(0.2865059971809387)),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Text(
              'basic cost ${request?.originalFees} ${'EGP'.tr()}',
                style: const TextStyle(
                  color: ColorsManager.black,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,

              ),
            ),
            const Spacer(),
            Container(
                width: 126,
                height: 29,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                    color: Color(0xff095e25)),
                child: Center(
                  child: Text(
                    request?.paymentMethod.enName??'',
                      style: const TextStyle(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,

                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
