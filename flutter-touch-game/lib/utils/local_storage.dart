import 'dart:io';


import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储
class LocalStorage {

  static save(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static get(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  static remove(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

   ///加载缓存
 static Future<String> getCacheSize() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
       
       return renderSize(value);
    
    } catch (err) {
      print(err);
    }
  }
  /// 递归方式 计算文件的大小
  static Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
            int length = await file.length();
            return double.parse(length.toString());
          }
      if (file is Directory) {
            final List<FileSystemEntity> children = file.listSync();
            double total = 0;
            if (children != null)
              for (final FileSystemEntity child in children)
                total += await getTotalSizeOfFilesInDir(child);
            return total;
          }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }
  static void   clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await getCacheSize();
      
    } catch (e) {
      print(e);
       
    } finally {
      //此处隐藏加载loading
    }
  }
  ///递归方式删除目录
  static Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
            final List<FileSystemEntity> children = file.listSync();
            for (final FileSystemEntity child in children) {
              await delDir(child);
            }
          }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  ///格式化文件大小
 static renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

}