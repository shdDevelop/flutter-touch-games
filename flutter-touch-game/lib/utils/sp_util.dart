import 'dart:async';
import 'dart:convert';

import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
//用于临时数据存储如系统设定等
class SPUtil {
  static SPUtil _spUtil;
  static SharedPreferences prefs;
  static Lock _lock = new Lock();

  SPUtil._();

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<SPUtil> instance() async {
    if (null == _spUtil) {
      await _lock.synchronized(() async {
        if (null == _spUtil) {
          var spUtil = SPUtil._();
          await spUtil._init();
          _spUtil = spUtil;
        }
      });
    }
    return _spUtil;
  }

  static String getString(String key) {
    if (prefs == null) return null;
    return prefs.getString(key);
  }

  static Future<bool> setString(String key, String value) {
    if (prefs == null) return null;
    return prefs.setString(key, value);
  }

  static bool getBool(String key) {
    if (prefs == null) return null;
    return prefs.getBool(key);
  }

  static Future<bool> setBool(String key, bool value) {
    if (prefs == null) return null;
    return prefs.setBool(key, value);
  }

  static int getInt(String key) {
    if (prefs == null) return null;
    return prefs.getInt(key);
  }

  static Future<bool> setInt(String key, int value) {
    if (prefs == null) return null;
    return prefs.setInt(key, value);
  }
  
  
  static double getDouble(String key) {
    if (prefs == null) return null;
    return prefs.getDouble(key);
  }

  static Future<bool> setDouble(String key, double value) {
    if (prefs == null) return null;
    return prefs.setDouble(key, value);
  }

  static List<String> getStringList(String key) {
    return prefs.getStringList(key);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    if (prefs == null) return null;
    return prefs.setStringList(key, value);
  }

  static dynamic getDynamic(String key) {
    if (prefs == null) return null;
    return prefs.get(key);
  }

  static Set<String> getKeys() {
    if (prefs == null) return null;
    return prefs.getKeys();
  }

  static Future<bool> remove(String key) {
    if (prefs == null) return null;
    return prefs.remove(key);
  }

  static Future<bool> clear() {
    if (prefs == null) return null;
    return prefs.clear();
  }
  

  static void setObject<T>(String key, Object value) {
    switch (T) {
      case int:
        setInt(key, value);
        break;
      case double:
        setDouble(key, value);
        break;
      case bool:
        setBool(key, value);
        break;
      case String:
        setString(key, value);
        break;
      case List:
        setStringList(key, value);
        break;
      default:
        setString(key, value == null ? "" : json.encode(value));
        break;
    }
  }
  
}

