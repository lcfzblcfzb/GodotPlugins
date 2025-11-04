class_name ModiferMng
extends Node

signal MOD_ADD

#id -> mod cfg;配置项
var id_2_cfg_dict={}
#id->modifer effect instance
var id_2_mod_dict={}
#object-> modifer effect instance
var target_2_mod_dict={}

##初始化，由具体的GameModiferMng实现。加载配置到type_2_implement_dict 字典
func init():
	pass
 
##返回配置字典 
func get_mod_configs_dict():
	return id_2_cfg_dict

#返回mod_list所有特定类型buff
func _find_same_effect_mod(base_id,mod_list):
	for mod in mod_list:
		if mod.mod_effect_id == base_id:
			return mod
	return null
#返回target身上所有buff
func find_mods_of_target(obj):
	return target_2_mod_dict.get(obj,[])
#返回target身上特定类型buff
func find_effect_of_target(mod_effect,obj):
	return _find_same_effect_mod(mod_effect,find_mods_of_target(obj))

##子类实现
func new_game_modifer(obj_id,mod_id, target,param=null,caster=null)->AbsModifer:
	return null

###添加mod。 mod_id：配置id
func add_modifer(obj_id , mod_id,target,param=null,caster=null):
	var mod = new_game_modifer(obj_id, mod_id , target,param,caster)
	if mod:
		#var mod = mod_script.new(mod_type,param,Time.get_unix_time_from_system(),target,caster) as AbsModifer
		#检查target_2_mod_dict 中，target是否初始化
		var target_mods 
		if target_2_mod_dict.has(target):
			target_mods = target_2_mod_dict.get(target)
		else:
			target_mods =[]
			target_2_mod_dict[target] = target_mods
		if mod.is_unique():
			var _same_type_ = _find_same_effect_mod(mod.base_id,target_mods) as AbsModifer
			#target唯一型mod的判断。如果已经存在，则尝试刷新，中断
			if _same_type_!=null and mod.check_can_add():
				_same_type_.re_add(mod)
				MOD_ADD.emit(mod)
				return mod
		#其它情况，正常判断
		if mod.check_can_add():
			id_2_mod_dict[mod.id] = mod
			target_mods.append(mod)
			mod.EXITING.connect(on_mod_exiting)
			mod.add()
			MOD_ADD.emit(mod)
			return mod
	else:
		push_warning("cannot find modifer, base id %d" % mod_id)

func remove_modifer_by_id(id):
	var mod = id_2_mod_dict.get(id) 
	mod.remove()
	
func remove_modifer_by_obj(mod):
	remove_modifer_by_id(mod.id)

func on_mod_exiting(mod:AbsModifer):
	id_2_mod_dict.erase(mod.id)
	target_2_mod_dict.get(mod.target).erase(mod)
	
func tick(delta):
	if id_2_mod_dict.size()>0:
		for mod in id_2_mod_dict.values():
			mod.tick(delta)
