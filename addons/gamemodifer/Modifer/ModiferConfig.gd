class_name ModiferConfig
extends Resource

@export
var id:int
@export
var is_unique:bool
@export
var name:String
@export
var desc:String
@export
var icon:String
##多段效果每次时间间隔.大于0有效，小于等0无效
@export
var intervals:float 
##总持续时间。如果是负数表示永久持续
@export
var total_last_time:float
##最大堆叠
@export
var max_stacks:int
##Modifer effect 的文件路径
@export
var mod_effect:String
@export
var e1:String
@export
var e2:String
@export
var e3:String
@export
var e4:String
@export
var config:String
