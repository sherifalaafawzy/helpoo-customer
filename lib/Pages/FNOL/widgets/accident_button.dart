import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Pages/FNOL/fnol_bloc.dart';

import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/spacing.dart';


class AccidentButton extends StatelessWidget {
  final String title;
  final Function(bool?) onChanged;
  final bool isSelected;
  bool isInfinityWidth;

  AccidentButton(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.isSelected,
      this.isInfinityWidth = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            onChanged(!isSelected);
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorsManager.darkGreyColor,
              borderRadius: 6.5.rSp.br,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.0.rw,
              vertical: 6.0.rw,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  isInfinityWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Container(
                  height: 14.rh,
                  width: 14.rw,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsManager.primaryGreen
                        : ColorsManager.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: ColorsManager.primaryGreen,
                      width: 1.5.rSp,
                    ),
                  ),
                ),
                horizontalSpace4,
                Text(
                  title,
                  style: TextStyles.bold15.copyWith(color: ColorsManager.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
