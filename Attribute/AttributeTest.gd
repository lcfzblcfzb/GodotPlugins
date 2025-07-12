extends Node2D
##测试用例
const TestAttribute = preload("res://Resource/Attribute/test_attribute.tres")

func _ready():
	test_float_bonus()

func test_float_bonus():
	var attribute_agent = AttributeAgent.new()
	attribute_agent.pre_init(TestAttribute.get_attribute_dict())
	
	var attr_physics = attribute_agent.get_attribute_by_id(AttributeAgent.AttributeType.PhysicsPower)
	print(attr_physics.get_value())
	var physics_value = attr_physics.get_value_obj()
	
	physics_value.change_value(FloatBonusValue.BonusType.BaseValue,5)
	print('base',physics_value.get_value())
	physics_value.change_value(FloatBonusValue.BonusType.Bonus,10)
	print('bonus',physics_value.get_value())
	physics_value.change_value(FloatBonusValue.BonusType.BonusRate,1)
	print('bonus_rate',physics_value.get_value())
