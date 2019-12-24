import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_bg_component.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_highscore_display.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_score_display.dart';
import 'package:mz_flutterapp_deep/widgets/game/controler/bgm.dart';
import 'package:mz_flutterapp_deep/widgets/game/controler/flame_audioplayers.dart';

import 'component/monster/boss/flame_monster_user.dart';
import 'component/monster/skills/flame_skill.dart';
import 'component/monster/skills/flame_skill_cd_watcher.dart';
import 'component/ui/flame_combo.dart';
import 'component/ui/flame_finish_view.dart';
import 'component/ui/flame_hit_effect_fx_miss.dart';
import 'component/ui/flame_home_view.dart';
import 'component/ui/flame_life_display.dart';
import 'component/ui/flame_start_button.dart';
import 'component/ui/flame_tower_level_display.dart';
import 'component/ui/util/flame_animation_display.dart';
import 'controler/flame_fly_spawner.dart';
import 'controler/flame_resource_manager.dart';
import 'enum/flame_enum.dart';
import 'flame_game_center.dart';

const int Game_HP_Unit = 100;
const int Game_Att_Unit = 100;

class LangawGame extends BaseGame {
  LangawGame(this.gameCenter) {
    initialize();
  }
  bool isDebugMode = false; //是否调试模式
  final GameCenterState gameCenter;
  Size screenSize;
  Backyard bg;
  double tileSize;
  double screenCenterX;
  double screenCenterY;
  var rnd = Random();
  FlySpawner flySpawner;
  List<Monster> flies;
  View activeView = View.home;
  FinishView finishView;
  HomeView homeView;
  StartButtonView startButton;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;
  GameLifeDisplay gameLifeDisplay;
  Audioplayers audioplayers;
  ResourceManager resourceManager;
  HitEffectMiss hitEffectMiss;
  GameSkill curSKill;
  TowerLevelDisplay towerLevelDisplay;
  GlobalSkillCDWatcher globalSkillCDWatcher;
  List<AnimationDisplay> animationDisplayList;
  UserMonster userMonster;
  // final int initLife = 3;
  int get initLife => userMonster?.initLife;
  int get life => userMonster?.lives; //移动速度;
  set life(int value) {
    userMonster?.lives = value;
    if (value >= initLife) {
      value = initLife;
    }
  }

  List<GameSkill> get userSkills => userMonster?.skills; //用户技能
  double get towerlevelEnhence => 1 + (curTowerLevel - 1) / 10; //等级加成
  int score = 0;
  int maxCombo = 0;
  int combo = 0; //当前连击数
  int monsterHit = 0;
  int curTowerLevel = 1; //根据等级适度怪物的偏移速度，增加血量
  int att = 1 * Game_HP_Unit; //初始攻击力
  DateTime timeStart;
  bool isPlaying = true; //用于防止点到gameObject
  bool isRecordRefresh = false;
  Util flameUtil = Util();
  double monsterSpeedPercent = 0;
  double monsterSpeedSeconds = 0;
  //TapGestureRecognizer tapper;
  //LongPressGestureRecognizer longPresser ;
  HitCombo hitCombo;
  void dispose() {
    if (audioplayers != null) {
      audioplayers.dispose();
    }
    if (flySpawner != null) {
      flies.clear();
      flySpawner.killAll();
    }
    flameUtil = null;
  }

  //项目初始化
  void initialize() async {
    //自定义初始化
    Flame.util.fullScreen();
    Flame.util.setOrientation(DeviceOrientation.portraitUp).then((_) {});
    //tapper.onTapDown = onTapDown;
    // flameUtil.addGestureRecognizer(tapper);
    animationDisplayList = new List<AnimationDisplay>();
    flies = List<Monster>();
    resize(await Flame.util.initialDimensions());
    resourceManager = new ResourceManager(this);
    resourceManager.loadResource();
    bg = new Backyard(game: this);
    flySpawner = new FlySpawner(this); //孵化器
    scoreDisplay = new ScoreDisplay(this);
    highscoreDisplay = new HighscoreDisplay(this);
    audioplayers = new Audioplayers(this);
    hitCombo = new HitCombo(this);
    homeView = new HomeView(this); //主页
    startButton = new StartButtonView(this);
    userMonster = new UserMonster(this);
    globalSkillCDWatcher = new GlobalSkillCDWatcher(this);
    gameLifeDisplay = new GameLifeDisplay(this);
    towerLevelDisplay = new TowerLevelDisplay(this);
    //finishView=new FinishView(this);
  }

