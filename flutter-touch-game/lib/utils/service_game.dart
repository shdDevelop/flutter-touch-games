import 'dart:async';
import 'dart:convert';
import 'package:mz_flutterapp_deep/api/net_utils.dart';

import 'package:mz_flutterapp_deep/models/game/game_user_profile.dart';

class GameService {
  GameService();

  String readTimestamp(int timestamp) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    return date.toString();
  }

  //上传用户数据记录
  Future<dynamic> uploadGameUserDataLog(
      {int score,
      int combo,
      int evaluation,
      int monsterHits,
      int gameCost}) async {
   
    GameDataLog gameDatalog = new GameDataLog(
        guid_user_upload: "",
        score: score,
        combo: combo,
        evaluation: evaluation,
        monsterHits: monsterHits,
        gameCost: gameCost);
    if (gameDatalog == null) return null;
    // var location = await getLocacation();
    // if (location != null) {
    //   gameDatalog.locName = location.aoiName;
    //   gameDatalog.lat = location.latitude;
    //   gameDatalog.lng = location.longitude;
    // }

    try {
      var response = await NetUtils.post(
          "${NetUtils.host }", gameDatalog.toJson());
      return response;
    } catch (e) {
      print(e);
    }
  }

  ///获取我的好友列表
  Future<List<GameUserProfile>> getRankList(
      {String userGuid,
      int type = 0,
      double radius = 30,
      int limit = 10}) async {
    if (userGuid == null || userGuid.isEmpty) {
      userGuid ="";
    }
    dynamic postData = {"userGuid": userGuid, "type": type};

    //>0 服务器排名 1好友排名 2区域圈内排名
    switch (type) {
      case 2:
        // var _result = await getLocacation();
        // if (_result != null) {
        //   postData = {
        //     "userGuid": userGuid,
        //     "type": type,
        //     "lng": _result.longitude,
        //     "lat": _result.latitude
        //   };
        // }
        break;
      case 1:
        break;
      case 0:
      default:
        break;
    }
    List<GameUserProfile> gamerUserProfileList = new List<GameUserProfile>();
    try {
      var response = await NetUtils.get(
          "${NetUtils.host + "等级api接口"}", postData);
      if (response["status"] == 0) {
        if (response["data"] != null) {
          List responseJson = json.decode(response["data"]);
          gamerUserProfileList =
              responseJson.map((m) => new GameUserProfile.fromJson(m)).toList();
        }
      } else {
       
      }
    } catch (e) {
      print(e);
    }
    return gamerUserProfileList;
  }

 
}
