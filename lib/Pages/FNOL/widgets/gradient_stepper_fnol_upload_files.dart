import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/colors.dart';
import '../fnol_bloc.dart';

class GradientStepperFNOl extends StatefulWidget {
  final double percentage;
  final double width;
  final double? height;
  FnolBloc? fnolBloc;

  GradientStepperFNOl(
      {super.key,
      required this.percentage,
      required this.width,
      this.height,
      required this.fnolBloc});

  @override
  State<GradientStepperFNOl> createState() => _GradientStepperFNOlState();
}

class _GradientStepperFNOlState extends State<GradientStepperFNOl> {
  @override
  void initState() {
    super.initState();
  }

  _increaseByAnimation() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) async {
        await widget.fnolBloc?.cameraController?.dispose();
        if (state is UploadImagesSuccess) {
          await _increaseByAnimation();

        }
      },
      builder: (context, state) {
        return SizedBox(
          width: widget.width,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: duration500,
                height: widget.height ?? 5.rw,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.rSp),
                  color: ColorsManager.darkGreyColor,
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: AnimatedContainer(
                  duration: duration500,
                  width: widget.width / (100 / widget.percentage),
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
              )
            ],
          ),
        );
      },
    );
  }
}
