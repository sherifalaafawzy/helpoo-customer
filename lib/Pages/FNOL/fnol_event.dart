part of 'fnol_bloc.dart';

@immutable
abstract class FnolEvent {}

class InitialFNOLEvent extends FnolEvent {
  final BuildContext? context;

  InitialFNOLEvent({required this.context});
}

class GetLocationFromFnolEvent extends FnolEvent {}
