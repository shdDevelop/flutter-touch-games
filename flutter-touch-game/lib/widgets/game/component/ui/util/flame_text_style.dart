import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';


//图片举行位置
class GameTextStyle {
  Shadow shadow;
  TextStyle titleStyle;
  Color color;
  final Color initColor;
  GameTextStyle({this.initColor}) {
    if (initColor == null) {
      color = color_game_text;
    }else
    {
      color=initColor;
    }
    shadow = Shadow(
      blurRadius: 3,
      color: color_game_shadow,
      offset: Offset.zero,
    );
  }

  TextStyle getTitleTextStyle({double fontSize = 50}) {
    var titleStyle = new TextStyle(
        color: color,
        fontSize: fontSize,
        shadows: [shadow, shadow, shadow, shadow]);
    return titleStyle;
  }

  TextStyle getColumnTextrStyle({double fontSize = 15,Color textColor}) {
    var curTextColor=textColor;
    if(curTextColor==null)
    {
      curTextColor=color;
    }
    var columnStyle =
        new TextStyle(color: curTextColor, fontSize: fontSize, shadows: <Shadow>[
      Shadow(
        blurRadius: 7,
        color: color_game_shadow,
        offset: Offset(3, 3),
      ),
    ]);
    return columnStyle;
  }
}
