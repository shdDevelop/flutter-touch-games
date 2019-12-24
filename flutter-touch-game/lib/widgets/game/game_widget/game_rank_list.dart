import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/models/game/game_user_profile.dart';

import 'game_rank_Item.dart';

//消息列表实体，获取数据
class GameRankList extends StatefulWidget {
  GameRankList({Key key, this.rankList}) : super(key: key);
  final List<GameUserProfile> rankList;
  @override
  _GameRankListState createState() => new _GameRankListState();
}

class _GameRankListState extends State<GameRankList> {
  _GameRankListState();

  TextStyle titleStyle;
  TextStyle columnStyle;

  //初始化
  @override
  void initState() {
    super.initState();
    Shadow shadow = Shadow(
      blurRadius: 3,
      color: color_game_text,
    );
    titleStyle = new TextStyle(
        color: color_game_text,
        fontSize: 50,
        shadows: [shadow, shadow, shadow, shadow]);

    columnStyle =
        new TextStyle(color: color_game_text, fontSize: 15, shadows: <Shadow>[
      Shadow(
        blurRadius: 7,
        color: color_game_shadow,
        offset: Offset(3, 3),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = new List<Widget>();
    // widgetList.add(Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: <Widget>[
    //       Text('排名', style: columnStyle),
    //       Text('头像', style: columnStyle),
    //       Text('昵称', style: columnStyle),
    //       Text('分数', style: columnStyle),
    //     ]));
    widgetList.add((new Divider(height: 1, color: Colors.transparent)));
    //添加排行对象
    if (widget.rankList != null && widget.rankList.length > 0) {
      widgetList.addAll(widget.rankList.map(
        (c) {
          var index = widget.rankList.indexOf(c);
          return new RankItem(
              gameUserProfile: c, rank: index + 1, textStyle: columnStyle);
        },
      ).toList());
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
      child: Container(
        color: color_game_inner,
        
        padding: EdgeInsets.all(10),
        child: Column(
          children: widgetList,
        ),
      ),
    );
  }
}
