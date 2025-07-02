class_name AbsModifer

##mod失效信号
signal EXITING

##初始化
const STATE_INITED = 0
##buff处于执行中
const STATE_RUNNING =1
##buff执行结束
const STATE_FINISHED =2
##buff被中止
const STATE_INTERRUPTED =3
##唯一id
var id
##base mod id
var mod_effect_id
##mod添加时间
var add_time_ms
##mod运行时间记录
var time_passed = 0
##多段生效的时间记录
var intervals_time_passed =0
##mod总时长
var total_last_time =0
##多段生效时间间隔.如果小于等于0 则无效
var intervals = 0
##状态
var state = STATE_INITED
##参数
var param
##层数
var stack =0
##buff的目标
var target
##buff的释放者
var caster
##基类
var _modifer_config:ModiferConfig
var _modifer_effect:ModiferEffect

func _init(p_id,p_effect_id,p_param,p_add_time_ms,p_total_last_time,p_intervals,p_stack,p_modifer_config,p_modifer_effect,p_target,p_caster):
	
	id = p_id
	mod_effect_id = p_effect_id
	
	add_time_ms = p_add_time_ms
	param = p_param
	total_last_time = p_total_last_time
	stack = p_stack
	intervals = p_intervals
	_modifer_config = p_modifer_config
	_modifer_effect = p_modifer_effect
	target = p_target
	caster = p_caster

func is_unique():
	return _modifer_config.is_unique

func check_can_add():
	return true

func add():
	state = STATE_RUNNING
	on_add()
	get_modifer_effect() and get_modifer_effect().add()
	
func on_add():
	pass

func re_add(mod):
	time_passed =0
	on_re_add(mod)
	get_modifer_effect() and get_modifer_effect().re_add()
	
func on_re_add(mod):
	pass	
##mod 持续时间到期执行
func time_out():
	state = STATE_FINISHED
	on_time_out()
	get_modifer_effect() and get_modifer_effect().time_out()
	exiting()
	
func on_time_out():
	pass
##mod 被主动移除时候调用
func remove():
	if state ==STATE_RUNNING:
		state = STATE_INTERRUPTED
	on_remove()	
	get_modifer_effect() and get_modifer_effect().remove()
	exiting()

##mod 移除之前 调用.不论何种方式都会调用
func exiting():
	on_exiting()
	get_modifer_effect() and get_modifer_effect().exit()
	emit_signal("EXITING",self)
	
func on_exiting():
	pass
	
func on_remove():
	pass

func on_tick(delta):
	pass
## 时间调用
func tick(delta):
	if state ==STATE_RUNNING:
		if total_last_time>=0:
			time_passed += delta
		if intervals>0:
			intervals_time_passed+=delta
		on_tick(delta)
		get_modifer_effect() and get_modifer_effect().tick(delta)
		##mod 运行间隔时间触发
		if intervals>0 and intervals_time_passed >= intervals:
			intervals_time_passed -=intervals
			on_intervals()
			get_modifer_effect() and get_modifer_effect().intervals()
		##mod 运行时间超过总持续时间	
		if total_last_time>=0 and time_passed >total_last_time:
			time_out()
## intervals每次达到时间执行
func on_intervals():
	pass
			
func get_modifer_effect()->ModiferEffect:
	return _modifer_effect
	
func get_modifer_config()->ModiferConfig:
	return _modifer_config
