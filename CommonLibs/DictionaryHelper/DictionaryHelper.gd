##字典类 帮助类
class_name DictionaryHelper

##表示该字典是专门的 id->value 键值存储区 
const KEY_ID = 'KEY_ID'

##绑定字典，开启操作
static func bind(dict,template=null)->DictionaryOperating:
	var do = DictionaryOperating.new()
	do.init(dict,[],dict,template)
	return do

##解析字典定义template
static func anaylze_template(template:GDScript):
	print(template)
	print(template.get_script_constant_map())
	pass	

static func template_has(key,template:GDScript):
	var result = __search_template_for_key(key,template.get_script_constant_map())
	print(result)
	
static func __search_template_for_key(key,sub_dict):
		if sub_dict==null:
			return null
		for _k in sub_dict:
			if _k==key:
				return sub_dict.get(_k)
			if _k ==KEY_ID:
				return __search_template_for_key(key,sub_dict.get(_k))
			var _v = sub_dict.get(_k)
			if _v is Dictionary:
				var res =  __search_template_for_key(key,_v)
				if res==null:
					continue
				else:
					return res
			elif _v is Array:
				if _v.size()<=0:
					continue
				elif _v.size()==1:
					var _item_cfg = _v.back()
					var _result = __search_template_for_key(key,_item_cfg)
					if _result==null:
						continue
					else:
						return _result
				else:
					continue
			else:
				continue

##template起始dict节点名称
const TEMPLATE_KEY_ROOT = 'root'
const KEY_ARRAY_INDEX = 'KEY_ARRAY_INDEX'

##template中查找到key的路径
##返回：path. null:未找到路径，[]：找到的路径，空数组表示当前就是要找的key所在字典
static func template_lookpath(key,template:GDScript):
	var path = []
	var root = template.get_script_constant_map().get(TEMPLATE_KEY_ROOT)
	var result = __template_key_path_lookup(key,root,path)
	if result==true:
		return path
	else:
		return null
	
static func __template_key_path_lookup(key,current_dict:Dictionary,path:Array):
	
	for _k in current_dict:
		if _k ==key:
			return true
		var _v = current_dict.get(_k)
		if _v is Dictionary:
			path.append(_k)
			if __template_key_path_lookup(key,_v,path):
				return true
			else:
				path.pop_back()
				continue
		elif _v is Array:
			if _v.size()<=0:
				continue
			elif _v.size()==1:
				var _item_cfg = _v.back()
				path.append(_k)
				path.append(KEY_ARRAY_INDEX)
				if __template_key_path_lookup(key,_item_cfg,path):
					return true
				else:
					path.pop_back()
					path.pop_back()
					continue
			else :
				continue
		else:
			continue
	return false

