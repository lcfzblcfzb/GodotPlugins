##属性管理器。主要定义了属性的枚举，需要覆写get_attribute_class方法，提供本游戏的attribute类
class_name AttributeAgent
extends GenAttributeAgent
#属性类型枚举
enum AttributeType{
	Nil=-1,
	
	Level = 1,
	Health =10,
	MaxHealth=11,
	
	#角色各项放大系数
	SizeScale = 12,
	#受击范围
	HurtRadius = 13,
	#自身范围
	CollisionRadius = 14,
	#高度
	Height = 15,
	#距离地面海拔
	Elevation = 16,
	#实际移动速度
	MoveSpeed = 20,
	MoveDirection = 21,
	FaceDirection = 22,
	RollSpeed = 23,
	RollTime = 24,
	RunSpeed = 25,
	Damage = 30,
	#投射物分裂：
	Split = 31,
	#伤害类型（物理、魔法、科技）
	DamageType = 32,
	#分裂几率
	SplitProb = 33,
	#分裂伤害
	SplitDmg = 34,
	
	AttackIntervals = 40,
	AttackSpeed = 41,
	
	PhysicsPower = 42,
	MagicPower = 43,
	SciencePower = 44,
	#专长
	Special =45,
	
}
#攻击力类型（物理魔法科学）
enum DamageType{
	Nil=-1,
	Physics = 1,
	Magic = 2,
	Science =3,
}

func get_attribute_class():
	return load(get_script().resource_path.get_base_dir() +"/attribute.gd")

### 工具方法
##攻击力处理--根据角色属性来决定攻击力
static func get_damage_type_handler(type):
	return damage_type_handler_dict.get(type)
#字典储存	
static var damage_type_handler_dict={
	DamageType.Nil: func(damge_value):
		return damge_value,
	DamageType.Physics: func(damge_value):
		return damge_value.attribute.agent.get_attribute_by_id(AttributeType.PhysicsPower).get_value(),
	DamageType.Magic: func(damge_value):
		return damge_value.attribute.agent.get_attribute_by_id(AttributeType.MagicPower).get_value(),
	DamageType.Science: func(damge_value):
		return damge_value.attribute.agent.get_attribute_by_id(AttributeType.SciencePower).get_value(),
}	
