// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Configurations/Constants/constants.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/spacing.dart';
import '../fnol_bloc.dart';


class CustomDatePicker extends StatefulWidget {
   CustomDatePicker({super.key,required this.fnolBloc});
  FnolBloc? fnolBloc;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  FnolBloc? fnolBloc;
  @override
  void initState() {
    //fnolBloc=context.read<FnolBloc>();
    fnolBloc=widget.fnolBloc;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc,FnolState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Day Dropdown
            Expanded(
              child: DropdownButton<String>(
                value: fnolBloc?.billDeliveryDate.day.toString(),
                onChanged: (String? newValue) {
                  fnolBloc?.billDeliveryDate = DateTime(
                    fnolBloc!.billDeliveryDate.year,
                    fnolBloc!.billDeliveryDate.month,
                    int.parse(newValue!),
                  );
                  setState(() {

                  });

                },
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: TextStyles.semiBold20.copyWith(
                        color: ColorsManager.mainColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            horizontalSpace14,
            // Month Dropdown
            Expanded(
              child: DropdownButton<String>(
                value: fnolBloc?.billDeliveryDate.month.toString(),
                onChanged: (String? newValue) {
                  fnolBloc?.billDeliveryDate = DateTime(
                    fnolBloc!.billDeliveryDate.year,
                    int.parse(newValue!),
                    fnolBloc!.billDeliveryDate.day,
                  );
                  setState(() {

                  });

                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: TextStyles.semiBold20.copyWith(
                        color: ColorsManager.mainColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            horizontalSpace14,
            // Year Dropdown
            Expanded(
              child: Center(
                child: DropdownButton<String>(
                  underline: SizedBox(),
                  value:fnolBloc?.billDeliveryDate.year.toString(),
                  onChanged: (String? newValue) {
                    fnolBloc?.billDeliveryDate = DateTime(
                      int.parse(newValue!),
                      fnolBloc!.billDeliveryDate.month,
                      fnolBloc!.billDeliveryDate.day,
                    );
                    setState(() {

                    });
                  },
                  items: years.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyles.semiBold20.copyWith(
                          color: ColorsManager.mainColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
