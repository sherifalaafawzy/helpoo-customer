part of 'fnol_bloc.dart';

@immutable
abstract class FnolState {}

class FnolInitial extends FnolState {}

class CreateFnolLoading extends FnolState {}

class SendFnolStepPdfLoading extends FnolState {}

class CreateFnolSuccess extends FnolState {}

class SendFnolStepPdfSuccess extends FnolState {}

class ChangeBillTime extends FnolState {}

class ChangeLocationState extends FnolState {}

class UpdateFnolAdditionalFieldsLoading extends FnolState {}

class UpdateFnolAdditionalFieldsSuccess extends FnolState {}

class UpdateFnolAdditionalFieldsError extends FnolState {
  final String error;

  UpdateFnolAdditionalFieldsError({
    required this.error,
  });
}

class CreateFnolError extends FnolState {
  final String error;

  CreateFnolError({
    required this.error,
  });
}

class SendFnolStepPdfError extends FnolState {
  final String error;

  SendFnolStepPdfError({
    required this.error,
  });
}

class UpdateFnolCommentAndVoiceStart extends FnolState {}

class UpdateFnolCommentAndVoiceLoading extends FnolState {}

class UpdateFnolCommentAndVoiceSuccess extends FnolState {}

class UpdateFnolCommentAndVoiceError extends FnolState {
  final String error;

  UpdateFnolCommentAndVoiceError({
    required this.error,
  });
}

class UpdateFnolStepLocationLoading extends FnolState {}

class UpdateFnolStepLocationSuccess extends FnolState {}

class UpdateFnolStepLocationError extends FnolState {
  final String error;

  UpdateFnolStepLocationError({
    required this.error,
  });
}

class UpdateFnolBillLoading extends FnolState {}

class UpdateFnolBillSuccess extends FnolState {}

class UpdateFnolBillError extends FnolState {
  final String error;

  UpdateFnolBillError({
    required this.error,
  });
}

class CapturedImageAdded extends FnolState {}

class HandleFnolImagesLists extends FnolState {}

class UploadAdditionalImagesSuccess extends FnolState {}

class GetRequiredImagesTagsLoading extends FnolState {}

class GetRequiredImagesTagsSuccess extends FnolState {}

class GetRequiredImagesTagsError extends FnolState {
  final String error;

  GetRequiredImagesTagsError({
    required this.error,
  });
}

class GetAllAccidentTypesLoading extends FnolState {}

class GetAllAccidentTypesSuccess extends FnolState {}

class GetAllAccidentTypesError extends FnolState {
  final String error;

  GetAllAccidentTypesError({
    required this.error,
  });
}

class AccidentTypeRemoved extends FnolState {}

class AccidentTypeAdded extends FnolState {}

class NextImage extends FnolState {}

class AllImagesCaptured extends FnolState {}

class CameraError extends FnolState {
  final String error;

  CameraError({
    required this.error,
  });
}

class CameraInitialized extends FnolState {}

class FlashOn extends FnolState {}

class FlashOff extends FnolState {}

class ImagePicked extends FnolState {}

class ImagesPicked extends FnolState {}

class TakeImageRender extends FnolState {}

class TakePictureLoading extends FnolState {}

class TakePictureSuccess extends FnolState {}

class TakePictureError extends FnolState {
  final String error;

  TakePictureError({
    required this.error,
  });
}

class DonaCameraImagesTaked extends FnolState {}

class UploadImagesLoading extends FnolState {}

class UploadImagesSuccess extends FnolState {}

class UploadImagesError extends FnolState {
  final String error;

  UploadImagesError({
    required this.error,
  });
}

class RetakeFnolImage extends FnolState {}

class GetLocationFnolDone extends FnolState {}

class GetLocationFnolLoadingState extends FnolState {}

class GetLocationFnolErrorState extends FnolState {}

class DoneAllCameraFnolImageUpload extends FnolState {}

class uploadFnolImageErrorState extends FnolState {
  final String error;

  uploadFnolImageErrorState({
    required this.error,
  });
}

class RenderBillDeliveryFinalData extends FnolState {}

class FNOLSetMapControllerSuccess extends FnolState {}

class FNOLGetLocationDone extends FnolState {}

class FNOLGetLocationLoading extends FnolState {}

class IsSentChanged extends FnolState {}

class AccidentDetailsLoading extends FnolState {}

class AccidentDetailsSuccess extends FnolState {
  final String from;

  AccidentDetailsSuccess({
    required this.from,
  });
}

class AccidentDetailsError extends FnolState {
  final String error;

  AccidentDetailsError({
    required this.error,
  });
}
