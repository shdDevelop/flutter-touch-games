class GameUserProfile {
  final String guid;
  final String guid_user_upload;
  final String userName;
  final String headPicGuid;
  final String guid_game_new;
  final String locName;
  final double lng;
  final double lat;
  final int score_max;
  final int combo_max;
  final int evaluation_max;
  final int monsterHits_max;
  final int gameTimes;
  final int gameCost;
  final int rankUP;
  final int rank;
  GameUserProfile(
      this.guid,
      this.guid_user_upload,
      this.userName,
      this.headPicGuid,
      this.guid_game_new,
      this.locName,
      this.lng,
      this.lat,
      this.score_max,
      this.combo_max,
      this.evaluation_max,
      this.monsterHits_max,
      this.gameTimes,
      this.gameCost,
      this.rankUP,
      this.rank);

  GameUserProfile.fromJson(Map<String, dynamic> json)
      : guid = json['guid'] == null ? "" : json['guid'],
        userName = json['userName'] == null ? "" : json['userName'],
        headPicGuid = json['headPicGuid'] == null ? "" : json['headPicGuid'],
        guid_user_upload =
            json['guid_user_upload'] == null ? "" : json['guid_user_upload'],
        guid_game_new =
            json['guid_game_new'] == null ? "" : json['guid_game_new'],
        locName = json['locName'] == null ? "" : json['locName'],
        lng = json['loc'] == null ? 0 : json['loc'][0],
        lat = json['loc'] == null ? 0 : json['loc'][1],
        score_max = json['score_max'] == null ? 0 : json['score_max'],
        combo_max = json['combo_max'] == null ? 0 : json['combo_max'],
        evaluation_max =
            json['evaluation_max'] == null ? 0 : json['evaluation_max'],
        monsterHits_max =
            json['monsterHits_max'] == null ? 0 : json['monsterHits_max'],
        gameTimes = json['gameTimes'] == null ? 0 : json['gameTimes'],
        gameCost = json['gameCost'] == null ? null : json['gameCost'],
        rankUP = json['rankUP'] == null ? 0 : json['rankUP'],
        rank = json['rank'] == null ? null : json['rank'];

}

class GameDataLog {
  String guid;
  String guid_user_upload;
  String locName;
  double lng;
  double lat;
  int score;
  int combo;
  int evaluation;
  int monsterHits;
  int gameCost;

  GameDataLog(
      {this.guid,
      this.guid_user_upload,
      this.locName,
      this.lng,
      this.lat,
      this.score,
      this.combo,
      this.evaluation,
      this.monsterHits,
      this.gameCost});

  GameDataLog.fromJson(Map<String, dynamic> json)
      : guid = json['guid'] == null ? "" : json['guid'],
        guid_user_upload =
            json['guid_user_upload'] == null ? "" : json['guid_user_upload'],
        locName = json['locName'] == null ? "" : json['locName'],
        lng = json['loc'] == null ? 0 : json['loc'][0],
        lat = json['loc'] == null ? 0 : json['loc'][1],
        score = json['score'] == null ? 0 : json['score'],
        combo = json['combo'] == null ? 0 : json['combo'],
        evaluation = json['evaluation'] == null ? 0 : json['evaluation'],
        monsterHits = json['monsterHits'] == null ? 0 : json['monsterHits'],
        gameCost = json['gameCost'] == null ? null : json['gameCost'];

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'guid_user_upload': guid_user_upload,
        'locName': locName,
        'loc': [lng, lat],
        'score': score,
        'combo': combo,
        'evaluation': evaluation,
        'monsterHits': monsterHits,
        'gameCost': gameCost
      };
}
