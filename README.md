#简介
* 该程序为flutter+flame 学习过程中 尝试根据引擎开发的一款常识性快速小游戏，中间加入了某熟悉的细节，游戏资源来源与网上采集 注重画风大家按照需求自行替换， 如果问题麻烦留言。
# 系统
* 可重复性 ，通关boss后进入下一Level，下次考虑从下一个level开始，
* 增加boss通关时间剧情 boss剧情支线（进行中）
* 策略性？（进行中）
* 收获性， （进行中）
* 神器（几率致晕，几率1/3血），（进行中）
* 装备（角色），
* 增加buff 攻击力，
* 毒攻击 
* 暴击率 ， 
* 聚拢群怪（进行中）
* 装备攻击几率触发buff
* 难度  随着游戏进程提升速度增加
* 连击  连击分数增加
* 血条 3次错误点击 ，失败三次，失败 获得物品界面
* 成就
* feaver进度条： buff系统，得分增加，道具物品增加 ，达到feaver 出现精英或者随机boss， 连击
#道具/buff  ：
* 冻结缓慢，
* 全屏，
* 💗回复，
* 毒效果，
* 无敌效果（随意点touch），
* 攻击力加成
* ，暴击提升随机颜色爆炸 ，最大生命值生长
#排行帮  
* 根据得分 结算的上传后台并返回从后台获取排行数据，前后5名，用户展示在前台
* buff图标

#细节：
* 1.修改用户hp为血条，
* 2.QTE 目的 代入感怪物孵化器控制出怪概率
* 3.技能读条
* 4.连击排行榜 
* 5.增加表情功能 情绪管理功能
* 6.增加等级
#任务系统
* 技能 ： 闪现，回血，加速，读条打断 ，没打断扣血
*   `1.召唤分身 你要把其中一个划动到另一个分身上才能解除boss的无敌状态（进行中） `
*  ` 2.机械风（进行中）`
*   3.精英怪 boss系统 theworld 音效 boss进度条 快速点击，
*   4.各类精英/boss不同的击杀方式：具有难度不容易击杀，出现qte
*   5.有些需要连击数到达，血条点击满，
*   6.精英怪血条。
*   7.吸收小怪回血
#2019-10-21
* 根据boss移动结束偶尔打几次掉血，前 90%触发一次QTE ，最后40%血终结QTE增加通关获得能量，
* `获得装备特效 （进行中）`
* `点击切换武器特效随机表情（进行中）`
*   `攻击回血`
*   增加普通攻击技能 与大招技能
*   血条减少的动态效果
*   增加boss 血条（上方）
*   增加到达boss进程
*   打败boss获得下个level 或者装备buff
*   增加跳血效果
*   精英怪增加血量
*   通过攻击力而非攻击次数继续boss攻击
*   增加 连击数与分数 阶段3次
   
*  1.成功点击10次后出现晕眩效果可进行QTE，连击扣血
*  2.随机触发技能横冲直撞，结束后晕眩 QTE
*  3.护盾效果 点击10此后破盾
*  4.技能发动 缩小miss效果（误触miss效果）
#2019-10-24
* 增加精英怪/boss怪dart   boss连击 单独显示 成功后添加到combo中
* 1.被点击的时候子弹时间， 
* 2.无法被全屏攻击杀死（全屏只攻击一次）
* 3.达到一定的连击数才能击破/默认 具有不同的击杀条件
* 4.个性化音效/动画/贴图
* 5.后续可能具有血条
* 6.具有更强的移动属性与技能？提醒更大
* 7.boss入场 具有warning警告/手绘动画？
* 8.掉落 特殊物品/道具 /更多的奖励经验能量/ 体力补充剂
* `9.触发重要的游戏剧情?(进行中)`
* `10.多支线，/隐藏boss，以某中方式击杀？(进行中)`
* 11.bossRush模式 多阶段变形，
* 12.1召唤系，召唤分身，
* 13. qte系统？演化
* 14.boss 出现改变音效
* 15.让每次点击都可能有惊喜（点击伤害值，暴击效果）
* 16.`jojo风格的互殴动画特效（未开始） 木大木大木 欧拉欧拉特效`
#2019-11-21
  * 增加用户技能 通过攒点击数 与点击boss获得的能量或者当前能量的积攒，发动用户高额伤害技能
  * （全灭，高额单体伤害，多连段伤害）平A（攒技能条）→放技能（攒大招条）→放大招→放队友的大招→打出属性球→打破属性球→平A（攒技能条）
  *   不同伤害条不同颜色血QTE模式点击后boss受大量伤害，目前，QTE发动条件更新？扣血特效
跳毒buff更新boss下一阶段变形特效
 
*  。。。精英怪。。。。精英怪。。。 boss技能：群体加速， 群体回复，全体加防御，移动瞬时加速，闪现，cd攻击用户boss出现 warning 右侧出现手绘
*  获得道具
#2019-12-21
*  1.去掉长按
*  2.细节需要多 彩蛋 ， 抠细节：挖细节
*  3.点击后的分数展示
* 4.当前位置排行， 好友排行，服务器排行列表   历史排行 每日排行，boss击破时间排行，装备战力排行
* 5.跳转flutter 排行展示
* 6.排行的图标（刺激第一名 超过了多少名好友）boss 血条属性系统：火 冰 暗属性
* 7.GameUserProfile 个人最高得分guid_game_new 最近一条记录
* 8.Score   个人历史高分Combo 个人最高连击数evaluate    
* 9.综合评价rank        
# 排名  
* monsterHit_Total  
* 最高击杀怪物数
 
#备注
* 配色 ：糖果色 
* 游戏进程到后期，切换bgm，随着boss出现切换bgm

 

# 游戏开发纪录片

* 1.增加实时游戏排行积分算法，用户实时展示最新排名     基于redis的 sort set的实现
* 2.增加3种类型排行算法3.增加得分上浮动画等细节，增加可重复性
* 3.目前使用攻击力与hits换算而非当前损失的生命值，
* 4.导致攻击翻倍后血减少
