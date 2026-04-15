extends RefCounted
class_name ItemRuntime

var data = null
var owner = null

var equipped: bool = true
var current_rotation: int = 0
var current_stack: int = 1
var active: bool = true

var current_attack: int = 0
var current_attack_speed: float = 9999.0
var current_behavior_type: String = ""
var cooldown_timer: float = 0.0


func _init(item_data = null):
	data = item_data
	if data != null:
		current_rotation = data.rotation