##字典操作节点
class DictionaryOperating:
	##所操作的字典
	var dict:Dictionary
	##当前的所处路径的数组
	var _current_path = []
	##当前的节点
	var _current_key_node =null
	
	var template:GDScript
	
	##初始化
	func init(_dict,_path,_current_node,_template=null):
		dict = _dict
		template = _template
		_current_path = _path
		_current_key_node = _current_node
	
	##取值操作。使用此方法则默认被操作的字典/数组的结构已经构建完成（通过goc)，此方法的目的是快速取值，减少中间操作。
	##若key 不为null，获得key对应的值（不存在则返回null）。若值是字典或者数组，且is_return_node==true,则生成DictionaryOperating节点返回。
	##若值是其它类型，则直接返回值(不推荐，尽量返回DictionaryOperating,用gt()返回值，避免混乱）
	## 若key 为null，返回_current_key_node
	func g(key=null):
		#key为空的 直接返回get_current_node()，使得操作便捷
		if key==null:
			push_warning('[DictionaryOperating] get current node due to key is null,current path:',_current_path)
			return get_current_node()
		if _current_key_node is Dictionary:
			if _current_key_node.has(key):
				var _next = _current_key_node.get(key)
				if _next is Dictionary or _next is Array:
					var _next_path = _current_path.duplicate()
					_next_path.append(key)
					var _next_op = DictionaryOperating.new()
					_next_op.init(dict,_next_path,_next)
					return _next_op
				else:
					return _next
			else:
				push_error('[DictionaryOperating] key not exit in current node:',key,' ,current:',_current_path)
				return null
		elif _current_key_node is Array:
			if not key is int:
				push_error('[DictionaryOperating] key is not int to current array node')
				return null
			if key >= _current_key_node.size() or key <0:
				push_error('[DictionaryOperating] key out of range to current array node')
				return null
			var _next = _current_key_node[key]
			var _next_path = _current_path.duplicate()
			_next_path.append(key)
			if _next is Dictionary or _next is Array:
				var _next_op = DictionaryOperating.new()
				_next_op.init(dict,_next_path,_next)
				return _next_op
			else:
				return _next
		else:
			return null	
	
	## 根据template 遍历字典查找key对应的值/operation
	## 返回的值可能是operation 或者直接是值，根据key对应来决定
	## params 支持数组或者字典。若是数组中按照顺序填写KEY_ID/KEY_ARRAY_INDEX对应的id/索引
	##若是字典 键=KEY_ID/KEY_ARRAY_INDEX所在的节点key，值=id/索引值.
	func seek(key,params=null):
		if template==null:
			push_warning("DictionaryOperating:seek method,template shouldnt be null.")
			return null
		
		var cm = template.get_script_constant_map().values()
		if not template.get_script_constant_map().values().has(key):
			push_warning("DictionaryOperating:seek method,key not in template constant map.k:%s,template:%s"%[key,template])
			return null
		
		var path = DictionaryHelper.template_lookpath(key,template)
		
		var _operation = self
		for _next in path:
			if _next== KEY_ID or _next==KEY_ARRAY_INDEX:
				if params is Array:
					_operation = _operation.g(params.pop_front())
				elif params is Dictionary:
					var _k_param = _operation._current_path.back()
					if params.has(_k_param):
						_operation = _operation.g(params.get(_k_param))
					else :
						push_error("DictionaryOperating:seek method,params dictionary not containing required key:",_k_param)
						return 
			else:
				_operation = _operation.g(_next)
		
		return _operation.g(key)
			
	func __search_dict_for_key(key,sub_dict):
		if sub_dict==null:
			return null
		for _k in sub_dict:
			if _k==key:
				return sub_dict.get(_k)
			if _k ==KEY_ID:
				return __search_dict_for_key(key,sub_dict.get(_k))
			var _v = sub_dict.get(_k)
			if _v is Dictionary:
				var res =  __search_dict_for_key(key,_v)
				if res==null:
					continue
				else:
					return res
			elif _v is Array:
				if _v.size()<=0:
					continue
				elif _v.size()==1:
					var _item_cfg = _v.back()
					var _result = __search_dict_for_key(key,_item_cfg)
					if _result==null:
						continue
					else:
						return _result
				else:
					continue
			else:
				continue
				
	## 检查并生成节点。看成调用dict[key]
	func goc(key , type=TYPE_DICTIONARY)->DictionaryOperating:
		
		if type not in [TYPE_DICTIONARY,TYPE_ARRAY]:
			push_warning("DictionaryOperating goc can only create TYPE_DICTIONARY or TYPE_ARRAY")
			return null
		
		if not typeof(_current_key_node)in [TYPE_DICTIONARY,TYPE_ARRAY]:
			push_warning(" _current_key_node can only be a dictionary ")
			return null
		#若key节点已存在，且符合type描述，则将当前Key 置入新DictionaryOperating中返回。
		if _current_key_node.has(key):
			var _next = _current_key_node[key]
			if typeof(_next) == type:
				var _next_path = _current_path.duplicate()
				_next_path.append(key)
				var _next_op = DictionaryOperating.new()
				_next_op.init(dict,_next_path,_next)
				return _next_op
			else:
				#不符合type描述则返回null
				push_warning("current node already has key,but not same type")
				return null
		#若key节点还没有初始化，则创建新节点，并把当前Key 一同置入新DictionaryOperating中返回。
		var _next_node 
		match  type:
			TYPE_DICTIONARY:
				_next_node = {}
			TYPE_ARRAY:
				_next_node = []
		_current_key_node[key] = _next_node
		var _next_path = _current_path.duplicate()
		_next_path.append(key)
		var _next_op = DictionaryOperating.new()
		_next_op.init(dict,_next_path,_next_node)
		return _next_op
	##检查并生成数组类型节点
	func goc_array(key)->DictionaryOperating:
		return goc(key,TYPE_ARRAY)
	##当前的节点值
	func get_current_node():
		return _current_key_node
	##操作当前节点：添加kv
	func kv(k,v)->DictionaryOperating:
		if get_current_node() is Dictionary:
			get_current_node()[k] = v
		return self
	##操作当前节点：获得k对应的值.如果是数组字典，获得对应key\index的值。其它的直接返回
	func gt(k):
		if get_current_node() is Dictionary:
			return get_current_node().get(k)
		elif get_current_node() is Array:
			return get_current_node()[k]
		else :
			return get_current_node()
	##操作当前节点:如果是数组节点，append() 值
	func append(a):
		if get_current_node() is Array:
			get_current_node().append(a)
	##操作当前节点：数组节点，append_array
	func append_array(array):
		if get_current_node() is Array:
			get_current_node().append_array(array)
	##操作当前节点：是否存在
	func has(a)->bool:
		if typeof(get_current_node()) in [TYPE_ARRAY,TYPE_DICTIONARY]:
			return get_current_node().has(a)
		return false
