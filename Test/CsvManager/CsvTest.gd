extends Node2D
##工具
const CSVTool = preload("res://addons/CsvManager/CsvTools.gd")
##打包类
const Data = preload("res://Test/CsvManager/Data.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	csv_load()
##测试配置csv包装为类
##支持用bind方法注册特定属性的自定义处理方式。
func csv_load():
	var res = CSVTool.load_csv_as_obj("res://Test/CsvManager/Resource/CSVData.csv",\
	Data,CSVTool.general_csv_to_obj_handler.bind(custom_data_attrubute_handler))
	for data in res:
		print(data)
##自定义csv行处理，return 处理完的值
func custom_data_attrubute_handler(index,csv_head,csv_line,to_class):
	var attr_name = csv_head[index]
	var attr_value = csv_line[index]
	match attr_name:
		"icon":
			return load(attr_value)
