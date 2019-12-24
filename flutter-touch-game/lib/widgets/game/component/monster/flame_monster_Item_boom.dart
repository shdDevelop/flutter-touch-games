import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'flame_monster.dart';

class BoomMonster extends Monster {
  BoomMonster({this.game, ItemRare monsterRare}) : super(game: game) {
    flyingSprite = new List<Sprite>();
    flyingSprite.add(new Sprite('game/item_fullScreenAttect.png'));
    deadSprite = new Sprite('game/item_fullScreenAttect.png');
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    rare = monsterRare;
  }
  double get speed => game.tileSize * 4.2;
  bool isItem = true; //是否物品
  final LangawGame game;
  //全灭特效
  @override
  void onHitEffect() async {
    await game.audioplayers.longPressUp();
    Future.delayed(new Duration(milliseconds: 200)).then((_) {
      for (var fly in game.flies) {
        fly.onTapDown(); //被点击操作
      }
    });
  }
}
