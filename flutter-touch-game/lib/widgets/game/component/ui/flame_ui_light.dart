 
import 'dart:ui';
import 'package:flame/sprite.dart';

import '../../flame_Langaw_Game.dart';

class UILight {
  final LangawGame game;
    double width;
    double height;
  Rect titleRect;
  Sprite titleSprite;
  List<Sprite> lightSpriteList; //动画对象
  double lightSpriteIndex = 0; //怪物当前动画帧
  UILight(this.game,{this.width,this.height}) {
       if(this.width==null)
       {
         width=game.tileSize *12;
       }
       if(this.height==null)
       {
         height=game.tileSize * 12;
       }
      titleRect = Rect.fromLTWH(
      game.screenSize.width/2-width/2,
      (game.screenSize.height / 2)-(game.tileSize * 9),
      width,
      height,
    );
     
    lightSpriteList=game.resourceManager.lightSpriteList.map((c)=>new Sprite(c)).toList();
    
  }
  void render(Canvas c) {

     titleSprite=lightSpriteList[lightSpriteIndex.toInt()];
     titleSprite.renderRect(c, titleRect);
  }

  void update(double t) {
      lightSpriteIndex += 30 * t/5;
    if (lightSpriteIndex >= lightSpriteList.length) {
      lightSpriteIndex = 0;
    }

  }

  
}  
