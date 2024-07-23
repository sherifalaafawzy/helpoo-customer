part of 'my_cars_bloc.dart';

@immutable
abstract class MyCarsEvent {}

class GetMyCarsEvent extends MyCarsEvent {}
class HandleIntroEvent extends MyCarsEvent {
  final BuildContext? context;
  HandleIntroEvent({required this.context});
}
