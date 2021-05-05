import 'dart:io';

import 'adbhelper.dart';
import 'package:path_provider/path_provider.dart';


class AdbNgrokChecker {

  static Future<bool> checkIfAdbInstalledInDir() async
  {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String identifier = "/";

    if(Platform.isWindows)
      identifier = "\\";

    File file = File("${appDocDir.path}${identifier}adb.exe");
    print('file path is ${file.path}');
    return await file.exists();
  }

  static Future<bool> checkIfNgrokInstalled() async
  {
    return false;
  }
}