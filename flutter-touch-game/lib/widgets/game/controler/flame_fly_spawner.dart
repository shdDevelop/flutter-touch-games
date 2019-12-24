import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/boss/flame_monster_boss.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_blood_rush.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_boom.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_freezen.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_heart.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_poison.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_powerup.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_Item_random.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster_mood.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../flame_Langaw_Game.dart';

///生产怪物的控制器
class FlySpawner {
  final LangawGame game;
  bool spawning = false;
  int maxSpawnInterval = 2000; //最慢速度
  int minSpawnInterval = 550; //默认250最快速度
  int intervalChange = 4; //出怪速度
  int maxMonstersOnScreen = 5; //怪物总量
  int maxTotalMonsters = 10; //怪物总量
  int maxElitOnScreen = 2; //当前屏幕可出现的精英数量
  int curElitCount = 0;
  int maxBossOnScreen = 1; //可出现的boss数量
  int curBossCount = 0;
  int currentInterval;
  int nextSpawn;
  bool isElitAvaiable = false;
  bool isBossAvaiable = false;
  int elitAppearMonsterHit = 10; //精英出现条件20
  int bossAppearMonsterHit = 30; //boss出现条件50
  FlySpawner(this.game) {
    start();
  }
  // 开始
  void start() {
    if (game.isDebugMode) {
      elitAppearMonsterHit = 4;
      bossAppearMonsterHit = 5;
    }
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
    spawning = true;
    game.monsterHit = 0;
    curElitCount = 0;
    curBossCount = 0;
    isElitAvaiable = false;
    isBossAvaiable = false;
    spawnFly();
  }

  bool onBossBattleMode() {
    if (curBossCount == 1) {
      return true;
    }
    return false;
  }

  //随机出现的怪物，根据类型出现不同的怪物类型
  void spawnFly() {
    if (curBossCount < maxBossOnScreen && isBossAvaiable) {
      game.flies.add(BossMonster(game: game, monsterRare: ItemRare.legend));
      curBossCount++;
      isBossAvaiable=false;
      return;
    }
    if (curElitCount < maxBossOnScreen && isElitAvaiable) {
      game.flies.add(ElitMonster(game: game, monsterRare: ItemRare.rare));
      curElitCount++;
      isElitAvaiable = false;
      return;
    }

    //精英怪触发
    var flyType = game.rnd.nextInt(100000);
    ItemRare itemType = ItemRare.normal;
    if (flyType >= 70000) //默认80000
    {
      itemType = ItemRare.legend;
    }
    MoodMonster curMonster;
    switch (itemType) {
      case ItemRare.normal:
        curMonster = MoodMonster(game: game, monsterRare: itemType);
        break;
      case ItemRare.legend:
        //连击数高的时候增加boomb概率
        var rndType = game.rnd.nextInt(100) + game.combo ~/ 100;
        if (rndType >= 50) {
          //随机生成道具
          generateItemRnd();
        } else {
          curMonster = MoodMonster(game: game, monsterRare: ItemRare.legend);
        }
        break;
      default:
        curMonster = MoodMonster(game: game, monsterRare: itemType);
        break;
    }

    //boss模式不出小飞行物
    if (onBossBattleMode()) {
      return;
    }
    if (curMonster != null) {
      game.flies.add(curMonster);
    }
  }
  //mp生成主动技能
  void generateItemRnd() {
    var itemList = new List<String>();
    itemList.add("BoomMonster");
    itemList.add("FreezenMonster");
    itemList.add("HeartItemMonster");
    itemList.add("PowerUpItemMonster");
    itemList.add("PoisonItemMonster");
    itemList.add("RandomMonster");

    //随机道具
    var itemRnd = game.rnd.nextInt(itemList.length);
    var itemName = itemList[itemRnd];
    switch (itemName) {
      case "BoomMonster":
        game.flies.add(BoomMonster(game: game));
        break;
      case "FreezenMonster":
        game.flies.add(FreezenMonster(game: game));
        break;
      case "PowerUpItemMonster":
        game.flies.add(PowerUpItemMonster(game: game));
        break;
        break;
      case "HeartItemMonster":
        game.flies.add(HeartItemMonster(game: game));
        break;
      case "PoisonItemMonster":
        game.flies.add(PoisonItemMonster(game: game));
        break;
      case "RandomMonster":
        game.flies.add(RandomMonster(game: game));
        break;

      default:
        break;
    }
    if (game.isDebugMode) {
      game.flies.add(RandomMonster(game: game));
    }
  }
  //执行技能
  void generateSkillItemRnd() {
     game.flies.add(BloodRushSkillMonster(game: game));
    
  }

  ///删除所有的怪物
  void killAll() {
    game.flies.clear();
    //  game.flies.forEach((Monster fly) {fly.isDead = true; });
    spawning = false;
  }

  //每5秒生成一只
  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp > nextSpawn && game.flies.length < maxMonstersOnScreen) {
      game.spawnFly();
      game.audioplayers.monsterAppear();
      //时间判定每5秒生成一只，游戏越来越快
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }

  //游戏加速
  void spawnSpeed({int enhence = 1}) {
    if (maxMonstersOnScreen <= maxTotalMonsters) {
      maxMonstersOnScreen += enhence;
    }
  }

  //怪物击杀后
  void monsterKilled(Monster monster) {
    if (monster is ElitMonster) {
      curElitCount--;
    }
    if (monster is BossMonster) {
      curBossCount--;
    }
    if (curElitCount < maxElitOnScreen &&
        game.monsterHit > 0 &&
        game.monsterHit % elitAppearMonsterHit == 0) {
      isElitAvaiable = true;
    }
    if (curBossCount < maxBossOnScreen &&
        game.monsterHit > elitAppearMonsterHit &&
        game.monsterHit % bossAppearMonsterHit == 0) {
      isBossAvaiable = true;
    } 
  }
}
