import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import '../../flame_Langaw_Game.dart';
import 'flame_hit_effect.dart';
import 'flame_hit_effect_fx.dart';

//一闪特效
class HitEffectFXFlash {
  final Monster fly;
   
  LangawGame game;
  HitEffectFX curHitEffectFx;

  HitEffectFXFlash(this.fly) {
    game = fly.game;
    curHitEffectFx=new HitEffectFX(fly,effectImgPath: 'game/fx_flash.png',duration: 300);
  }
  
}
