import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Pages/MyCars/my_cars_bloc.dart';
import 'package:helpooappclient/Widgets/spacing.dart';

import '../../../Widgets/primary_button.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  MyCarsBloc? myCarsBloc;

  @override
  void initState() {
    super.initState();
    myCarsBloc = context.read<MyCarsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: BlocConsumer<MyCarsBloc, MyCarsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(myCarsBloc!.licensesImages.last.path)),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'التالى',
                                onPressed: () {
                                  // myCarsBloc.addAdditionalPaperImage();
                                  context.pop();
                                },
                              ),
                            ),
                            horizontalSpace10,
                            Expanded(
                              child: PrimaryButton(
                                text: 'اعادة التصوير',
                                onPressed: () {
                                  context.pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }
}
