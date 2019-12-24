import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/models/game/game_user_profile.dart';


class RankItem extends StatefulWidget {
  RankItem({this.gameUserProfile, @required this.rank, this.textStyle});
  final GameUserProfile gameUserProfile;
  final int rank;
  final TextStyle textStyle;
  @override
  _RankItemState createState() =>
      new _RankItemState(gameUserProfile: gameUserProfile);
}

class _RankItemState extends State<RankItem> {
  _RankItemState({
    this.gameUserProfile,
  });

  final GameUserProfile gameUserProfile;

  ///消息体
  Widget userProfileDetail(BuildContext context) {
    //var picUrl =  "";//用户头像
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: new Text(
                gameUserProfile.rank != null
                    ? gameUserProfile.rank.toString()
                    : widget.rank != null ? widget.rank.toString() : '',
                style: widget.textStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                var userGuid = gameUserProfile.guid_user_upload;
                // if (userGuid.isNotEmpty) {
                //   Navigator.push(context,
                //       new MaterialPageRoute(builder: (BuildContext context) {
                //     return new UserDetailPage(userGuid);
                //   }));
                // }
              },
              child: Container(
                alignment: Alignment.center,
                //  margin: EdgeInsets.all(ScreenUtil().setSp(5)),
                child: new CircleAvatar(
                  backgroundImage: new AssetImage(portrait_girl),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child:
                  new Text(gameUserProfile.userName, style: widget.textStyle),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: new Text(gameUserProfile.score_max.toString(),
                  style: widget.textStyle),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.rank % 2 == 1
          ? color_game_item_interlacingBg1
          : color_game_item_interlacingBg2,
      child: new Column(
        children: <Widget>[
          userProfileDetail(context),
          //评论搜肠
          new Container(
            child: new Divider(height: 1, color: Colors.transparent),
          )
        ],
      ),
    );
  }
}
