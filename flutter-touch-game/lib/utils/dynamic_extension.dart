import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringExtension {
  //判空获取
  static String nullIfEmpty(
      {dynamic item, String fieldName, String defaultValue = ''}) {
    try {
      if (item != null &&
          item[fieldName] != null &&
          item[fieldName].toString().isNotEmpty) {
        return item[fieldName].toString();
      }
    } catch (ex) {
      print('$ex');
    }
    return defaultValue;
  }

  static Object nullIf(
      {dynamic item, String fieldName, Object defaultValue = null}) {
    try {
      if (item != null && item[fieldName] != null) {
        return item[fieldName];
      }
    } catch (ex) {
      print('$ex');
    }
    return defaultValue;
  }

  //是否url字符串
  static bool isNetUri(String uri) {
    if (uri.isNotEmpty &&
        (uri.startsWith('http://') || uri.startsWith('https://'))) {
      return true;
    }
    return false;
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  /*
  * Md加密
  */
  static String encodeMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  ///获取查询字符串
  static String getUrlParam(String url, String name) {
    Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey(name)) {
      String token = uri.queryParameters[name];
      return token;
    } else {
      return '';
    }
  }

  ///获取查询字符串
  static String urlPathAndQuery(String url) {
    Uri uri = Uri.parse(url);
    var fixUrl = uri.path; //去除框架,ip,端口
    if (uri.query.isNotEmpty) {
      fixUrl += "?${uri.query}";
    }
    return fixUrl;
  }
}
