##属性管理器基类
class_name GenAttributeAgent

signal  AttributeChanged(attribute,prv_value)
##属性字典
var  attribute_dict={}

## 初始化方法： init_param（字典类型）:  attribute_type-> attribute_init_params(字典类型） 
func  pre_init(init_param,param_overide=null):
	for attr in init_param:
		var c = get_attribute_class()
		var attribute =  get_attribute_class().new()
		if param_overide and param_overide.has(attr):
			attribute.init(attr,param_overide.get(attr),self)
		else:
			attribute.init(attr,init_param.get(attr),self)
		attribute_dict[attr] = attribute
		attribute.ValueChanged.connect(on_value_changed.bind(attribute))

##由子类继承，返回所需实例化的Attribute类
func get_attribute_class():
	return null
##通过attr_id 获取 attribute对象
func  get_attribute_by_id(attr_id):
	return attribute_dict.get(attr_id)
##获得所有属性
func get_attribute_dict():
	return attribute_dict

func on_value_changed(prv_value,attribute):
	AttributeChanged.emit(attribute,prv_value)
