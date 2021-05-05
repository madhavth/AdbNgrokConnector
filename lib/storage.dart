import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _sharedPreferences;

  static SharedPreferences getPreference()
  {
    return _sharedPreferences!;
  }

  static Storage? _instance;

  Storage._();

  factory Storage()
  {
    if(_instance == null)
      {
        _instance = Storage._();
      }

    return _instance!;
  }

  static initSharedPreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }


}