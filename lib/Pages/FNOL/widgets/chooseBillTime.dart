import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/FNOL/fnol_bloc.dart';

import '../../../Configurations/Constants/enums.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';

class ChooseBillTime extends StatelessWidget {
  ChooseBillTime({super.key, required this.fnolBloc});

  FnolBloc? fnolBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            child: GestureDetector(
                onTap: () => fnolBloc!.changeBillTime(BillDeliveryTime.first),
              child: Container(
                decoration: fnolBloc!.billDeliveryTime ==
                    BillDeliveryTime.first
                    ? BoxDecoration(
                  color: ColorsManager.mainColor,
                  borderRadius: BorderRadius.circular(10),
                )
                    : BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '09:00 AM - 1:00 PM',
                    style: fnolBloc!.billDeliveryTime == BillDeliveryTime.first
                        ? TextStyles.whiteBold16
                        : TextStyles.bold16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
               onTap: () => fnolBloc!.changeBillTime(BillDeliveryTime.second),
              child: Container(
                decoration:
                fnolBloc!.billDeliveryTime == BillDeliveryTime.second ?
                BoxDecoration(
                       color: ColorsManager.mainColor,
                       borderRadius: BorderRadius.circular(10),
                   )
                           :
                BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '01:00 PM - 5:00 PM',
                    style:
                    fnolBloc!.billDeliveryTime == BillDeliveryTime.second
                      ? TextStyles.whiteBold16
                       :
                    TextStyles.bold16,
                  ),
                ),
              ),
            ),
          )
        ]);
      },
    );
  }
}
