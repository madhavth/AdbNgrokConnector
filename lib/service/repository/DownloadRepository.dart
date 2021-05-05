import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadRepository 
{
  static Dio? _dio;
  static Dio getDioInstance()
  {
    if(_dio == null)
      {
        _dio = Dio();
      }
    
    return _dio!;
  }
  
  static Future<bool> downloadAdb({ProgressCallback? callback}) async
  {
    try {
      final dir = await getAppDocDirectoryAppended("adb.exe");
      await getDioInstance().download("https://file.io/ZticZG8rz5WM","$dir",
      onReceiveProgress: (count,total)
          {
              callback!(count,total);
          },
      );

      return true;
    }
    catch(e)
    {
      print('something went wrong $e');
      return false;
    }
  }

  static Future<String> getAppDocDirectoryAppended(String file) async
  {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String identifier = "/";

    if(Platform.isWindows)
      identifier = "\\";

    return "${appDocDir.path}$identifier$file";
  }
  
}