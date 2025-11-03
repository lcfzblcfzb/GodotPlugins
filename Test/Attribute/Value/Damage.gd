extends Value

#攻击力值。
var _value:float
#用来储存上次计算_value的上下文信息，来判断是否需要更新_value
var _last_check_info

func _init():
	type = Value.Type.Damage
		
func  change_value(v):
	# 无法改变攻击力
	pass
	
## 通过handler 处理计算攻击力
func  get_value():
	var attr_damage_type = attribute.agent.get_attribute_by_id(AttributeAgent.AttributeType.DamageType)
	var damage_type = attr_damage_type.get_value()
	var fun = AttributeAgent.get_damage_type_handler(damage_type)
	if fun!=null:
		_value = fun.call(self)
	return _value

func alternate_value(params):
	change_value(params["value"])

func get_last_check_info():
	return _last_check_info
