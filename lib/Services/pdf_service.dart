import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpooappclient/Configurations/extensions/days_extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

import '../Configurations/Constants/api_endpoints.dart';
import '../Configurations/Constants/enums.dart';
import '../Models/fnol/accident_report_details_model.dart';
import '../Models/fnol/imagesModel.dart';
import '../Models/fnol/locationAddress.dart';

class GeneratePdfStepDto {
  final String userName;
  final String fnolNumber;
  final String carPlateNumber;
  final String insuranceCompany;
  final String policyNumber;
  final String carManufacturer;
  final String carModel;
  final String vinNumber;
  final List<ImagesModel> images;
  final FNOLSteps step;

  GeneratePdfStepDto({
    required this.userName,
    required this.fnolNumber,
    required this.carPlateNumber,
    required this.insuranceCompany,
    required this.policyNumber,
    required this.carManufacturer,
    required this.carModel,
    required this.vinNumber,
    required this.images,
    required this.step,
  });
}

class PdfController {
  PdfController._();

  ///* create inspection Pdf
  static Future<pw.Document> generateStepFnolPdf({
    required BuildContext context,
    required GeneratePdfStepDto generatePdfStepDto,
    required GetAccidentDetailsModel accidentDetailsModel,
  }) async {
    final pdf = pw.Document();
    var logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/newLogo.png')).buffer.asUint8List(),
    );

    var arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Regular.ttf"));

    pdf.addPage(
      _firstPage(arabicFont, logo, generatePdfStepDto, accidentDetailsModel),
    );
    print('Pdf First page created successfully');

