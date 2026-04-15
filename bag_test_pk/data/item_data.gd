extends Resource
class_name ItemData

@export var id: String
@export var item_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var max_stack: int = 1
@export var item_type: String = "\u9053\u5177"

@export_group("Grid Size")
@export var base_grid_size: Vector2i = Vector2i(1, 1)
@export var rotation: int = 0

@export_group("Battle Stats")
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0
@export var hp_bonus: int = 0
@export var speed_bonus: float = 0.0

@export_group("Battle Behavior")
@export var behavior_type: String = ""
@export var base_attack_speed: float = 1.0
@export var affects_by_bag_state: bool = false

@export_group("Use Effect")
@export var use_effect_type: String = ""
@export var use_effect_value: int = 0


func get_grid_size() -> Vector2i:
	if rotation == 90 or rotation == 270:
		return Vector2i(base_grid_size.y, base_grid_size.x)
	return base_grid_size


func is_facing_direction(direction: String) -> bool:
	match direction:
		"right":
			return rotation == 0
		"down":
			return rotation == 90
		"left":
			return rotation == 180
		"up":
			return rotation == 270
	return false


func get_facing_text() -> String:
	match rotation:
		0:
			return "->"
		90:
			return "v"
		180:
			return "<-"
		270:
			return "^"
	return ""


func get_base_attack() -> int:
	return attack_bonus
