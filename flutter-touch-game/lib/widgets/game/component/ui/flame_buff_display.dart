import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_rect_display.dart';

import '../../flame_Langaw_Game.dart';

class MonsterBuffDisplay {
  LangawGame game;
  final Monster monster;
  List<Rect> rects;
  List<RectDisplay> rectDisplays;
  double curWidth;
  double curHeight;
  List<Sprite> lightSpriteList; //动画对象
  double lightSpriteIndex = 0; //怪物当前动画帧
  double initialCheckCD = 0.5; //初始化cd 5秒查看一次是否有已经准备好的技能
  double checkCD; //1秒执行一次

  MonsterBuffDisplay(this.monster, {double width, double height}) {
    game = monster.game;
    if (width == null) {
      curWidth = game.tileSize * 0.3;
    } else {
      curWidth = width;
    }

    if (height == null) {
      curHeight = game.tileSize * 0.3;
    } else {
      curHeight = height;
    }

    rects = new List<Rect>();
    rectDisplays = new List<RectDisplay>();
    initRect();
    checkCD = initialCheckCD / 10;
  }
  void render(Canvas c) {
    if (rectDisplays == null) return;

    for (var lifeRect in rectDisplays) {
      lifeRect.render(c);
    }
  }
 
  void initRect() {
    rectDisplays.clear();
    var hitSkills = monster.skills.where((c) => c.hasBuffIcon == true).toList();
    for (var lifeIndex = 0; lifeIndex < hitSkills.length; lifeIndex++) {
      var isCDReadyNoticeing = hitSkills[lifeIndex].isCDReadyNoticeing;
      var enhence = isCDReadyNoticeing ? 0.1 : 0;
      var titleRect = Rect.fromLTWH(
        monster.flyRect.left-game.tileSize*0.2 +
            monster.flyRect.width  -
            ((lifeIndex + 1) * curWidth),
        monster.flyRect.top -curWidth/2,
        curWidth * (1 + enhence),
        curHeight * (1 + enhence),
      );
      var curSprite =
          new Sprite("game/buff/${hitSkills[lifeIndex].buffSpriteStr}.png");
      rectDisplays
          .add(new RectDisplay(game, rect: titleRect, sprite: curSprite));
    }
  }

  void moveRectByMosnter() {
    var index = 0;
    for (var rectDisplay in rectDisplays) {
      rectDisplay.rect = Rect.fromLTWH(
        monster.flyRect.left-game.tileSize*0.2 +
            monster.flyRect.width  -
            ((index + 1) * curWidth),
        monster.flyRect.top - curWidth/2-monster.hpEffect.hpHeight,
        curWidth,
        curHeight,
      );
      index++;
    }
  }

  void update(double t) {
    checkCD = checkCD - .1 * t;
    if (checkCD <= 0) {
      initRect(); //一秒后才更新
    } else {
      moveRectByMosnter();
    }
    for (var lifeRect in rectDisplays) {
      lifeRect.update(t);
    }
  }
}
