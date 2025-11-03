class_name FloatBonusValue
extends Value
##加成类型
enum BonusType{
	BaseValue=0,
	Bonus=1,
	BonusRate=2
}
##改变值的方式
enum MeansAltenation{
	Change = 0,
	Update = 1
}
	
var base_value:float=0
var bonus:float=0
var bonus_rate:float=1

var _value:float=0

var _dirty = true

func _init():
	type = Value.Type.Float_Bonus

## 初始化。_init_params 支持不同类型的初始化方式
func  init(_init_params,_attribute):
	super.init(_init_params,_attribute)
	if _init_params is Dictionary:
		base_value = _init_params.get("base",0)
		bonus =  _init_params.get("bonus",0)
		bonus_rate =  _init_params.get("rate",1)
	elif typeof(_init_params) in [TYPE_FLOAT,TYPE_INT] :
		base_value = _init_params
		bonus = 0
		bonus_rate =1
## 加值：直接覆盖值
func  update_value(bonus_type,v):
	match bonus_type:
		BonusType.BaseValue:
			if base_value != v:
				base_value = v
				_dirty = true
				emit_signal("Changed",_value)
				
		BonusType.Bonus:
			if bonus!=v:
				bonus = v
				_dirty = true
				emit_signal("Changed",_value)
				
		BonusType.BonusRate:
			if bonus_rate!=v:
				bonus_rate = v
				_dirty = true
				emit_signal("Changed",_value)
				
##改变值：在原基础上变化
func  change_value(bonus_type,v):
	if 0 != v:
		match bonus_type:
			BonusType.BaseValue:
				base_value += v
				_dirty = true
			BonusType.Bonus:
				bonus += v
				_dirty = true
			BonusType.BonusRate:
				bonus_rate += v
				_dirty = true
		emit_signal("Changed",_value)
##计算公式		
func  _calc_value():
	_value = (base_value + bonus) * bonus_rate

func alternate_value(params):
	var mean = params['mean']
	if mean==MeansAltenation.Change:
		change_value(params["bonus_type"],params["value"])
	elif  mean ==MeansAltenation.Update:
		update_value(params["bonus_type"],params["value"])

func  get_value():
	if _dirty:
		_calc_value()
	return _value

func is_dirty():
	return _dirty
