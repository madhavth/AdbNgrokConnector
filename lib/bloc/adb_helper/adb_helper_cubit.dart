import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ngrok_connector/AdbDevice.dart';
import 'package:ngrok_connector/adb_helper/adbhelper.dart';
import 'package:process_run/shell.dart';
import 'dart:async';

import 'package:watcher/watcher.dart';

part 'adb_helper_state.dart';

class AdbHelperCubit extends Cubit<AdbHelperState> {
  bool _isProcessing = false;

  bool get isProcessing => this._isProcessing;

  AdbHelperCubit() : super(AdbHelperInitial()) {
    getCurrentDirectory();
    getDevices();
    watchForChangesInUsbDevices();
  }

  getCurrentDirectory() async
  {
    final shell = AdbHelper.getShellInstance();
    print('shell current path is ${shell.path}');
    emit(AdbHelperMessageState("${shell.path}"));
  }

  List<AdbDevice> connectedDevices = [];

  String testFileText = "";

  getDevices() async {
    final list = await AdbHelper.getDeviceConnected();
    connectedDevices = list;
    emit(AdbHelperLoadedState(connectedDevices));
  }

  Timer? timer;

  void watchForChangesInUsbDevices() async {
    timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await getDevices();
    });
    // // var watcher = DirectoryWatcher("/dev",pollingDelay: Duration(seconds: 1));
    // Directory("/dev").watch(events: FileSystemEvent.modify).listen((event) async {
    //   await Future.delayed(Duration(seconds: 1));
    //   await getDevices();
    // });
  }

  Future<void> readFileAndUpdateUi(File file) async {
    var text = await file.readAsString();
    var map = jsonDecode(text);
    testFileText = map['value'].toString();
    emit(TestFileState(testFileText));
  }

  void pressedItem(AdbDevice device) async {
    try {
      _isProcessing = true;
      print('tapping this button');
      await AdbHelper.killNgrok();
      if (!device.deviceName.contains(device.deviceIp)) {
        emit(AdbHelperMessageState("Connecting device by ip"));
        // wifi connected adb device go with the procedure start ngrok forwarding
        final check = await AdbHelper.connectDeviceByIp(device);
        if (!check) return;

        emit(AdbHelperMessageState("connected successfully"));
        await getDevices();
      }

      emit(AdbHelperMessageState("processing..."));
      await startNgrokForward(device);
      _isProcessing = true;
    } catch (e) {
      _isProcessing = false;

      if (e is ShellException) {
        return;
      }
      emit(AdbHelperMessageState("Something went wrong"));
      print('exception $e occurred');
      return;
    }
  }

  @override
  Future<void> close() async {
    timer?.cancel();
    AdbHelper.getShellInstance().kill();
    await super.close();
  }

  Future<void> startNgrokForward(AdbDevice device) async {
    final shell = AdbHelper.getShellInstance();
    await shell.run(
        "${AdbHelper.getNgrokPath()} authtoken 2CAzHxuDB3e9q5UBiA2MA_6TG3rRv1kvwJ2vk7KA2R8");
    await shell.run(
        " ${AdbHelper.getNgrokPath()} tcp ${device.deviceIp}:5555 -region in",
        onProcess: (Process? process) async {
      final shell2 = Shell();
      await Future.delayed(Duration(seconds: 3));
      final data = await shell2.run("curl -s localhost:4040/api/tunnels");
      Map<String, dynamic> map = jsonDecode(data.outText);
      if (map["tunnels"] != null &&
          map["tunnels"].isNotEmpty &&
          map["tunnels"][0]["public_url"] != null) {
        String copyIp = map["tunnels"]?[0]?["public_url"] as String;
        copyIp = copyIp.replaceAll("tcp://", "");
        print(copyIp.toString());
        emit(AdbHelperShowDialogComplete(device, copyIp));
      }
      shell2.kill();
    });
  }

   killNgrok() async {
     await AdbHelper.killNgrok();
     _isProcessing = false;
     emit(AdbHelperMessageState("terminating ngrok session"));
   }
}
