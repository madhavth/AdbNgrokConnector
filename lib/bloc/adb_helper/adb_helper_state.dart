part of 'adb_helper_cubit.dart';

abstract class AdbHelperState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdbHelperInitial extends AdbHelperState {}

class AdbHelperLoadedState extends AdbHelperState {
  final List<AdbDevice> data;

  AdbHelperLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class AdbHelperMessageState extends AdbHelperState {
  final String message;

  AdbHelperMessageState(this.message);

  @override
  List<Object> get props => [message];
}

class AdbHelperErrorState extends AdbHelperState {
  final error;

  AdbHelperErrorState(this.error);
}

class AdbHelperShowDialogComplete extends AdbHelperState {
  final AdbDevice device;
  final String ip;

  AdbHelperShowDialogComplete(this.device, this.ip);

  @override
  List<Object> get props => [device, ip];
}

class TestFileState extends AdbHelperState {
  final String fileText;

  TestFileState(this.fileText);

  @override
  List<Object> get props {
    return [fileText];
  }
}
