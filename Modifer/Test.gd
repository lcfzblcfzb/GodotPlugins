extends Node2D

func _ready():
	mod_mng()

#测试modifer
func mod_mng():
	var mng = GameModiferMng.new()
	mng.init()
	#唯一obj_id
	var mod_id = 1
	mng.add_modifer(mod_id,GameModiferMng.ModiferEffectType.SingleAttrChange,null)

func find_mod_effect():
	var mng = GameModiferMng.new()
	var e = mng.find_mod_effect("SingleAttrChange")
	#var e = mng.find_mod_effect("res://Modifer/GameModiferEffects.gd")
	print(e)
	pass

#测试配置csv包装为类
func csv_load():
	var res = GTools.FileTools.load_csv_as_obj("res://Resource/Modifer/ModiferCFG.csv",ModiferConfig)
	print(res)

func csv_test():
	var mod_config=FileAccess.open("res://Resource/Modifer/ModiferCFG.csv",FileAccess.READ)
	#检索全部csv文件
	while not mod_config.eof_reached():
		var line = mod_config.get_csv_line()
		print(line)

# Called when the node enters the scene tree for the first time.
func sub_class_test():
	var effect = load("res://Modifer/GameModiferEffects.gd")
	var e1=effect['SingleAttrChange'].new()
	print(e1)
			
