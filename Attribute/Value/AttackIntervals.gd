extends Value

const BASE =1.817
#攻击间隔--基于 attack speed 属性来计算
#公式为 log ((attack_speed+100)/100) / log(1.817) ---》1.817为底
var _value:float
#当前_value 值对应的_attack_speed
var _attack_speed:float

func _init():
	type = Value.Type.AttackIntervals
## 初始化。_init_params 支持不同类型的初始化方式
func  init(_init_params,_attribute):
	super.init(_init_params,_attribute)
	if _init_params is Dictionary:
		_value = _init_params.get("value")
	elif  _init_params is Vector2:
		_value = _init_params
		
func  change_value(v):
	# 无法改变攻击间隔
	pass
				
func  get_value():
	var attr_attack_spd = attribute.agent.get_attribute_by_id(AttributeAgent.AttributeType.AttackSpeed)
	var spd_value = attr_attack_spd.get_value_obj()
	var attack_spd_now = spd_value.get_value()
	if _attack_speed==null or _attack_speed != attack_spd_now:
		_value = calc_attack_intervals(attack_spd_now,BASE)
		_attack_speed = attack_spd_now
	return _value

func alternate_value(params):
	change_value(params["value"])
	
##攻速属性 计算攻击频率
static func calc_attack_intervals(speed:float,base:float):
	if speed==0:
		return NAN
	return  log(base) / log( (speed+100)/100)
