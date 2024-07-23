import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../Main/main_bloc.dart';


class PrimarySearchField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool isOrigin;
  final Widget? suffixIcon;
  final double? height;

  const PrimarySearchField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.isOrigin = false,
    this.suffixIcon,
    this.height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Container(
          height:height?? 40,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: onTap,
                  controller: controller,
                  onChanged: onChanged,
                  maxLines: 1,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: hint,
                    suffixIcon: suffixIcon,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyles.regular14.copyWith(
                      color: ColorsManager.textColor,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                  style: TextStyles.regular14.copyWith(
                    color: ColorsManager.textColor,
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
