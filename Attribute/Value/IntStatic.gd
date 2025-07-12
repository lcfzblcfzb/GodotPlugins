extends Value

var _value:int=-1

func _init():
	type = Value.Type.Int_Static
## 初始化。_init_params 支持不同类型的初始化方式
func  init(_init_params,_attribute):
	super.init(_init_params,_attribute)
	if _init_params is Dictionary:
		_value = _init_params.get("value")
	elif  _init_params is int:
		_value = _init_params
		
func  change_value(v):
	if _value!=v:
		var prv = _value
		_value = v
		emit_signal("Changed",prv)
				
func  get_value():
	return _value

func alternate_value(params):
	change_value(params["value"])