    ///* 1- Images
    print('Images length : ${generatePdfStepDto.images.length}');
    for (int i = 0; i < generatePdfStepDto.images.length; i++) {
      print('image : $i');
      pdf.addPage(
        await _imagesPage(
          arabicFont: arabicFont,
          index: i,
          step: generatePdfStepDto.step,
          image: generatePdfStepDto.images[i].imagePath ?? '',
        ),
      );
    }
    return pdf;
  }

  ///* First page of inspection pdf
  static pw.Page _firstPage(
    pw.Font arabicFont,
    pw.MemoryImage logo,
    GeneratePdfStepDto generatePdfStepDto,
    GetAccidentDetailsModel accidentDetailsModel,
  ) {
    LocationAddress? address = generatePdfStepDto.step.isPoliceReport
        ? null
        : generatePdfStepDto.step.isBeforeRepair
            ? accidentDetailsModel.report?.beforeRepairLocation?.last
            : generatePdfStepDto.step.isAfterRepair
                ? accidentDetailsModel.report?.afterRepairLocation?.last
                : generatePdfStepDto.step.isSupplement
                    ? accidentDetailsModel.report?.supplementLocation?.last
                    : generatePdfStepDto.step.isResurvey
                        ? accidentDetailsModel.report?.resurveyLocation?.last
                        : generatePdfStepDto.step.isRightSave
                            ? accidentDetailsModel.report?.rightSaveLocation?.last
                            : null;

    String addressName = generatePdfStepDto.step.isPoliceReport
        ? ''
        : generatePdfStepDto.step.isBeforeRepair
            ? accidentDetailsModel.report?.bRepairName?.last ?? ''
            : generatePdfStepDto.step.isAfterRepair
                ? accidentDetailsModel.report?.afterRepairLocation?.last.name ?? ''
                : generatePdfStepDto.step.isSupplement
                    ? accidentDetailsModel.report?.supplementLocation?.last.name ?? ''
                    : generatePdfStepDto.step.isResurvey
                        ? accidentDetailsModel.report?.resurveyLocation?.last.name ?? ''
                        : generatePdfStepDto.step.isRightSave
                            ? accidentDetailsModel.report?.rightSaveLocation?.last.name ?? ''
                            : '';
    return pw.Page(
      theme: pw.ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.black,
            ),
          ),
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                ///* 1
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logo, width: 100, height: 100),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'شركة الميكانيكيون العرب خبراء المعاينة وتقرير الاضرار',
                            style: const pw.TextStyle(
                              fontSize: 12,
                              height: 0.5,
                            ),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'Arab Mechanics Company - Experts in Inspection and Damage Report',
                            style: const pw.TextStyle(
                              fontSize: 12,
                              height: 0.5,
                            ),
                            textDirection: pw.TextDirection.ltr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ///* 2
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      generatePdfStepDto.step.isPoliceReport ? 'إرفاق محضر شرطة' : 'طلب معاينة حادث',
                      style: const pw.TextStyle(
                        fontSize: 16,
                        height: 1,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ],
                ),

                pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green,
                    borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(20),
                      topRight: pw.Radius.circular(20),
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'بيــــانات',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Row(
                  children: [
                    ///* 4
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            ...List.generate(
                              4,
                              (index) {
                                List<String> info = [
                                  '${accidentDetailsModel.report?.id ?? '-----'}',
                                  '${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? '----'}',
                                  '${accidentDetailsModel.report?.car?.policyNumber != '' ? accidentDetailsModel.report?.car?.policyNumber : '----'}',
                                  addressName,
                                ];
                                return pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.symmetric(horizontal: 5),
                                      child: pw.Row(
                                        mainAxisSize: pw.MainAxisSize.max,
                                        mainAxisAlignment: pw.MainAxisAlignment.end,
                                        children: [
                                          pw.Text(
                                            textAlign: pw.TextAlign.right,
                                            info[index].isEmpty ? '-----' : info[index],
                                            style: const pw.TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index != 3)
                                      pw.Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///* 3
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            ...List.generate(
                              4,
                              (index) {
                                List<String> info = [
                                  'رقم الإخطار',
                                  'شركة التأمين',
                                  'رقم الوثيقة',
                                  'اسم مكان الإصلاح',
                                ];
                                return pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      info[index],
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (index != 3)
                                      pw.Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///* 2
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            ...List.generate(
                              4,
                              (index) {
                                List<String> info = [
                                  '${accidentDetailsModel.report?.client ?? ''}',
                                  '${accidentDetailsModel.report?.car?.plateNumber ?? ''}',
                                  '${accidentDetailsModel.report?.car?.manufacturer?.name ?? ''} ${accidentDetailsModel.report?.car?.carModel?.name ?? ''}',
                                  '${accidentDetailsModel.report?.car?.vinNumber ?? ''}',
                                ];
                                return pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.symmetric(horizontal: 5),
                                      child: pw.Row(
                                        mainAxisSize: pw.MainAxisSize.max,
                                        mainAxisAlignment: pw.MainAxisAlignment.end,
                                        children: [
                                          pw.Text(
                                            textAlign: pw.TextAlign.right,
                                            info[index].isEmpty ? '-----' : info[index],
                                            style: const pw.TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index != 3)
                                      pw.Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///* 1
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            ...List.generate(
                              4,
                              (index) {
                                List<String> info = [
                                  'اسم المؤمن عليه',
                                  'رقم السيارة',
                                  'ماركة السيارة',
                                  'رقم الشاسية',
                                ];
                                return pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      info[index],
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (index != 3)
                                      pw.Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 5,
                ),

                if (!generatePdfStepDto.step.isPoliceReport) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Expanded(
                        child: pw.UrlLink(
                          child: pw.Text(
                            address?.address ?? '',
                            maxLines: 4,
                            overflow: pw.TextOverflow.clip,
                            style: const pw.TextStyle(
                              color: PdfColors.green,
                              fontSize: 10,
                              height: 1,
                              decoration: pw.TextDecoration.underline,
                              decorationColor: PdfColors.green,
                            ),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          destination:
                              'https://www.google.com/maps/search/?api=1&query=${address?.lat},${address?.lng}',
                        ),
                      ),
                      pw.Text(
                        'عنوان مكان الإصلاح ',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                        DateTime.now().dateMonthYearFormat,
                        style: const pw.TextStyle(
                          color: PdfColors.green,
                          fontSize: 8,
                          height: 1,
                          decoration: pw.TextDecoration.underline,
                          decorationColor: PdfColors.green,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'تاريخ المعاينة ',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'مرفق مقايسات الإصلاح',
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Row(
                    children: [
                      ...List.generate(
                        4,
                        (index) {
                          List<String> info = [
                            '٦٣٦/٠٦٦/ س.ت ١٦٨٥٤٥ تسجيل ٠٤٥support@helpooapp.comTel : ( +202 ) 21 92 72 02',
                            '128 جوزيف تيتو طريق السندباد مصر الجديدة - القاهرة',
                            'Registred in the Financial Regulatory Authority (FRA) with license No. 84 under resolution No.1578@2021',
                            'مقيدة بالهيئة العامة للرقابة المالية تحت رقم 84 بقرار 1578 لسنة 2021',
                          ];
                          return pw.Expanded(
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    info[index],
                                    maxLines: 5,
                                    overflow: pw.TextOverflow.clip,
                                    textAlign: index == 0 || index == 2 ? pw.TextAlign.left : pw.TextAlign.right,
                                    style: const pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                                if (index != 3)
                                  pw.Container(
                                    margin: pw.EdgeInsets.symmetric(horizontal: 5),
                                    height: 80,
                                    width: 1,
                                    color: PdfColors.green,
                                  ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Center(
                    child: pw.Container(
                      width: 200,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'Hot Line  17000',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  ///* images Page
  static Future<pw.Page> _imagesPage({
    required pw.Font arabicFont,
    required String image,
    required int index,
    required FNOLSteps step,
  }) async {
    var networkImage = pw.MemoryImage(
      (await http.get(Uri.parse('$imagesBaseUrl$image'))).bodyBytes,
    );
    return pw.Page(
      theme: pw.ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.green,
            ),
          ),
          child: pw.Column(
            children: [
              ///* 1- Container Title
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green,
                  borderRadius: pw.BorderRadius.only(
                    bottomLeft: pw.Radius.circular(20),
                    bottomRight: pw.Radius.circular(20),
                  ),
                ),
                child: pw.Text(
                  '${step.title} ${index + 1}',
                  style: const pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),

              ///* 3- Image
              pw.Expanded(
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.green,
                    ),
                  ),
                  child: pw.UrlLink(
                    child: pw.Image(
                      networkImage,
                      fit: pw.BoxFit.contain,
                    ),
                    destination: '$imagesBaseUrl$image',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///* create pdf and convert it to base64
  static Future<String> getPdfBase64({
    required pw.Document pdf,
  }) async {
    print('getPdfBase64 -------');
    final pdfBytes = await pdf.save();
    final pdfBase64 = base64Encode(pdfBytes);
    return Future.value(pdfBase64);
  }
}
