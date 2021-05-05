

import 'package:equatable/equatable.dart';

abstract class StartScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class StartScreenInitial extends StartScreenState {}

class StartScreenSatisfiesAllConditions extends StartScreenState {}