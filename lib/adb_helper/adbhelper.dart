import 'package:process_run/shell.dart';

import '../AdbDevice.dart';

class AdbHelper {

  static Shell? _shellInstance;

  static Shell getShellInstance()
  {
    if(_shellInstance==null)
      {
        _shellInstance = Shell();
      }

    return _shellInstance!;
  }

  static Future<List<AdbDevice>> getDeviceConnected() async
  {
    Shell shell = getShellInstance();
    List<AdbDevice> devices=[];
    final op = await shell.run("assets/linux/adb devices");
    if(op.isNotEmpty && op.first.errText == "" && op.first.exitCode == 0)
      {
        devices= await parseDevices(op.first.outText);
      }

    return devices;
  }

  static Future<List<AdbDevice>> parseDevices(String devices) async
  {
    List<AdbDevice> myDevices = [];
    List<String> deviceList= devices.split("\n");
    if(deviceList.isNotEmpty)
      {
        deviceList.removeAt(0); // removes List of devices attached
        deviceList.removeWhere((element) => element.isEmpty);

        for(var element in deviceList)
          {
            final temp = element.split("\t");

            if(temp.isNotEmpty)
            {
              String? deviceIp = await getDeviceIp(temp.first);
              if(deviceIp!=null)
                myDevices.add(AdbDevice(temp.first, deviceIp));
            }
          }
      }

    print(myDevices);
    return myDevices;
  }

  static Future<String?> getDeviceIp(String deviceName) async
  {
    try {
      Shell shell = getShellInstance();
      final ip = await shell.run(
          "assets/linux/adb -s $deviceName shell ip route");

      final tempList = ip.outText.split(" ");

      return tempList[tempList.length-2];
    }
    catch(e)
    {
      print('exception $e occurred');
      return null;
    }
  }
  
  static Future<bool> connectDeviceByIp(AdbDevice device) async
  {
    final shell = getShellInstance();
    final cmd = await shell.run("assets/linux/adb -s ${device.deviceName} tcpip 5555");
    await Future.delayed(Duration(seconds: 1));
    final last = await shell.run("assets/linux/adb connect ${device.deviceIp}:5555");
    if(last.errText=="")
      {
        return true;
      }

    return false;
  }


  
  static Future<bool> killNgrok() async
  {
    try {
      final shell = Shell();
      final cmd = await shell.run("pidof ngrok");

      if (cmd.errText == "") {
        final kill = await shell.run("kill ${cmd.outText}");
        if (kill.errText != "") {
          return true;
        }
      }
    }
    catch(e)
    {
      return false;
    }

    return false;
  }
}