import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/models/game/game_user_profile.dart';
import 'package:mz_flutterapp_deep/widgets/game/controler/bgm.dart';

import 'enum/flame_enum.dart';
import 'flame_Langaw_Game.dart';
import 'game_widget/game_rank_list.dart';

//消息列表实体，获取数据
class GameCenter extends StatefulWidget {
  GameCenter({Key key}) : super(key: key);

  @override
  GameCenterState createState() => new GameCenterState();
}

class GameCenterState extends State<GameCenter> with WidgetsBindingObserver {
  GameCenterState();
  LangawGame game;
  bool isBGMEnabled = true;
  View currentScreen = View.home;
  //GameService gameService; 上传rank服务器
  List<GameUserProfile> rankList;
  //初始化
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    game = new LangawGame(this);
  //  gameService = new GameService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GameBGM.pause();
    // TODO: implement dispose
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  Widget bgmControlButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: isBGMEnabled ? color_game_icon1 : Colors.grey,
        icon: Icon(
          isBGMEnabled ? Icons.music_note : Icons.music_video,
        ),
        onPressed: () {
           game.audioplayers.button();
          GameBGM.disableSwitch();
          isBGMEnabled=!isBGMEnabled;
          update();
        },
      ),
    );
  }

  Widget helpButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: color_game_icon2,
        icon: Icon(
          Icons.help_outline,
        ),
        onPressed: () {
          game.audioplayers.button();
          if (game.activeView != View.playing) {
            currentScreen = game.activeView;
            currentScreen = View.help;
            //game.activeView = currentScreen;
            update();
          }
        },
      ),
    );
  }

  Widget creditsButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: color_game_icon1,
        icon: Icon(
          Icons.nature_people,
        ),
        onPressed: () {
           game.audioplayers.button();
          if (game.activeView != View.playing) {
            currentScreen = View.credits;
            // game.activeView = currentScreen;
            update();
          }
        },
      ),
    );
  }

  Widget rankButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: color_game_icon2,
        icon: Icon(
          Icons.assistant_photo,
        ),
        onPressed: () {
          game.audioplayers.button();
          showRankView();
        },
      ),
    );
  }

  void showRankView() {
    if (game.activeView != View.playing) {
      // gameService
      //     .getRankList(userGuid: Config.guid, limit: 10, type: 0)
      //     .then((_rankList) {
      //   rankList = _rankList;
      //   currentScreen = View.rank;
      //   update();
      // });
    }
  }

  Widget topControls() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(flex: 1, child: bgmControlButton()),
        currentScreen != View.playing
            ? Expanded(flex: 1, child: helpButton())
            : new Container(),
        currentScreen != View.playing
            ? Expanded(flex: 1, child: creditsButton())
            : new Container(),
        currentScreen != View.playing
            ? Expanded(flex: 1, child: rankButton())
            : new Container(),
        Expanded(flex: 7, child: Container())
      ],
    );
  }

  Widget spacer({int size}) {
    return Expanded(
      flex: size ?? 100,
      child: Center(),
    );
  }

  Widget creditRole(String role, String name, {String handle, String url}) {
    List<Widget> nameHandlePair = List<Widget>();
    nameHandlePair.add(
      Text(
        name,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff032626),
        ),
      ),
    );
    if (handle != null) {
      nameHandlePair.add(
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            handle,
            style: TextStyle(
              color: Color(0xff032626),
            ),
          ),
        ),
      );
    }

    List<Widget> rows = List<Widget>();
    rows.add(
      Text(
        role,
        style: TextStyle(
          color: Color(0xff032626),
        ),
      ),
    );
    rows.add(
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: nameHandlePair,
        ),
      ),
    );
    if (url != null) {
      rows.add(
        Text(
          url,
          style: TextStyle(color: Color(0x88032626)),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Column(children: rows),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      GameBGM.resume();
    } else {
      GameBGM.pause();
    }
  }

  //版主页面
  Widget buildScreenHelp() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(),
          SimpleDialog(
            backgroundColor: Color(0xddffffff),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '食用须知',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff032626),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '尝试点击移动的物品.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff032626),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '如果未点击飞行物三次，或者飞行物计时器超时则失败',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff032626),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '概率出现冰冻与全屏Boom道具，概率出现高分飞行物',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff032626),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '尝试提高连击数combo进行分数提升',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff032626),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: RaisedButton(
                        color: color_game_icon3,
                        child: Text(
                          'Let\'s go!',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          currentScreen = game.activeView;
                          update();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          spacer(),
        ],
      ),
    );
  }

  Widget buildScreenCredits() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(),
          SimpleDialog(
            backgroundColor: Color(0xddffffff),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'org',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff032626),
                      ),
                    ),
                  ),
                  creditRole('Published by', 'MMMY',
                      url: 'https://www.meng-you.com.cn:8001'),
                  creditRole('Code', 'MN',
                      handle: '@MN', url: 'https://www.meng-you.com.cn:8001'),
                  creditRole('Graphics', 'MN',
                      url: 'https://www.meng-you.com.cn:8001'),
                  creditRole('Music', 'null'),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      color: color_game_icon3,
                      child: Text(
                        'Are you OK !',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        currentScreen = game.activeView;
                        update();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          spacer(),
        ],
      ),
    );
  }

  Widget buildScreenRank() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(),
          SimpleDialog(
            contentPadding: EdgeInsets.all(10),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            backgroundColor: Color(0xddffffff),
            children: <Widget>[
              Column(
                children: <Widget>[
                  GameRankList(
                    rankList: rankList,
                  ),
                  RaisedButton(
                    color: color_game_icon3,
                    child: Text(
                      ' OK !',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      currentScreen = game.activeView;
                      update();
                    },
                  ),
                ],
              ),
            ],
          ),
          spacer(),
        ],
      ),
    );
  }

  void didChangeMetrics() {
    game.resize(window.physicalSize / window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    var screenIndex = 0;
    switch (currentScreen) {
      case View.help:
        screenIndex = 0;
        break;
      case View.credits:
        screenIndex = 1;
        break;
      case View.rank:
        screenIndex = 2;
        break;
      case View.playing:
      default:
        screenIndex = -1;
        break;
    }
    List<Widget> stackList = new List<Widget>();
    //当前游戏页面对象
    stackList.add(Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown:(_){
          print('onTapDownstart');
          game.onTapDownStart(_);
           print('onTapDownEnd');
        } ,
        onLongPress: (){

        },
        child: game.widget,
      ),
    ));
    //其他帮助 排行 页面
    if (screenIndex != -1) {
      stackList.add(Positioned.fill(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                children: <Widget>[
                  buildScreenHelp(),
                  buildScreenCredits(),
                  buildScreenRank(),
                ],
                index: screenIndex,
              ),
            )
          ],
        ),
      ));
    }
    //左上角工具栏
    //stackList.add(Positioned.fill(child: topControls(), bottom: 0, top: 0));
    stackList.add(Positioned(
        child: Container(
      child: topControls(),
    )));
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: stackList,
        ),
      ),
    );
  }
}
