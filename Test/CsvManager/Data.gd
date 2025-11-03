var id:int
var name:String
var address:String
var json_data:Dictionary
var icon:Texture

func _to_string():
	return "id:%s;name:%s:json_data:%s;icon:%s"%[id,name,json_data,icon]
