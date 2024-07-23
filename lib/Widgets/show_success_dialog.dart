import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Services/navigation_service.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../main.dart';
import '../Configurations/Constants/assets_images.dart';
import '../Configurations/Constants/enums.dart';
import '../Models/fnol/accident_report_details_model.dart';
import '../Services/pdf_service.dart';
import '../Style/theme/colors.dart';
import '../Style/theme/text_styles.dart';
import 'load_svg.dart';
import 'primary_button.dart';
import 'spacing.dart';

showSuccessDialog(context,
    {required String title,
    Function()? onPressed,
    String? form,
    FnolBloc? fnolBloc,
    Report? report,
    GetAccidentDetailsModel? accidentDetailsModel}) async {
 /* if (form != null) {
    if (form == 'police') {
      print('-------->>> police');
      String pdf = await PdfController.getPdfBase64(
        pdf: await PdfController.generateStepFnolPdf(
          context: context,
          accidentDetailsModel: accidentDetailsModel!,
          generatePdfStepDto: GeneratePdfStepDto(
            userName: accidentDetailsModel.report?.clientModel?.name ?? '',
            fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
            carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
            insuranceCompany:
                accidentDetailsModel.report?.car?.insuranceCompany?.arName ??
                    '',
            policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
            carManufacturer:
                accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
            carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
            vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
            images: accidentDetailsModel.policeImages ?? [],
            step: FNOLSteps.policeReport,
          ),
        ),
      );
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '2',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'police',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'ارفاق محضر شرطه سيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم محضر شرطه لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    } else if (form == 'repair_before') {
      print('-------->>> repair_before');
      String pdf = await PdfController.getPdfBase64(
          pdf: await PdfController.generateStepFnolPdf(
        context: context,
        accidentDetailsModel: accidentDetailsModel!,
        generatePdfStepDto: GeneratePdfStepDto(
          userName: accidentDetailsModel.report?.clientModel?.name ?? '',
          fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
          carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
          insuranceCompany:
              accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? '',
          policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
          carManufacturer:
              accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
          carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
          vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
          images: accidentDetailsModel.bRepairImages ?? [],
          step: FNOLSteps.bRepair,
        ),
      ));
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '1',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'beforeRepair',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'طلب معاينه قبل الاصلاح  ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم معاينه قبل الاصلاح لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    } else if (form == 'supplement') {
      print('-------->>> supplement');
      String pdf = await PdfController.getPdfBase64(
        pdf: await PdfController.generateStepFnolPdf(
          context: context,
          accidentDetailsModel: accidentDetailsModel!,
          generatePdfStepDto: GeneratePdfStepDto(
            userName: accidentDetailsModel.report?.clientModel?.name ?? '',
            fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
            carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
            insuranceCompany:
                accidentDetailsModel.report?.car?.insuranceCompany?.arName ??
                    '',
            policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
            carManufacturer:
                accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
            carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
            vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
            images: accidentDetailsModel.supplementImages ?? [],
            step: FNOLSteps.supplement,
          ),
        ),
      );
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '5',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'supplement',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'طلب معاينه ملحق مقايسه إضافية ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم  معاينه ملحق مقايسه لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    } else if (form == 'resurvey') {
      print('-------->>> resurvey');
      String pdf = await PdfController.getPdfBase64(
        pdf: await PdfController.generateStepFnolPdf(
          context: context,
          accidentDetailsModel: accidentDetailsModel!,
          generatePdfStepDto: GeneratePdfStepDto(
            userName: accidentDetailsModel.report?.clientModel?.name ?? '',
            fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
            carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
            insuranceCompany:
                accidentDetailsModel.report?.car?.insuranceCompany?.arName ??
                    '',
            policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
            carManufacturer:
                accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
            carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
            vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
            images: accidentDetailsModel.resurveyImages ?? [],
            step: FNOLSteps.resurvey,
          ),
        ),
      );
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '7',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'resurvey',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'طلب معاينه معاينه بعد الاصلاح  ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم طلب معاينه بعد الاصلاح لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    } else if (form == 'rightSave') {
      print('-------->>> rightSave');
      String pdf = await PdfController.getPdfBase64(
        pdf: await PdfController.generateStepFnolPdf(
          context: context,
          accidentDetailsModel: accidentDetailsModel!,
          generatePdfStepDto: GeneratePdfStepDto(
            userName: accidentDetailsModel.report?.clientModel?.name ?? '',
            fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
            carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
            insuranceCompany:
                accidentDetailsModel.report?.car?.insuranceCompany?.arName ??
                    '',
            policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
            carManufacturer:
                accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
            carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
            vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
            images: [],
            step: FNOLSteps.rightSave,
          ),
        ),
      );
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '6',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'rightSave',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'طلب معاينه حفظ حق ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم معاينه حفظ حق لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    } else if (form == 'aRepair') {
      print('-------->>> aRepair');
      String pdf = await PdfController.getPdfBase64(
        pdf: await PdfController.generateStepFnolPdf(
          context: context,
          accidentDetailsModel: accidentDetailsModel!,
          generatePdfStepDto: GeneratePdfStepDto(
            userName: accidentDetailsModel.report?.clientModel?.name ?? '',
            fnolNumber: '${accidentDetailsModel.report?.id ?? ''}',
            carPlateNumber: accidentDetailsModel.report?.car?.plateNumber ?? '',
            insuranceCompany:
                accidentDetailsModel.report?.car?.insuranceCompany?.arName ??
                    '',
            policyNumber: accidentDetailsModel.report?.car?.policyNumber ?? '',
            carManufacturer:
                accidentDetailsModel.report?.car?.manufacturer?.name ?? '',
            carModel: accidentDetailsModel.report?.car?.carModel?.name ?? '',
            vinNumber: accidentDetailsModel.report?.car?.vinNumber ?? '',
            images: [],
            step: FNOLSteps.aRepair,
          ),
        ),
      );
      fnolBloc?.sendFnolStepPdf(
        pdfReportId: '3',
        accidentId: report!.id.toString(),
        pdf: pdf,
        type: 'afterRepair',
        carId: accidentDetailsModel.report?.car?.id.toString() ?? '',
        subject:
            'طلب معاينه معاينه بعد الاصلاح  ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''} ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} رقم (${accidentDetailsModel.report?.car?.plateNumber ?? ''}) شاسيه (${accidentDetailsModel.report?.car?.vinNumber ?? ''}) ',
        body:
            'الساده شركه ${accidentDetailsModel.report?.car?.insuranceCompany?.arName ?? accidentDetailsModel.report?.insuranceCompany?.arName ?? ''}'
            '\n'
            'مرسل لكم طلب معاينه بعد الاصلاح لسيارة ${accidentDetailsModel.report?.car?.manufacturer?.arName ?? ''}  ${accidentDetailsModel.report?.car?.carModel?.arName ?? ''} شاسيه ${accidentDetailsModel.report?.car?.vinNumber ?? ''}'
            '\n'
            'يرجي الإطلاع علي المرفقات',
      );
    }
  }*/

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorsManager.white.withOpacity(0.7),
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: ColorsManager.white.withOpacity(0.2),
      insetPadding: EdgeInsets.symmetric(horizontal: 22.rw, vertical: 0),
      content: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(
            height: 360.rh,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 300.rh,
                decoration: BoxDecoration(
                  color: ColorsManager.darkGreyColor,
                  borderRadius: 24.br,
                ),
                child: SizedBox(
                  width: MediaQuery.of(
                          NavigationService.navigatorKey.currentContext!)
                      .size
                      .width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      verticalSpace24,
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyles.bold24,
                      ),
                      verticalSpace12,
                      PrimaryButton(
                        text: LocaleKeys.ok.tr(),
                        horizontalPadding: 12.rw,
                        verticalPadding: 12.rh,
                        onPressed: onPressed ??
                            () {
                              context.pop;
                            },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 56.rw,
            height: 56.rw,
            padding: EdgeInsets.all(8.rw),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManager.darkGreyColor,
            ),
            child: const LoadSvg(
              image: AssetsImages.checkIcon,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}

//*****************************************************************************/
showFnolStepAskDialog(
  context, {
  required String title,
  Function()? onPressed,
  Function()? onNoPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorsManager.white.withOpacity(0.7),
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: ColorsManager.white.withOpacity(0.2),
      insetPadding: EdgeInsets.symmetric(horizontal: 22.rw, vertical: 0),
      content: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(
            height: 400.rh,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 360.rh,
                decoration: BoxDecoration(
                  color: ColorsManager.darkGreyColor,
                  borderRadius: 24.br,
                ),
                child: SizedBox(
                  width: MediaQuery.of(
                          NavigationService.navigatorKey.currentContext!)
                      .size
                      .width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      verticalSpace24,
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyles.bold22,
                      ),
                      verticalSpace12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70.rh,
                            width: 100.rw,
                            child: PrimaryButton(
                              text: LocaleKeys.yes.tr(),
                              horizontalPadding: 12.rw,
                              verticalPadding: 12.rh,
                              onPressed: onPressed ??
                                  () {
                                    context.pop;
                                  },
                            ),
                          ),
                          SizedBox(
                            height: 70.rh,
                            width: 100.rw,
                            child: PrimaryButton(
                              backgroundColor: Colors.red,
                              text: LocaleKeys.no.tr(),
                              horizontalPadding: 12.rw,
                              verticalPadding: 12.rh,
                              onPressed: onNoPressed ??
                                  () {
                                    context.pop;
                                  },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 56.rw,
            height: 56.rw,
            padding: EdgeInsets.all(8.rw),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManager.darkGreyColor,
            ),
            child: const LoadSvg(
              image: AssetsImages.questionIcon,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}

//*****************************************************************************
showPrimaryDialog(
  context, {
  required String title,
  required String content,
  required String buttonTitle,
  Function()? onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorsManager.white.withOpacity(0.7),
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: ColorsManager.darkGreyColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.rw),
      titlePadding:
          EdgeInsetsDirectional.only(top: 10.rh, bottom: 0.rh, start: 20.rw),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.rw, vertical: 14.rh),
      actionsPadding:
          EdgeInsetsDirectional.only(bottom: 14.rh, end: 20.rw, start: 20.rw),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: 24.rSp.br,
      ),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyles.bold24,
      ),
      content: Text(
        content,
        textAlign: TextAlign.start,
        style: TextStyles.regular16,
      ),
      actions: [
        PrimaryButton(
          text: buttonTitle,
          onPressed: onPressed ??
              () {
                context.pop;
              },
        ),
      ],
    ),
  );
}
