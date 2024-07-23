import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';

import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';


class DiscountWidget extends StatelessWidget {
  const DiscountWidget({Key? key,required this.request}) : super(key: key);
  final ServiceRequest? request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WenchServiceBloc, WenchServiceState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset('assets/images/discount.png'),
            ),
            const SizedBox(height: 6),
            Container(
              width: 101,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    11,
                  ),
                ),
                border: Border.all(color: const Color(0xff707070), width: 1),
                color: const Color(0xff58be3f).withOpacity(0.2865059971809387),
              ),
              child: Center(
                child: Text(
                  "discount ${request?.discountPercentage} %",
                    style: const TextStyle(
                      color: ColorsManager.black,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
