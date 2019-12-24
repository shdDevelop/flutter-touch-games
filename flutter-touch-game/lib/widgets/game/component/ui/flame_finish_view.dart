import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:mz_flutterapp_deep/utils/service_game.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_ui_light.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_display.dart';

import '../../flame_Langaw_Game.dart';
import 'util/flame_rect_display.dart';

class FinishView {
  final LangawGame game;
  Rect titleRect;
  Sprite curSprite;
  List<Sprite> evaluationSpriteList;
  int spriteIndex = 0;
  double comboWeight = 0.5;
  double scoreWeight = 0.3;
  double recordRefresh = 0.2;
  double yOffset = 0;
  UILight uiLight;
  int rank;
  GameService gamService;
  Duration timeCost;
  TextDisplay recordRefreshDesc;
  TextDisplay curRankDesc;
  RectDisplay curRankBg;
  FinishView(this.game) {
    yOffset = game.tileSize;
    titleRect = Rect.fromLTWH(
      game.screenSize.width / 2 - game.tileSize * 1.5,
      (game.screenSize.height / 2) - (game.tileSize * 3) - yOffset,
      game.tileSize * 3,
      game.tileSize * 2,
    );
    evaluationSpriteList = game.resourceManager.evaluationSpriteList
        .map((c) => new Sprite(c))
        .toList();
    //根据得分获取序号 A-B-C-D-S-SS；//根据排行榜的排行，前期根据得分与最大连击数计算
    spriteIndex = getEvaluationIndex();
    curSprite = evaluationSpriteList[spriteIndex];
    uiLight = new UILight(game);
    gamService = new GameService();
    timeCost = DateTime.now().difference(game.timeStart);
    if (game.isRecordRefresh) {
      recordRefreshDesc = new TextDisplay("新纪录突破",
          color: Colors.white,
          dx: titleRect.left + titleRect.width / 2,
          dy: titleRect.top - game.tileSize * 2 - yOffset);
      //逐渐展示排行画面展示排行界面
      Future.delayed(Duration(seconds: 1)).then((_) {
          game.gameCenter?.showRankView(); 
        });
    }
     uploadUserDataLog();
  }
  void render(Canvas c) {
    uiLight.render(c);
    curSprite.renderRect(c, titleRect);
    if (recordRefreshDesc != null) {
      recordRefreshDesc.render(c);
    }
    if (rank != null) {
      if (curRankDesc == null) {
        curRankDesc = new TextDisplay("当前排行：$rank",
            color: Colors.white,
            dx: titleRect.left + titleRect.width / 2,
            dy: titleRect.top - game.tileSize - yOffset);
      }
      if (curRankBg == null) {
        var rect = Rect.fromLTWH(
            game.screenSize.width / 5.5,
            curRankDesc.dy - game.tileSize * 0.1,
            game.screenSize.width / 1.5,
            game.tileSize * 1.2);
        curRankBg = new RectDisplay(game,
            imgPath: 'game/backyard_rank.png', rect: rect);
      }
      curRankBg.render(c);
      curRankDesc.render(c);
    }
  }

  void update(double t) {
    uiLight.update(t);
  }

  //根据得分获取序号 D -C -B -A-S-SS；//根据排行榜的排行，前期根据得分与最大连击数计算
  //维度3个 1.当前得分，30% 2.当前最大连击数 50% 2.是否打破记录 10%
  int getEvaluationIndex() {
    var finalScore = getComboEvaluation() +
        getScoreEvaluation() +
        getRecoreBreakEvaluation();
    var finalEvalIndex = finalScore.toInt();
    if (finalEvalIndex >= game.resourceManager.evaluationSpriteList.length) {
      finalEvalIndex = game.resourceManager.evaluationSpriteList.length - 1;
    }
    if (finalEvalIndex <= 0) {
      finalEvalIndex = 0;
    }
    return finalEvalIndex;
  }

  //获取连击数评分
  double getComboEvaluation() {
    var score = 0;
    if (game.maxCombo >= 100) {
      score = 10;
    } else if (game.maxCombo >= 50) {
      score = 5;
    } else if (game.maxCombo >= 30) {
      score = 4;
    } else if (game.maxCombo >= 20) {
      score = 3;
    } else if (game.maxCombo >= 10) {
      score = 2;
    } else {
      score = 1;
    }
    return score * comboWeight;
  }

  //获取连击数评分
  double getScoreEvaluation() {
    var score = 0;
    if (game.score >= 1000) {
      score = 10;
    } else if (game.score >= 500) {
      score = 5;
    } else if (game.score >= 200) {
      score = 4;
    } else if (game.score >= 100) {
      score = 3;
    } else if (game.score >= 50) {
      score = 2;
    } else {
      score = 1;
    }
    return score * scoreWeight;
  }

  //获取记录打破评分
  double getRecoreBreakEvaluation() {
    var score = 0;
    if (game.isRecordRefresh) {
      score = 2;
    }
    return score * recordRefresh;
  }

  ///上传用户数据
  Future uploadUserDataLog() async {
    if (game.score <= 0) return;
    gamService
        .uploadGameUserDataLog(
            score: game.score,
            combo: game.combo,
            evaluation: spriteIndex,
            gameCost: timeCost.inSeconds,
            monsterHits: game.monsterHit)
        .then((result) async {
      if (result != null && result["status"] == 0) {
        //获取游戏排名数据
        var rankResultList = await gamService.getRankList(limit: 10);
        if (rankResultList != null && rankResultList.length > 0) {
          //展示排名动画
          var hitCurUserObj = rankResultList
              .where((c) => c.guid_user_upload == "用户Id")
              .first;
          if (hitCurUserObj != null) {
            rank = rankResultList.indexOf(hitCurUserObj) + 1;
          }
        }
      }
    });
  }
}
