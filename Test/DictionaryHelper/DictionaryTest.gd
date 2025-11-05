extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	test_seek()

func test_dictionary_helper_init():
	print(init_dict())
	
func init_dict():	
	var dict = {}
	
	var dh = DictionaryHelper.bind(dict)
	var operation = dh.kv(MapData.MAP_NAME,"test_map")\
	.goc(MapData.SECTION)
	#init sections
	for i in 3:
		var section_config = {}
		var dh_section = DictionaryHelper.bind(section_config)
		var section_operation = dh_section.kv(MapData.SECTION_ID,i).kv(MapData.SECTION_NAME,'section_'+str(i)).goc(MapData.ROOM,TYPE_ARRAY)
		#init rooms
		for j in 5:
			var room_config = {}
			var dh_room = DictionaryHelper.bind(room_config)
			dh_room.kv(MapData.ROOM_ID,j).goc(MapData.ROOM_DATA).goc(MapData.ROOM_DATA_OBJS,TYPE_ARRAY)
			section_operation.append(room_config)
		operation.kv(i,section_config)
	
	return dict

func test_analyze():
	#var dh = DictionaryHelper.anaylze_template(MapData)
	var result = DictionaryHelper.template_lookpath(MapData.MAP_NAME ,MapData)
	print(result)
	result = DictionaryHelper.template_lookpath(MapData.SECTION ,MapData)
	print(result)
	result = DictionaryHelper.template_lookpath(MapData.ROOM ,MapData)
	print(result)
	result = DictionaryHelper.template_lookpath(MapData.ROOM_ID ,MapData)
	print(result)
	result = DictionaryHelper.template_lookpath(MapData.ROOM_DATA ,MapData)
	print(result)
	result = DictionaryHelper.template_lookpath(MapData.ROOM_DATA_OBJS ,MapData)
	print(result)
	#var result = DictionaryHelper.template_has(MapData.ROOM_DATA ,MapData)
func test_seek():
	var dict  =  init_dict()
	var dh = DictionaryHelper.bind(dict,MapData)
	var result = dh.seek(MapData.ROOM_ID,{MapData.SECTION:0,MapData.ROOM:1})
	print(result)
	result = dh.seek(MapData.ROOM,[0])
	print(result)
