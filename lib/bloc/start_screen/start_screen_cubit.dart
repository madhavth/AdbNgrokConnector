import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'start_screen_state.dart';

class StartScreenCubit extends Cubit<StartScreenState> {
  StartScreenCubit() : super(StartScreenInitial());
}
