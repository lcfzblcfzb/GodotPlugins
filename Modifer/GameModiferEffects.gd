##这里实现了具体效果类。用子类的方式方便管理，减少文件数量。当然也可以写成单独的文件。
class_name GameModiferEffects
##单属性变化
class SingleAttrChange:
	extends ModiferEffect
	func add():
		var cfg = modifer.get_modifer_config()
		##TODO 增加属性
		push_warning("modifer增加属性")
	func exit():
		var cfg = modifer.get_modifer_config()
		##TODO 撤回属性
		push_warning("modifer撤回属性")
##持续性伤害	
class DOT:
	extends ModiferEffect
	func intervals():
		var cfg = modifer.get_modifer_config()
		push_warning("DOT 跳动一次")
