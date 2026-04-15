extends Node

static var enemy_direction: String = "right"


static func is_weapon_effective(weapon_rotation: int) -> bool:
	match enemy_direction:
		"right":
			return weapon_rotation == 0
		"down":
			return weapon_rotation == 90
		"left":
			return weapon_rotation == 180
		"up":
			return weapon_rotation == 270
	return false


static func get_direction_bonus(weapon_rotation: int) -> float:
	return 1.0 if is_weapon_effective(weapon_rotation) else 0.5
