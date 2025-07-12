##属性 基类
class_name GenAttribute

signal ValueChanged(prv_value)
##属性base id
var base_id
##值对象
var value
##属性管理器的引用
var agent:GenAttributeAgent

func  init(_attribute , _init_params, _agent):
	base_id = _attribute
	agent = _agent
	var base_attribute = get_base()
	if base_attribute==null:
		push_warning("base attribute:%d not exist"%base_id)
		return
	var base_value = get_base_value(base_attribute.value_type)
	if base_value==null:
		push_warning("base value:%d not exist"%base_attribute.value_type)
		return
	var value_class = base_value.script_obj
	if value_class==null:
		push_warning("value_class:%s not exist"%base_value.script_obj)
		return
	value = value_class.new()
	value.init(_init_params,self)
	value.Changed.connect(_on_value_changed)
		
func  get_value():
	return value.get_value()

func  get_value_obj():
	return value
##获得属性配置
func  get_base():
	pass
##获得‘值’的配置
func get_base_value(base_value):
	pass
	
func _on_value_changed(prv_value):
	ValueChanged.emit(prv_value)
