import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';

import '../../../flame_Langaw_Game.dart';

//图片举行位置
class RectDisplay {
  final LangawGame game;
  Sprite sprite;
  Rect rect;
  Rect curRect;
  double width;
  double height;
  double _width;
  double _height;
  Offset offset;
  double get speed => game.tileSize * 4; //速度单位
  RectDisplay(this.game,
      {this.rect,
      String imgPath,
      this.sprite,
      this.width,
      this.height,
      this.offset}) {
    if (sprite == null && imgPath.isNotEmpty) {
      sprite = new Sprite(imgPath);
    }
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
    curRect = Rect.fromLTWH(offset.dx, offset.dy, _width, _height);
  }
  void render(Canvas c) {
    sprite?.renderRect(c, curRect);
  }

  void update(double t) {}

  //移动到指定位置
  void moveToTarget(double t, Offset target,
      {double speedEnhence = 1, dynamic onArrived}) {
    if (target == null) return;

    double stepDistance = speed * t * speedEnhence;
    Offset toTarget = target - new Offset(curRect.left, curRect.top);
    if (toTarget.distance > stepDistance) {
      Offset stepToTarget =
          Offset.fromDirection(toTarget.direction, stepDistance);
      curRect = curRect.shift(stepToTarget);
    } else {
      curRect = curRect.shift(toTarget);
      if (onArrived != null) {
        onArrived();
      }
    }
  }
}
