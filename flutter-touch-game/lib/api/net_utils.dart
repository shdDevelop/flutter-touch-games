/**
 * created by Huai 2019/3/27 0027
 * 请求
 * GET
 * var response = await NetUtils.get(urlString, params: {'userName':"kangkang",'passWord':20});
 */
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

 

var dio = new Dio();
class NetUtils {
  static final host = "https://www.mn.com.cn"; // 服务器路径
  static final fileUpLoadHost = "https://www.mn.com.cn";


  static init() {
    
  }

  static Future post(String url, data, {Map<String, dynamic> params}) async {
    try {
      var response = await dio.post(url, data: data, queryParameters: params);
      return response.data;
    } catch (ex) {
      print(ex);
    }
    return {};
  }

  static Future<dynamic> jsonPost(String url, data,
      {Map<String, dynamic> params}) async {
    try {
      var response = await dio.post(url, data: data, queryParameters: params);
      return response.data;
    } catch (ex) {
      print(ex);
    }
    return {};
  }

  static Future get(String path, Map<String, dynamic> params) async {
    var response = await dio.get(path, queryParameters: params);
    return response.data;
  }

  static Future downloadFile(String url, String path) async {
    var response = await dio.download(
      url, path,
      options: Options(
          headers: {HttpHeaders.acceptEncodingHeader: "*"}), // disable gzip
    );
    return response;
  }

  static Future postFile(FormData formData) async {
    try {
      var response = await dio.post(fileUpLoadHost, data: formData);
      return response.data;
    } catch (ex) {
      print(ex);
    }
    return {};
  }

  static Future postFiles(List<UploadFileInfo> files) async {
    try {
      FormData formData = new FormData.from({"files": files});
      var response = await dio.post(fileUpLoadHost, data: formData);
      return response.data;
    } catch (ex) {
      print(ex);
    }
    return {};
  }

  static Future postSingleFiles(UploadFileInfo file) async {
    try {
      FormData formData = new FormData.from({"file": file});
      var response = await dio.post(fileUpLoadHost, data: formData);
      return response.data;
    } catch (ex) {
      print(ex);
    }
    return {};
  }
}
