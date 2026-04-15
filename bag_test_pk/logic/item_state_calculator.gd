extends RefCounted
class_name ItemStateCalculator

const DIRECTION_MANAGER = preload("res://logic/direction_manager.gd")


func recalc_item_runtime(item_runtime):
	if item_runtime == null or item_runtime.data == null:
		return

	var item = item_runtime.data
	var owner = item_runtime.owner

	var strength_bonus := 0
	var agility_bonus := 0.0

	if owner != null:
		var owner_strength = owner.get("strength")
		var owner_agility = owner.get("agility")
		if owner_strength != null:
			strength_bonus = int(owner_strength * 0.3)
		if owner_agility != null:
			agility_bonus = owner_agility * 0.02

	item_runtime.current_attack = 0
	item_runtime.current_attack_speed = 9999.0
	item_runtime.current_behavior_type = item.behavior_type

	match item.behavior_type:
		"weapon_attack":
			item_runtime.current_attack = item.attack_bonus + strength_bonus
			item_runtime.current_attack_speed = max(0.2, item.base_attack_speed - item.speed_bonus - agility_bonus)

			if item.affects_by_bag_state:
				var bonus = DIRECTION_MANAGER.get_direction_bonus(item_runtime.current_rotation)
				item_runtime.current_attack = max(1, int(item_runtime.current_attack * bonus))
		"passive_armor":
			item_runtime.current_attack = 0
			item_runtime.current_attack_speed = 9999.0
		"consumable":
			item_runtime.current_attack = 0
			item_runtime.current_attack_speed = 9999.0