  //随机出现的怪物，根据类型出现不同的怪物类型
  void spawnFly() {
    flySpawner?.spawnFly();
  }

  //窗口布局分割
  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    screenCenterX = screenSize.width / 2;
    screenCenterY = screenSize.height / 2;
    super.resize(size);
  }

  ///根据每帧状态更新
  @override
  void update(double t) {
    // TODO: implement update
    flies.forEach((Monster fly) => fly.update(t));
    flies.removeWhere((Monster fly) => fly.isOffScreen);
    flySpawner.update(t);
    hitEffectMiss?.update(t);
    towerLevelDisplay?.update(t);
    switch (activeView) {
      case View.playing:
        scoreDisplay.update(t);
        globalSkillCDWatcher?.update(t); //全局CD计算
        gameLifeDisplay?.update(t);
        userMonster?.update(t); //用户技能定时器

        break;
      case View.finish:
        scoreDisplay.update(t);
        finishView?.update(t);
        break;
      default:
        break;
    }

    if (canShowCombo()) {
      hitCombo.update(t);
    }
    //动画插件更新
    if (animationDisplayList != null) {
      for (var animationDisPlay in animationDisplayList) {
        if (animationDisPlay != null) {
          animationDisPlay.update(t);
        }
      }
    }
  }

  //初始化画布
  @override
  void render(Canvas canvas) {
    if (canvas == null) return;
    // var bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // var paint = new Paint();
    // paint.color = Color(0xff576574);
    // canvas.drawRect(bgRect, paint);
    if (bg != null) {
      bg.render(canvas);
    }
    if (canShowCombo()) {
      hitCombo.render(canvas);
    }
    highscoreDisplay?.render(canvas); //初始化分数页面
    towerLevelDisplay?.render(canvas); //塔等级
    flies.forEach((Monster fly) => fly.render(canvas));
    hitEffectMiss?.render(canvas);

    switch (activeView) {
      case View.home: //首页
        homeView?.render(canvas);
        startButton?.render(canvas);
        break;
      case View.playing: //进行中的画面
        scoreDisplay?.render(canvas);
        // TODO: Handle this case.
        gameLifeDisplay?.render(canvas);
        userMonster?.render(canvas); //用户技能定时器

        break;
      case View.finish: //失败的画面
        if (finishView == null) return;
        finishView.render(canvas);
        startButton.render(canvas);
        break;
      default:
        break;
    }
    //动画插件更新
    if (animationDisplayList != null) {
      for (var animationDisPlay in animationDisplayList) {
        if (animationDisPlay != null) {
          animationDisPlay.render(canvas);
        }
      }
    }
  }

  //用户点击触发
  void onTapDownStart(TapDownDetails tapDown) {
    switch (activeView) {
      case View.playing:
        if (isPlaying == true) {
          _onPlayingTapDown(tapDown);
        }
        break;
      //其他页面
      case View.home:
      case View.finish:
        if (highscoreDisplay.treasureRect.contains(tapDown.globalPosition)) {
          gameCenter?.showRankView();
          return;
        }
        if (startButton.rect.contains(tapDown.globalPosition)) {
          startButton.onTapDown(tapDown);
          return;
        }

        break;
      case View.help:
      case View.credits:
      default:
        break;
    }
  }

  //用户长按点击触发
  void onLongPressDown() {
    if (activeView == View.playing && isPlaying) {
      _onPlayingLongPress();
    }
  }

  //用户长按点击触发
  void onLongPress() {
    audioplayers.longPress();
  }

  //游戏进程中进行点击操作
  void _onPlayingTapDown(TapDownDetails tapDown) {
    var didHitAFly = true;

    for (var index = 0; index <= flies.length - 1; index++) {
      var fly = flies[index];
      if (fly.flyRect.contains(tapDown.globalPosition)) {
        fly.onTapDown(); //被点击操作
        //spawnFly(); //生产新的苍蝇
        didHitAFly = false;
      }
    }
    //没有点击到对象啊那个
    if (didHitAFly) {
      audioplayers.loseHit();
      hitEffectMiss = new HitEffectMiss(
          game: this,
          touchPoint:
              Offset(tapDown.globalPosition.dx, tapDown.globalPosition.dy));
      loseLife();
      combo = 0;
      //changeView(View.lost);
    } else {
      gameSpeedAll(); //游戏节奏加速
    }
  }

  //游戏进程中进行长按操作
  void _onPlayingLongPress() async {
    await audioplayers.longPressUp();
    Future.delayed(new Duration(milliseconds: 200)).then((_) {
      for (var fly in flies) {
        fly.onTapDown(); //被点击操作
      }
    });
  }

  //切换页面单进程使用
  void changeView(View view) {
    switch (view) {
      case View.playing:
        isPlaying = true;
        //延迟播放
        GameBGM.resume();
        break;
      case View.finish:
        finishView = new FinishView(this);
        isPlaying = false;
        audioplayers.finishStage();
        GameBGM.pause();
        break;
      case View.home:
        isPlaying = false;
        GameBGM.pause();
        break;
      case View.help:
      case View.credits:
      case View.rank:
        break;
      default:
        break;
    }
    activeView = view;
    if (gameCenter != null) {
      gameCenter.currentScreen = view;
      gameCenter.update();
    }
  }

  //是否展示combo
  bool canShowCombo() {
    return combo >= 2;
  }

  //随着游戏进程增加加大monster的速度,负值为加速
  //没增加20只速度增加0.1,或者每打败一直精英怪，boss 速度提升
  //该属性为减慢，为负数的时候则为增加
  void gameSpeedAll({double enhence = 0.1}) {
    if (monsterHit >= 20 && monsterHit % 20 == 0) {
      this.monsterSpeedPercent += enhence; //怪物移动加速
      flySpawner.spawnSpeed(enhence: 1); //生产加速
    }
  }

  void nextLevel() {
    curTowerLevel++;
  }

  //减少生命
  void loseLife() {
    if (life < 0) return;
    life -= 1;
    if (userMonster.curHp <= 0) {
      return;
    }
    userMonster.underAttacked(damage: (userMonster.initHp * 0.34).toInt());
    if (userMonster.curHp < 0) {
      life = 0;
    }
    gameLifeDisplay?.loseLife();
    if (life == 0) {
      changeView(View.finish);
    }
  }

  //连击数递增
  void comboIncrease() {
    combo++;
    if (combo >= maxCombo) {
      maxCombo = combo;
    }
  }

  //获取mp增加，通过点击monster增加
  void userIncreaseMp() {
    userMonster.curMp += getMpAdditional();
    if (userMonster.curMp >= userMonster.initHp) {
      userMonster.curMp = 0;
      //生成主动攻击技能图标；
      flySpawner.generateSkillItemRnd();
    }
  }

  int getMpAdditional() {
    var mpAdditional = 3;
    var comboAdditonal = combo * 0.1;
    mpAdditional += comboAdditonal.toInt();
    return mpAdditional;
  }

  //怪物被成功击杀后
  void monsterKilled(Monster monster) {
    comboIncrease(); //连击数增加
    audioplayers.successKill();
    score += monster.getFinalScore(); //得分更新
    monsterHit++;
    var highSocre = SPUtil.getInt('highscore') ?? 0;
    if (score > highSocre) {
      SPUtil.instance().then((_) {
        SPUtil.setInt('highscore', score);
        highscoreDisplay.updateHighscore();
      });
    }
    flySpawner.monsterKilled(monster);
  }

  //子弹时间触发,理论上子弹时间影响死亡触发特效，后续修改整体speed值
  Future bulletTime({int seconds = 5, speedPercent = -0.9}) async {
    monsterSpeedPercent = speedPercent; //减速80%
    //10秒后恢复
    await Future.delayed(new Duration(seconds: seconds)).then((_) {
      monsterSpeedPercent = 0;
    });
  }

  //初始化启动
  void initialStart() {
    activeView = View.playing;
    flySpawner.start(); //清理并重新启动
    gameLifeDisplay = new GameLifeDisplay(this);
    score = 0;
    combo = 0;
    maxCombo = 0;
    userMonster = new UserMonster(this);
    isRecordRefresh = false;
    monsterSpeedPercent = 0;
    monsterHit = 0;
    timeStart = DateTime.now();
    att = Game_Att_Unit;
    animationDisplayList = new List<AnimationDisplay>();
    buffRest(); //buff重置
    GameBGM.resume();
  }

  //buff重置
  void buffRest() {
    userSkills.clear();
  }
}
