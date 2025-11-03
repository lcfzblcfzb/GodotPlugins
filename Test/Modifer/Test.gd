extends Node2D

func _ready():
	sub_class_test()

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

# Called when the node enters the scene tree for the first time.
func sub_class_test():
	var effect = load("res://Test/Modifer/GameModiferEffects.gd")
	var e1=effect['SingleAttrChange'].new()
	print(e1)
			
