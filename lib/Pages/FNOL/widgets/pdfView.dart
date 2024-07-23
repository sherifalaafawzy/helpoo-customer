import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../Widgets/scaffold_bk.dart';
import '../../../generated/locale_keys.g.dart';


class PdfView extends StatefulWidget {
  final String pdf;
  final bool isFile;

  const PdfView({
    Key? key,
    required this.pdf,
    required this.isFile,
  }) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  void initState() {
    super.initState();
    debugPrint(widget.pdf);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
       alignment: AlignmentDirectional.topStart,
      extendBodyBehindAppBar: false,
      verticalPadding: 0,
      appBarTitle: 
      LocaleKeys.accidentReport.tr(),
      body: widget.isFile
          ? SfPdfViewer.file(
              File(widget.pdf),
            )
          : SfPdfViewer.network(
              widget.pdf,
            ),
    );
  }
}
