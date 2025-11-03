##value子类。定义了type枚举。
class_name Value
extends  GenValue

enum  Type{
	Nil =-1,
	##float类型
	Float_Bonus=1,
	##vec2类型
	Vect2_Static=2,
	##int类型
	Int_Static = 3,
	
	##特殊定义的值
	##攻击间隔
	AttackIntervals = 100,
	##伤害
	Damage = 101
}
