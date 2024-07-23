import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Models/service_request/service_request.dart';
import 'package:helpooappclient/Services/cache_helper.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Configurations/di/injection.dart' as di;
import '../../../Configurations/di/injection.dart';
import '../../../Style/theme/colors.dart';
import '../../../Widgets/primary_flip_horizontal_widget.dart';
import '../home_bloc.dart';

class GradientStepper extends StatefulWidget {
  double? percentage;
  final HomeBloc homeBloc;
  final double width;
  final ServiceRequest? serviceRequest;
  final double? height;
  final Widget? widgetWenchOrPin;
  final Widget? widgetSecondWenchOrPin;
  final bool? stepperOpenSpeed;

  /// final Function(double?)? increaseByAnimation;

  GradientStepper(
      {super.key,
      required this.percentage,
      required this.width,
      this.height,
      required this.widgetWenchOrPin,
      required this.widgetSecondWenchOrPin,

      ///  required this.increaseByAnimation,
      required this.homeBloc,
      required this.serviceRequest,
      required this.stepperOpenSpeed});

  @override
  State<GradientStepper> createState() => _GradientStepperState();
}

class _GradientStepperState extends State<GradientStepper> {
  @override
  void initState() {
    sl<CacheHelper>()
        .get('${widget.serviceRequest?.id}percentage')
        .then((value) {
      widget.serviceRequest?.currentGradientPercentage = value ?? 100;
      widget.percentage = value ?? 100;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sl<CacheHelper>()
        .get('${widget.serviceRequest?.id}percentage')
        .then((value) {
      widget.serviceRequest?.currentGradientPercentage = value ?? 100;
      widget.percentage = value ?? 100;
    });

    ///widget.increaseByAnimation!(widget.percentage);
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SizedBox(
          width: widget.width,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                // duration: duration500,
                height: widget.height ?? 6.rw,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.rSp),
                  color: ColorsManager.darkGreyColor,
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: widget.stepperOpenSpeed! ? 0 : 5),
                width: widget.width /
                    (100 /
                        ((widget.serviceRequest!.done ||
                                widget.serviceRequest!.arrived ||
                                widget.serviceRequest!.destArrived ||
                                widget.serviceRequest!
                                        .currentGradientPercentage! <=
                                    20)
                            ? 20
                            : widget
                                .serviceRequest!.currentGradientPercentage!)),
                height: widget.height ?? 5.rw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.rSp),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFF9BE4C),
                      Color(0xFF44B649),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: widget.stepperOpenSpeed! ? 0 : 5),
                width: widget.width /
                    (100 /
                        ((widget.serviceRequest!.done ||
                                widget.serviceRequest!.arrived ||
                                widget.serviceRequest!.destArrived ||
                                widget.serviceRequest!
                                        .currentGradientPercentage! <=
                                    20)
                            ? 25
                            : widget
                                .serviceRequest!.currentGradientPercentage!)),
                height: widget.height ?? 35.rw,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: isArabic
                        ? [
                            widget.widgetWenchOrPin!,
                            widget.widgetSecondWenchOrPin!,
                          ]
                        : [
                            PrimaryFlipHorizontalWidget(
                                child: widget.widgetSecondWenchOrPin!,
                            ),
                            PrimaryFlipHorizontalWidget(
                              child: widget.widgetWenchOrPin!,
                            ),
                          ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
