import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

class GameBGM {
  static AudioCache player;
  static bool isPaused = false;
  static bool isInitialized = false;
  static bool disabled=false;
  static List<String> bgmList = new List<String>();
  static List<String> bgmStageClearList = new List<String>();
  static int auidoIndex = 0;
  static Future<void> preload() async {
    player = AudioCache(prefix: 'audio/', fixedPlayer: AudioPlayer());
    await player.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);
    isInitialized = true;
    await loadAuido();
  }

  static Future loadAuido() async {
    bgmList.addAll([
      // 'game/bgm/bgm_god.wav',
      //  'game/bgm/bgm_lobby.wav',
      'game/bgm/sea.wav',
     // 'game/bgm/river.ogg',
      // 'game/bgm/bgm_night.wav',
      //  'game/bgm/bgm_welcome.wav',
      // 'game/bgm/bgm-lukyanov.wav',
    ]);
    //Flame.audio.disableLog();//
    await player.loadAll(bgmList);
    var rnd = new Random();
    auidoIndex = rnd.nextInt(bgmList.length);
  }

  static Future<void> _update() async {
    if (!isInitialized) return;
    bool shouldPlay = !isPaused&&!disabled;
    if (shouldPlay) {
      await player.fixedPlayer.resume();
    } else {
      await player.fixedPlayer.pause();
    }
  }

  static Future<void> play() async {
    await player.loop(bgmList[auidoIndex], volume: .3);
    _update();
  }

  static void pause() {
    isPaused = true;
    _update();
  }

  static void resume() {
    isPaused = false;
    _update();
  }

  static void disableSwitch()
  {
    disabled=!disabled;
    _update();
  }
}
