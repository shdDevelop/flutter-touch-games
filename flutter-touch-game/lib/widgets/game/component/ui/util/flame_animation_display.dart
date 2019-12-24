import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/animation.dart' as flame_animation;
import '../../../flame_Langaw_Game.dart';

//动图图片举行位置
class AnimationDisplay {
  final LangawGame game;

  Rect rect;
  Rect curRect;
  double width;
  double height;

  Offset offset;
  AnimationComponent animationComponent;
  double get speed => game.tileSize * 4; //速度单位
  AnimationDisplay(this.game, String imgPath, int amount,
      {this.rect,
      this.width,
      this.height,
      this.offset,
      double textureWidth = 42,
      double textureHeight = 42,
      double stepTime = 0.15}) {
    double _width = 100;
    double _height = 100;
    if (rect != null) {
      if (width == null) {
        _width = rect.width;
      }
      if (height == null) {
        _height = rect.height;
      }
      if (offset == null) {
        offset = new Offset(rect.left, rect.top);
      } else {
        offset = new Offset(rect.left + offset.dx, rect.top + offset.dy);
      }
    } else {
      if (width == null) {
        width = game.tileSize;
      }
      if (height == null) {
        height = game.tileSize;
      }
      if (offset == null) {
        offset = new Offset(0, 0);
      }
    }

    //宝箱位置
    final animation = flame_animation.Animation.sequenced(imgPath, amount,
        textureWidth: textureWidth,
        textureHeight: textureHeight,
        stepTime: stepTime);
    animationComponent = AnimationComponent(_width, _height, animation);
    animationComponent.x = offset.dx;
    animationComponent.y = offset.dy;
    //  game.add(animationComponent);
  }
  void render(Canvas c) {
    animationComponent.render(c);
  }

  void update(double t) {
    animationComponent.update(t);
  }

  void destory() {
    if (animationComponent != null) {
      animationComponent?.destroy();
      game.animationDisplayList.remove(this);
    }
  }
}
