extends RefCounted

const ITEM_SCRIPT = preload("res://data/item_data.gd")

const ITEM_SWORD = "sword_001"
const ITEM_STICK = "stick_001"
const ITEM_SHIELD = "shield_001"
const ITEM_ARMOR = "armor_001"
const ITEM_POTION_HP = "potion_hp"
const ITEM_POTION_ATK = "potion_atk"
const ITEM_SLIME_HIT = "slime_hit"
const ITEM_WOLF_CLAW = "wolf_claw"
const ITEM_GOLEM_SMASH = "golem_smash"

const TYPE_WEAPON = "\u6b66\u5668"
const TYPE_ARMOR = "\u9632\u5177"
const TYPE_CONSUMABLE = "\u6d88\u8017\u54c1"
const TYPE_MONSTER_ATTACK = "\u602a\u7269\u653b\u51fb"

var items: Dictionary = {}


func create_all_items() -> Array:
	var result = []

	var sword = _create_item(ITEM_SWORD, "\u98de\u5251", "\u57fa\u7840\u6b66\u5668", TYPE_WEAPON, Vector2i(3, 2), 1)
	sword.attack_bonus = 15
	sword.behavior_type = "weapon_attack"
	sword.base_attack_speed = 0.8
	sword.affects_by_bag_state = true
	result.append(sword)

	var stick = _create_item(ITEM_STICK, "\u6728\u68cd", "\u7b80\u964b\u6b66\u5668", TYPE_WEAPON, Vector2i(3, 1), 1)
	stick.attack_bonus = 5
	stick.behavior_type = "weapon_attack"
	stick.base_attack_speed = 1.2
	result.append(stick)

	var shield = _create_item(ITEM_SHIELD, "\u516b\u5366\u9635", "\u57fa\u7840\u9632\u5177", TYPE_ARMOR, Vector2i(2, 2), 1)
	shield.defense_bonus = 10
	shield.hp_bonus = 20
	shield.behavior_type = "passive_armor"
	result.append(shield)

	var armor = _create_item(ITEM_ARMOR, "\u94c1\u7532", "\u9ad8\u7ea7\u9632\u5177", TYPE_ARMOR, Vector2i(2, 2), 1)
	armor.defense_bonus = 15
	armor.hp_bonus = 50
	armor.behavior_type = "passive_armor"
	result.append(armor)

	var potion_hp = _create_item(ITEM_POTION_HP, "\u751f\u547d\u836f\u6c34", "\u6062\u590d\u751f\u547d", TYPE_CONSUMABLE, Vector2i(1, 1), 99)
	potion_hp.behavior_type = "consumable"
	potion_hp.use_effect_type = "heal"
	potion_hp.use_effect_value = 5
	result.append(potion_hp)

	var potion_atk = _create_item(ITEM_POTION_ATK, "\u529b\u91cf\u836f\u6c34", "\u4e34\u65f6\u5f3a\u5316\u653b\u51fb", TYPE_CONSUMABLE, Vector2i(1, 1), 99)
	potion_atk.behavior_type = "consumable"
	potion_atk.use_effect_type = "buff_attack"
	potion_atk.use_effect_value = 3
	result.append(potion_atk)

	var slime_hit = _create_item(ITEM_SLIME_HIT, "\u649e\u51fb", "\u53f2\u83b1\u59c6\u7684\u57fa\u7840\u649e\u51fb", TYPE_MONSTER_ATTACK, Vector2i(1, 1), 1)
	slime_hit.attack_bonus = 20
	slime_hit.behavior_type = "weapon_attack"
	slime_hit.base_attack_speed = 1.2
	slime_hit.affects_by_bag_state = false
	result.append(slime_hit)

	var wolf_claw = _create_item(ITEM_WOLF_CLAW, "\u722a\u51fb", "\u72fc\u5996\u7684\u5229\u722a\u653b\u51fb", TYPE_MONSTER_ATTACK, Vector2i(1, 1), 1)
	wolf_claw.attack_bonus = 30
	wolf_claw.behavior_type = "weapon_attack"
	wolf_claw.base_attack_speed = 0.9
	wolf_claw.affects_by_bag_state = false
	result.append(wolf_claw)

	var golem_smash = _create_item(ITEM_GOLEM_SMASH, "\u91cd\u51fb", "\u77f3\u50cf\u7684\u6c89\u91cd\u6253\u51fb", TYPE_MONSTER_ATTACK, Vector2i(1, 1), 1)
	golem_smash.attack_bonus = 40
	golem_smash.behavior_type = "weapon_attack"
	golem_smash.base_attack_speed = 1.5
	golem_smash.affects_by_bag_state = false
	result.append(golem_smash)

	_create_icons(result)

	for item in result:
		items[item.id] = item

	return result


func _create_item(id: String, name: String, desc: String, type: String, size: Vector2i, max_stack: int):
	var item = ITEM_SCRIPT.new()
	item.id = id
	item.item_name = name
	item.description = desc
	item.item_type = type
	item.base_grid_size = size
	item.max_stack = max_stack
	return item


func _create_icons(item_list: Array):
	var slot_size = 46
	var gap = 3

	for item in item_list:
		var image = Image.new()
		var err = ERR_FILE_NOT_FOUND

		if item.id == ITEM_SWORD:
			err = image.load("res://assets/images/Fly_sword.png")
		elif item.id == ITEM_SHIELD:
			err = image.load("res://assets/images/Eight-Diagram Array.png")

		var w = item.base_grid_size.x * slot_size + (item.base_grid_size.x - 1) * gap
		var h = item.base_grid_size.y * slot_size + (item.base_grid_size.y - 1) * gap

		if err == OK:
			image.resize(w, h, Image.INTERPOLATE_LANCZOS)
			item.icon = ImageTexture.create_from_image(image)
		else:
			image = Image.create(w, h, false, Image.FORMAT_RGBA8)
			if item.item_type == TYPE_WEAPON:
				image.fill(Color(0.7, 0.7, 0.8, 0.8))
			elif item.item_type == TYPE_ARMOR:
				image.fill(Color(0.6, 0.45, 0.25, 0.8))
			elif item.item_type == TYPE_MONSTER_ATTACK:
				image.fill(Color(0.55, 0.75, 0.55, 0.85))
			else:
				image.fill(Color(0.9, 0.3, 0.3, 0.8))
			item.icon = ImageTexture.create_from_image(image)


func get_item_by_id(item_id: String):
	if items.has(item_id):
		return items[item_id].duplicate(true)
	return null


func get_weapons() -> Array:
	return [ITEM_SWORD, ITEM_STICK]


func get_armors() -> Array:
	return [ITEM_SHIELD, ITEM_ARMOR]


func get_consumables() -> Array:
	return [ITEM_POTION_HP, ITEM_POTION_ATK]
