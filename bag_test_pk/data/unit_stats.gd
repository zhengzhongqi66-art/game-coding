extends Resource
class_name UnitStats

@export var unit_name: String = "角色"
@export var max_hp: int = 100
@export var base_defense: int = 5

var current_hp: int


func _init():
	current_hp = max_hp


func reset_hp():
	current_hp = max_hp


func take_damage(damage: int) -> bool:
	var actual_damage = max(1, damage)
	current_hp -= actual_damage

	if current_hp <= 0:
		current_hp = 0
		return true
	return false


func heal(amount: int):
	current_hp = min(max_hp, current_hp + amount)
