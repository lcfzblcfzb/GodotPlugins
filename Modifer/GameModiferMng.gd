## 这是实现类。在这里定义你自己游戏的ModiferEffectType,以及modifer配置文件路径，自定义实现配置类加载方式。
## 这里是用了csv格式的配置文件。

class_name GameModiferMng
extends  ModiferMng

#配置路径
var modifer_config_file_path = "res://Resource/Modifer/ModiferCFG.csv"

##modifer类别
enum ModiferEffectType{
	Nil= -1,
	##单个属性变化
	SingleAttrChange = 1,
	##持续buff
	Dot = 2
	
}

##加载配置
func init():
	load_csv()
	
func load_csv():
	var mod_configs=GTools.FileTools.load_csv_as_obj(modifer_config_file_path,ModiferConfig)
	for cfg in mod_configs:
		id_2_cfg_dict[cfg.id]= cfg
##子类实现
func new_game_modifer(obj_id,mod_id, target,param=null,caster=null)->AbsModifer:
	var mod_cfg = id_2_cfg_dict.get(mod_id) as ModiferConfig
	if mod_cfg:
		var mod_effect = new_mod_effect(mod_cfg.mod_effect)
		if mod_effect:
			var stack =  param.get('stack',0) if param and param is Dictionary else 0
			#初始化
			var mod = GameModifer.new(obj_id ,mod_cfg.mod_effect,param,Time.get_unix_time_from_system(),mod_cfg.total_last_time,mod_cfg.intervals, stack ,mod_cfg,mod_effect,target,caster)
			#绑定effect和modifer
			mod_effect.bind(mod)
			return mod
		else:
			return null
	else:
		return null
		
##创建mod effect 对象
func new_mod_effect(mod_effect_str):
	var effect_script = find_mod_effect(mod_effect_str)
	if effect_script:
		return effect_script.new()
	else:
		push_error('mod effect not found,effect str:',mod_effect_str)
		
##通过mod_effect 字符串，构造对应的Mod Effect 类
func find_mod_effect(mod_effect_str:String):
	
	if mod_effect_str==null or mod_effect_str.is_empty():
		push_error("mod_effect_str is not config")
		return
	
	#如果是文件路径，直接load 
	if mod_effect_str.is_absolute_path() or mod_effect_str.is_relative_path() and ResourceLoader.exists(mod_effect_str):
		return load(mod_effect_str)
	else:
		#如果是字符串，表示是是GameModiferEffects下的子类
		var effects = load("res://Modifer/GameModiferEffects.gd") as GDScript
		var effect =effects.get_script_constant_map().get(mod_effect_str)
		if effect:
			return effect
