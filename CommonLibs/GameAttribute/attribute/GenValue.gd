##‘值’基类
class_name GenValue
## prv_value:变化前的值
signal Changed(prv_value)

var type
var attribute 
func  init(_init_params,_attribute):
	attribute = _attribute
##获得值.抽象方法
func  get_value():
	pass
##修改值
func alternate_value(params):
	pass
