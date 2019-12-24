 
import 'dart:ui';
import 'package:flame/sprite.dart';

import '../../flame_Langaw_Game.dart';

class HomeView {
  final LangawGame game;
  Rect titleRect;
  Sprite titleSprite;

  HomeView(this.game) {
    titleRect=Rect.fromLTWH(game.tileSize, game.screenSize.height/2-game.tileSize*4, game.tileSize*7, game.tileSize*4);
    //titleSprite=new Sprite('game/title.png');
  }
  void render(Canvas c) {

   // titleSprite.renderRect(c, titleRect);
  }

  void update(double t) {}

  
}  
