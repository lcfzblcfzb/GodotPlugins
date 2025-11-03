##属性实现，需要实现基础配置的加载。
class_name Attribute
extends  GenAttribute

const CollectionValues = preload("res://Test/Attribute/Resource/Attribute/Values/CollectionValues.tres")
const CollectionAttributesPath = preload("res://Test/Attribute/Resource/Attribute/RoleAttribute/CollectionRoleAttributes.tres")

func  get_base():
	var attr_collections = CollectionAttributesPath
	return attr_collections.get_by_id(base_id)
	
func get_base_value(base_value):
	return CollectionValues.get_by_id(base_value)
