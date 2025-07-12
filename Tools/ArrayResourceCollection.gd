extends  Resource

@export
var list:Array[Resource]

## 用来表示元素的id项的属性名
@export
var id_prop:String = "id"

func get_by_id(id):
	for item in list:
		if item.get(id_prop)==id:
			return item
