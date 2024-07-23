import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../../Style/theme/colors.dart';


class audioFileCard extends StatefulWidget {
  const audioFileCard({super.key});

  @override
  State<audioFileCard> createState() => _audioFileCardState();
}

class _audioFileCardState extends State<audioFileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.rw,
      height: 70.rh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 200.rw,
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    color: ColorsManager.mainColor,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // audioFilePlayer(
                    //     widget.fnol.mediaController.audioFilePath!),
                  ],
                ),
              ),
            ),
     
          ],
        ),
      ),
    );
  }
}
