import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:mz_flutterapp_deep/widgets/game/controler/bgm.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:synchronized/synchronized.dart';

import '../flame_Langaw_Game.dart';
///主要用于播放动作一次性播放
class Audioplayers {
  final LangawGame game;
  // AudioPlayer finishBGM;
  AudioPlayer playingBGM;
  static Lock _lock = new Lock();
  Audioplayers(this.game) {
    start();
  }

  Future start() async {
    //playPlayingBGM();
  }
 
  //没点到monster
  void loseHit() async {
    await playMusic('game/sfx/sfx_loseHit.wav', volume: 0.5);
  }

  //成功击杀
  void successKill() async {
    await playMusic('game/sfx/sfx_refresh.wav', volume: 0.7);
  }
  //精英怪成功击杀
  void successElitKill() async {
    await playMusic('game/sfx/sfx_hit_3.wav', volume: 0.7);
  }
  
   //成功点到monster
  void successHit() async {
    await playMusic('game/sfx/sfx_hit_' +
        (game.rnd.nextInt(2)+1).toString() +
        '.wav');
  }
  //怪物消失
  void monsterFail() async {
    //  await playMusic('game/sfx/sfx_monster_die.wav', volume: 0.2);
  }

  //怪物出现
  void monsterAppear() {
    // playMusic('game/sfx/sfx_water_appear_' +
    //     (game.rnd.nextInt(2)).toString() +
    //     '.wav');
  }

  //长按
  Future longPress() async {
    playMusic('game/sfx/sfx_long_press.wav');
  }

  //长按
  Future longPressUp() async {
    playMusic('game/sfx/sfx_long_press_up.wav');
  }

  //结束场景
  void finishStage() async {
    await playMusic('game/sfx/sfx_stage_clear_' +
        (game.rnd.nextInt(4)).toString() +
        '.wav');
  }

  //按钮
  void button() async {
    await playMusic('game/sfx/sfx_button.wav');
  }

  //按钮
  void buttonBack() async {
    await playMusic('game/sfx/sfx_button_back.wav');
  }

  //按钮
  void buttonCancel() async {
    await playMusic('game/sfx/sfx_button_cancel.wav');
  }

  //按钮
  Future buttonComfirm() async {
    await playMusic('game/sfx/sfx_button_confirm.wav');
  }

  //按钮
  void buttonSwitch() async {
    await playMusic('game/sfx/sfx_button_switch.wav');
  }
 
  //防护罩
  void shield() async {
    await playMusic('game/sfx/sfx_shield.wav');
  }

    //防护罩破碎
  void shieldCrash() async {
    await playMusic('game/sfx/sfx_shield_crash.wav');
  }

   //警告
  void warning() async {
    await playMusic('game/sfx/sfx_warning.wav');
  }
  
  //升级
  void charactorLevelUp() async {
    await playMusic('game/sfx/sfx_cha_levelup.wav');
  }

  //刷新此处音效有点问题，去掉后不会闪退，建议只使用一种尝试
  void getItem({ItemRare itemType = ItemRare.normal}) async {
    var soundPah = 'game/sfx/sfx_getItem_0.wav';
    switch (itemType) {
      case ItemRare.legend:
        soundPah = 'game/sfx/sfx_getItem_2.wav'; //可能是闪退的原因 2放弃
        break;
      case ItemRare.rare:
        soundPah = 'game/sfx/sfx_getItem_1.wav';
        break;
      case ItemRare.normal:
      default:
        soundPah = 'game/sfx/sfx_getItem_0.wav';
        break;
    }
    await playMusic(soundPah);
  }

  //刷新
  void refresh() async {
    await playMusic('game/sfx/sfx_refresh.wav');
  }

  //长按
  Future freezen() async {
    playMusic('game/sfx/sfx_ice_blow.wav');
  }
  //状态
  Future stun() async {
    await playMusic('game/sfx/sfx_state_stun.wav');
  }
   //技能发动
  Future skillStart() async {
    await playMusic('game/sfx/sfx_skill_start.wav');
  }
  
   Future bleeding() async {
    await playMusic('game/sfx/sfx_state_bleeding.wav');
  }
   //技能发动
  Future poison() async {
    await playMusic('game/sfx/sfx_state_poison.wav');
  }
   //状态提升
  Future powerUp() async {
    await playMusic('game/sfx/sfx_state_powerup.wav');
  }
   //治疗
  Future heal() async {
    await playMusic('game/sfx/sfx_state_heal.wav');
  }
    //解锁
  Future unlock() async {
    await playMusic('game/sfx/sfx_unlock.wav');
  }
  
  Future<void> playMusic(String path, {dynamic volume = 0.9}) async {
    if(path==null||path.isEmpty)
    {
      return;
    }
    if(GameBGM.disabled&&game.activeView==View.playing)
    {
      return  ;
    }
    print('开始播放$path');
    await _lock.synchronized(() async {
      try {
         await Flame.audio.play(path, volume: volume).catchError((onError){
           print('$onError');
         });
        await Future.delayed(Duration(milliseconds: 100));
        print('结束播放$path');
      } catch (ex) {
        print(ex);
      }
    });
    
  }

  //没5秒生成一致
  void update(double t) {}

  void dispose() {
    // if (finishBGM != null) {
    //   finishBGM.stop();
    // }
    if (playingBGM != null) {
      playingBGM.stop();
    }
  }
}
