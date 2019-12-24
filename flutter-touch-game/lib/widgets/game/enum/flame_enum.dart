enum View {
  home,
  playing,
  finish,
  help,
  credits,
  rank,
}
enum ItemRare { normal, rare, legend }

enum GameBuffType {
  buff_armor_break_forever, //破甲 状态攻击
  buff_imprisonment, //禁锢 状态攻击
  buff_bleeding, //吸血 状态攻击
  buff_poison, //毒攻击 状态攻击
  buff_slience, //沉默 状态攻击
  buff_defense_up, //防御
  buff_power_up, //攻击力提升
  buff_power_up_forever, //攻击力永久提升
  buff_effective_resistance, //效果抵抗
  buff_heal_reactive, //缓慢回血
  buff_heal_up, //加大回血
  buff_luck_up, //掉落率上升
  buff_reflect, //反射上海
  buff_speed_up, //速度提升
  buff_speed_forever, //速度提升
  buff_violent_damage_up, //暴击伤害提升
  buff_violent_damage_up_forever, //永久暴击伤害提升
  debuff_bleeding, //被动流血 每隔n秒扣血，达到1血后不再扣血
  debuff_frozen, //冰冻  减速效果，无法快速移动
  debuff_imprisonment, //禁锢  原地无法移动，技能正常发动
  debuff_poison, //中毒效果 中毒每个n秒扣血 0 空血后模拟点击效果
  debuff_sleep, //睡眠效果 无法移动，被攻击一次后解除
  debuff_slience, //沉默 无法使用技能，正常移动，
  debuff_stun, //晕眩效果无法移动，无法攻击，无法发动技能
  debuff_defense_down, //护甲下降
  debuff_heal_down, //治疗下降
  debuff_power_down, //攻击力下降
  debuff_speed_down, //移动速度下降

}
//buff触发类型
enum GameActiveType{
  Pasitive,//被动 在每次CD点的时候触发
  Positive//主动 再tap对象的时候发动执行
}
 //buff触发类型
enum GameActiveMode{
  CD,//被动 在每次CD点的时候触发
  Touch//主动 再tap对象的时候发动执行
}
class GameEnumHelper {
  GameEnumHelper();
  static T getEnumFromString<T>(Iterable<T> values, String str) {
    return values.firstWhere((f) => f.toString().split('.').last == str,
        orElse: () => null);
  }

  static String getStringFromEnum<T>(T) {
    if (T == null) {
      return null;
    }

    return T.toString().split('.').last;
  }
}
