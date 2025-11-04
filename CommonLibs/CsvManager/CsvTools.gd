##将csv文件导入，并且转换为指定类
static func load_csv_as_obj(file_path:String,to_class:GDScript,to_class_handler:Callable=general_csv_to_obj_handler,delimeter=',')->Array:
	var fa = FileAccess.open(file_path,FileAccess.READ)
	if fa==null:
		push_error('file not exist in ',file_path)
		return []
	var result= []
	#属性名称
	var head =null
	#根据eof_reached判断csv到末尾
	while not fa.eof_reached():
		var csv_line =fa.get_csv_line(delimeter)
		if csv_line==null:
			break
		#将第一行属性名称保存到head中
		if head==null:
			head =csv_line
			continue
		#包装函数。可以根据需要自行编写，或者直接使用general_csv_to_obj_handler 通用
		var obj = to_class_handler.call(head,csv_line,to_class)
		if obj!=null:
			result.append(obj)
	return result
##通用的将csv 转化为 object.line_handler:返回值作为处理后的值设置。如果是null，则使用默认的type_convert方法
static func general_csv_to_obj_handler(csv_head:PackedStringArray,csv_line:PackedStringArray,to_class:GDScript,line_handler=null):
	if csv_head.size()!= csv_line.size():
		return
	var new_obj = to_class.new()
	#待包装类的属性列表
	var property_list =to_class.get_script_property_list()
	for key_index in csv_head.size():
		#默认csv_head中保存的就是待包装类的属性名，两者要确保一致
		var prop_key = csv_head[key_index]
		#根据名称在待包装类的属性列表中搜索，如果存在则进行赋值
		var property_info
		for prop in property_list:
			if prop['name']==prop_key:
				property_info = prop
				break
		#赋值操作，使用type_convert方法进行类型的转换
		if property_info:
			if line_handler==null:
				new_obj.set(prop_key , natural_convert(csv_line[key_index],property_info['type']))
			else:
				#如果自定义handler有返回值，则使用返回值。如果返回null,则使用type_convert
				var custom_value = line_handler.call(key_index,csv_head,csv_line,to_class)
				if custom_value:
					new_obj.set(prop_key ,custom_value)
				else:
					new_obj.set(prop_key ,natural_convert(csv_line[key_index],property_info['type']))
	return new_obj

## 自然而然的值转换;
static func natural_convert(raw_value , type):
	if type in [TYPE_DICTIONARY,TYPE_ARRAY]:
		return JSON.parse_string(raw_value)
	else:
		return type_convert(raw_value,type)
