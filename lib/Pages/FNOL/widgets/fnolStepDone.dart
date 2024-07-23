import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Models/fnol/accident_report_details_model.dart';
import 'package:helpooappclient/Pages/FNOL/fnol_bloc.dart';
import 'package:helpooappclient/Style/theme/text_styles.dart';
import 'package:helpooappclient/Widgets/primary_button.dart';

import '../../../Configurations/Constants/enums.dart';
import '../../../Services/pdf_service.dart';
import '../../../Widgets/show_success_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../pages/fnol_steps.dart';

class fnolStepDone extends StatefulWidget {
  final Report report;
  final String from;
  final FnolBloc? fnolBloc;

  const fnolStepDone(this.report,
      {Key? key, this.from = '', required this.fnolBloc})
      : super(key: key);

  @override
  State<fnolStepDone> createState() => fnolStepDoneState();
}

class fnolStepDoneState extends State<fnolStepDone> {
  @override
  void initState() {
    print('fnolStepDoneState initState');
    super.initState();

    widget.fnolBloc?.isSent = false;
    String? formName;
    switch (widget.from) {
      case "Police Images":
        formName = "police";
        break;
      case "Before Repair Images":
        formName = "repair_before";
        break;
      case "Supplement Images":
        formName = "supplement";
        break;
      case "Resurvey Images":
        formName = "resurvey";
        break;
      case "Right Save":
        formName = "rightSave";
        break;
      case "After Repair":
        formName = "aRepair";
        break;
    }
    widget.fnolBloc?.getAccidentDetails(
      accidentId: widget.report.id,
      from: formName!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<FnolBloc, FnolState>(
        listener: (context, state) async {
          if (state is SendFnolStepPdfSuccess) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => FnolBloc(),
                child: FNOLStepsPage(fnol: widget.fnolBloc?.fnolModel),
              ),
            ));
          }
          if (state is AccidentDetailsSuccess) {
            /// 1- create pdf and get it in base64
            /// 2- send it to the server

            debugPrint('------------>>>>>>>> ${state.from}');

            if (widget.fnolBloc!.isSent) {
              return;
            }

            if (state.from == 'police') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>> police');
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.clientModel?.name ??
                        '',
                    fnolNumber:
                        '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.plateNumber ??
                        '',
                    insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.insuranceCompany?.arName ??
                        '',
                    policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.policyNumber ??
                        '',
                    carManufacturer: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.manufacturer?.name ??
                        '',
                    carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                            ?.carModel?.name ??
                        '',
                    vinNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.vinNumber ??
                        '',
                    images:
                        widget.fnolBloc?.accidentDetailsModel?.policeImages ??
                            [],
                    step: FNOLSteps.policeReport,
                  ),
                ),
              );
              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '2',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'police',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'ارفاق محضر شرطه سيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم محضر شرطه لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            } else if (state.from == 'repair_before') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>>++++++++++++++== repair_before');
              String pdf = await PdfController.getPdfBase64(
                  pdf: await PdfController.generateStepFnolPdf(
                context: context,
                accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                generatePdfStepDto: GeneratePdfStepDto(
                  userName: widget.fnolBloc?.accidentDetailsModel?.report
                          ?.clientModel?.name ??
                      '',
                  fnolNumber:
                      '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                  carPlateNumber: widget.fnolBloc?.accidentDetailsModel?.report
                          ?.car?.plateNumber ??
                      '',
                  insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                          ?.report?.car?.insuranceCompany?.arName ??
                      '',
                  policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                          ?.car?.policyNumber ??
                      '',
                  carManufacturer: widget.fnolBloc?.accidentDetailsModel?.report
                          ?.car?.manufacturer?.name ??
                      '',
                  carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                          ?.carModel?.name ??
                      '',
                  vinNumber: widget.fnolBloc?.accidentDetailsModel?.report?.car
                          ?.vinNumber ??
                      '',
                  images:
                      widget.fnolBloc?.accidentDetailsModel?.bRepairImages ??
                          [],
                  step: FNOLSteps.bRepair,
                ),
              ));
              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '1',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'beforeRepair',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'طلب معاينه قبل الاصلاح  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم معاينه قبل الاصلاح لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            } else if (state.from == 'supplement') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>>+++ supplement');

              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.clientModel?.name ??
                        '',
                    fnolNumber:
                        '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.plateNumber ??
                        '',
                    insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.insuranceCompany?.arName ??
                        '',
                    policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.policyNumber ??
                        '',
                    carManufacturer: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.manufacturer?.name ??
                        '',
                    carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                            ?.carModel?.name ??
                        '',
                    vinNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.vinNumber ??
                        '',
                    images: widget
                            .fnolBloc?.accidentDetailsModel?.supplementImages ??
                        [],
                    step: FNOLSteps.supplement,
                  ),
                ),
              );
              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '5',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'supplement',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'طلب معاينه ملحق مقايسه إضافية ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم  معاينه ملحق مقايسه لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            } else if (state.from == 'resurvey') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>> resurvey');
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.clientModel?.name ??
                        '',
                    fnolNumber:
                        '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.plateNumber ??
                        '',
                    insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.insuranceCompany?.arName ??
                        '',
                    policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.policyNumber ??
                        '',
                    carManufacturer: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.manufacturer?.name ??
                        '',
                    carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                            ?.carModel?.name ??
                        '',
                    vinNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.vinNumber ??
                        '',
                    images:
                        widget.fnolBloc?.accidentDetailsModel?.resurveyImages ??
                            [],
                    step: FNOLSteps.resurvey,
                  ),
                ),
              );
              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '7',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'resurvey',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'طلب معاينه معاينه بعد الاصلاح  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم طلب معاينه بعد الاصلاح لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            } else if (state.from == 'rightSave') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>> rightSave');
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.clientModel?.name ??
                        '',
                    fnolNumber:
                        '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.plateNumber ??
                        '',
                    insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.insuranceCompany?.arName ??
                        '',
                    policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.policyNumber ??
                        '',
                    carManufacturer: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.manufacturer?.name ??
                        '',
                    carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                            ?.carModel?.name ??
                        '',
                    vinNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.vinNumber ??
                        '',
                    images: [],
                    step: FNOLSteps.rightSave,
                  ),
                ),
              );
              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '6',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'rightSave',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'طلب معاينه حفظ حق ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم معاينه حفظ حق لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            } else if (state.from == 'aRepair') {
              if (widget.fnolBloc!.isSent) {
                return;
              }

              widget.fnolBloc?.isSent = true;
              print('-------->>> aRepair');
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  accidentDetailsModel: widget.fnolBloc!.accidentDetailsModel!,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.clientModel?.name ??
                        '',
                    fnolNumber:
                        '${widget.fnolBloc?.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.plateNumber ??
                        '',
                    insuranceCompany: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.insuranceCompany?.arName ??
                        '',
                    policyNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.policyNumber ??
                        '',
                    carManufacturer: widget.fnolBloc?.accidentDetailsModel
                            ?.report?.car?.manufacturer?.name ??
                        '',
                    carModel: widget.fnolBloc?.accidentDetailsModel?.report?.car
                            ?.carModel?.name ??
                        '',
                    vinNumber: widget.fnolBloc?.accidentDetailsModel?.report
                            ?.car?.vinNumber ??
                        '',
                    images: [],
                    step: FNOLSteps.aRepair,
                  ),
                ),
              );

              widget.fnolBloc?.sendFnolStepPdf(
                pdfReportId: '3',
                accidentId: widget.report.id.toString(),
                pdf: pdf,
                type: 'afterRepair',
                carId: widget.fnolBloc?.accidentDetailsModel?.report?.car?.id
                        .toString() ??
                    '',
                subject:
                    'طلب معاينه معاينه بعد الاصلاح  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''} ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} رقم (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.plateNumber ?? ''}) شاسيه (${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}) ',
                body:
                    'الساده شركه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.insuranceCompany?.arName ?? widget.fnolBloc?.accidentDetailsModel?.report?.insuranceCompany?.arName ?? ''}'
                    '\n'
                    'مرسل لكم طلب معاينه بعد الاصلاح لسيارة ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.manufacturer?.arName ?? ''}  ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.carModel?.arName ?? ''} شاسيه ${widget.fnolBloc?.accidentDetailsModel?.report?.car?.vinNumber ?? ''}'
                    '\n'
                    'يرجي الإطلاع علي المرفقات',
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  "${LocaleKeys.fNOLFollowUp.tr()} # ${widget.report.id}",
                )),
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/report.png',
                height: 200,
              ),
              Text(
                LocaleKeys.fnolDoneMsg.tr(),
                textAlign: TextAlign.center,
                style: TextStyles.bold22,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    bottom: 20, start: 20, end: 20, top: 8),
                child: PrimaryButton(
                  text: LocaleKeys.confirm.tr(),
                  isLoading: state is AccidentDetailsLoading ||
                      state is SendFnolStepPdfLoading,
                  onPressed: () {
                    // pop until fnol steps
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

///* 1- police [images]
///* 2- before repair [images + location]
///* 3- supplement [images + location]
///* 4- resurvey [images + location]
///* 5- after repair [location]
///* 6- right Save [location]
///

/*
1- Get Current FNOL
2- Create Pdf With Details
* */
