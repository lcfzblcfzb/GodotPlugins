extends  Resource

@export
var Health =10
@export
var MaxHealth=10
@export
var MoveSpeed = 0
@export
var MoveDirection = Vector2.ZERO
@export
var FaceDirection = Vector2.RIGHT
@export
var Damage = 1
@export
var RollSpeed = 800.0
@export
var RollTime = 0.4
@export
var RunSpeed = 500.0
@export
var SizeScale = 1.0
@export
var AttackSpeed = 50.0
@export
var HurtRadius = 5.0
@export
var CollisionRadius = 4.0
@export
var Split = 0.0
@export
var Height = 16.0
@export
var DamageType = AttributeAgent.DamageType.Nil
@export
var PhysicsPower = 0.0
@export
var MagicPower = 0.0
@export
var SciencePower = 0.0
@export
var SplitProb = 0.0
@export
var SplitDmg = 0.0
@export
var Special = 0.0

func  get_attribute_dict()->Dictionary:
	return {
		AttributeAgent.AttributeType.Health:Health,
		AttributeAgent.AttributeType.MaxHealth:MaxHealth,
		AttributeAgent.AttributeType.MoveSpeed:MoveSpeed,
		AttributeAgent.AttributeType.MoveDirection:MoveDirection,
		AttributeAgent.AttributeType.FaceDirection:FaceDirection,
		AttributeAgent.AttributeType.Damage:Damage,
		AttributeAgent.AttributeType.RollSpeed:RollSpeed,
		AttributeAgent.AttributeType.RollTime:RollTime,
		AttributeAgent.AttributeType.RunSpeed:RunSpeed,
		AttributeAgent.AttributeType.SizeScale:SizeScale,
		AttributeAgent.AttributeType.AttackIntervals:-1,
		AttributeAgent.AttributeType.AttackSpeed:AttackSpeed,
		AttributeAgent.AttributeType.HurtRadius:HurtRadius,
		AttributeAgent.AttributeType.CollisionRadius:CollisionRadius,
		AttributeAgent.AttributeType.Split:Split,
		AttributeAgent.AttributeType.Height:Height,
		AttributeAgent.AttributeType.Elevation:0,
		AttributeAgent.AttributeType.DamageType:DamageType,
		AttributeAgent.AttributeType.PhysicsPower:PhysicsPower,
		AttributeAgent.AttributeType.MagicPower:MagicPower,
		AttributeAgent.AttributeType.SciencePower:SciencePower,
		AttributeAgent.AttributeType.SplitProb:SplitProb,
		AttributeAgent.AttributeType.SplitDmg:SplitDmg,
		AttributeAgent.AttributeType.Special:Special,
		
	}
