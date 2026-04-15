extends Control

const BATTLE_RESOLVER = preload("res://logic/battle_resolver.gd")
const ITEM_RUNTIME = preload("res://data/item_runtime.gd")
const ITEM_STATE_CALCULATOR = preload("res://logic/item_state_calculator.gd")

const LABEL_PLAYER = "\u73a9\u5bb6"
const LABEL_MONSTER = "\u602a\u7269"

var battle_view
var player_unit
var enemy_unit

enum BattleState { PREPARING, FIGHTING, ENDED }
var current_state: BattleState = BattleState.PREPARING

var current_player_data = null
var current_monster_data = null
var player_item_runtimes: Array = []
var enemy_item_runtimes: Array = []
var battle_log: Array[String] = []

var battle_resolver: RefCounted
var item_state_calculator: RefCounted

signal battle_ended(winner: String)
signal log_updated(message: String)


func _ready():
	battle_resolver = BATTLE_RESOLVER.new()
	item_state_calculator = ITEM_STATE_CALCULATOR.new()
	_setup_view()


func _setup_view():
	var view_script = load("res://view/battle_view.gd")
	battle_view = Control.new()
	battle_view.set_script(view_script)
	battle_view.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	battle_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(battle_view)

	player_unit = battle_view.get_player_unit()
	enemy_unit = battle_view.get_enemy_unit()


func _build_item_runtimes(items: Array, owner = null) -> Array:
	var result = []
	for item in items:
		if item == null:
			continue

		var item_runtime = ITEM_RUNTIME.new(item)
		item_runtime.owner = owner
		item_state_calculator.recalc_item_runtime(item_runtime)
		result.append(item_runtime)
	return result


func _sum_defense(items: Array) -> int:
	var total = 0
	for item in items:
		if item != null:
			total += item.defense_bonus
	return total


func _sum_hp(items: Array) -> int:
	var total = 0
	for item in items:
		if item != null:
			total += item.hp_bonus
	return total


func _has_attack_items(item_runtimes: Array) -> bool:
	for item_runtime in item_runtimes:
		if item_runtime == null or item_runtime.data == null:
			continue
		if item_runtime.current_behavior_type == "weapon_attack":
			return true
	return false


func start_battle(player_data, player_items: Array, monster_data, monster_items: Array = []):
	current_state = BattleState.FIGHTING
	current_player_data = player_data
	current_monster_data = monster_data

	if player_data:
		battle_view.set_player_display(player_data.character_name, player_data.display_color)
	else:
		battle_view.set_player_display(LABEL_PLAYER, Color(0.2, 0.5, 0.8))

	if monster_data:
		battle_view.set_enemy_display(monster_data.monster_name, monster_data.display_color)
	else:
		battle_view.set_enemy_display(LABEL_MONSTER, Color(0.3, 0.7, 0.3))

	refresh_player_side(player_data, player_items)
	refresh_enemy_side(monster_data, monster_items)

	battle_log.clear()
	battle_view.clear_logs()

	_add_log("\u6218\u6597\u5f00\u59cb\uff01")
	_add_log("%s HP=%d DEF=%d" % [battle_view.get_player_unit().unit_name, player_unit.max_hp, player_unit.base_defense])
	_add_log("%s HP=%d DEF=%d" % [battle_view.get_enemy_unit().unit_name, enemy_unit.max_hp, enemy_unit.base_defense])

	var player_can_attack = _has_attack_items(player_item_runtimes)
	var enemy_can_attack = _has_attack_items(enemy_item_runtimes)

	if not player_can_attack:
		_add_log("\u73a9\u5bb6\u5f53\u524d\u6ca1\u6709\u53ef\u653b\u51fb\u6b66\u5668")

	if not enemy_can_attack:
		_add_log("\u602a\u7269\u5f53\u524d\u6ca1\u6709\u53ef\u653b\u51fb\u624b\u6bb5")

	if not player_can_attack and not enemy_can_attack:
		current_state = BattleState.ENDED
		_add_log("\u53cc\u65b9\u90fd\u6ca1\u6709\u53ef\u653b\u51fb\u624b\u6bb5\uff0c\u6218\u6597\u65e0\u6cd5\u8fdb\u884c")
		battle_view.set_battle_info("\u65e0\u6cd5\u6218\u6597")
		return

	battle_view.set_battle_info("\u6218\u6597\u4e2d...")


func refresh_player_side(player_data, player_items: Array):
	current_player_data = player_data
	var player_base_hp = player_data.base_hp if player_data else 100
	var player_base_defense = player_data.base_defense if player_data else 5

	var old_max_hp = player_unit.max_hp
	player_unit.max_hp = player_base_hp + _sum_hp(player_items)
	player_unit.base_defense = player_base_defense + _sum_defense(player_items)

	if player_unit.current_hp > player_unit.max_hp:
		player_unit.current_hp = player_unit.max_hp
	elif player_unit.current_hp == old_max_hp:
		player_unit.current_hp = player_unit.max_hp

	player_unit._update_hp_display()
	player_item_runtimes = _build_item_runtimes(player_items, player_data)


func refresh_enemy_side(monster_data, monster_items: Array):
	current_monster_data = monster_data
	var monster_base_hp = monster_data.base_hp if monster_data else 60
	var monster_base_defense = monster_data.base_defense if monster_data else 2

	var old_max_hp = enemy_unit.max_hp
	enemy_unit.max_hp = monster_base_hp + _sum_hp(monster_items)
	enemy_unit.base_defense = monster_base_defense + _sum_defense(monster_items)

	if enemy_unit.current_hp > enemy_unit.max_hp:
		enemy_unit.current_hp = enemy_unit.max_hp
	elif enemy_unit.current_hp == old_max_hp:
		enemy_unit.current_hp = enemy_unit.max_hp

	enemy_unit._update_hp_display()
	enemy_item_runtimes = _build_item_runtimes(monster_items, monster_data)


func _process(delta):
	if current_state != BattleState.FIGHTING:
		return

	for item_runtime in player_item_runtimes:
		if item_runtime.current_behavior_type != "weapon_attack":
			continue

		item_runtime.cooldown_timer += delta
		if item_runtime.cooldown_timer >= item_runtime.current_attack_speed:
			item_runtime.cooldown_timer = 0.0
			_perform_item_attack(item_runtime, enemy_unit, battle_view.get_player_unit().unit_name)

			if current_state != BattleState.FIGHTING:
				return

	for item_runtime in enemy_item_runtimes:
		if item_runtime.current_behavior_type != "weapon_attack":
			continue

		item_runtime.cooldown_timer += delta
		if item_runtime.cooldown_timer >= item_runtime.current_attack_speed:
			item_runtime.cooldown_timer = 0.0
			_perform_item_attack(item_runtime, player_unit, battle_view.get_enemy_unit().unit_name)

			if current_state != BattleState.FIGHTING:
				return


func _perform_item_attack(item_runtime, defender, attacker_name: String):
	if item_runtime == null or item_runtime.data == null:
		return

	if defender == enemy_unit:
		player_unit.show_attack_effect()
	else:
		enemy_unit.show_attack_effect()

	var damage = battle_resolver.calculate_damage(item_runtime.current_attack, defender.base_defense)
	var died = defender.take_damage(damage)

	_add_log("%s[%s] \u653b\u51fb %d\u4f24\u5bb3" % [attacker_name, item_runtime.data.item_name, damage])

	if died:
		current_state = BattleState.ENDED
		var winner = attacker_name
		_add_log("%s \u83b7\u80dc\uff01" % winner)
		battle_view.set_battle_info("%s \u83b7\u80dc\uff01" % winner)
		battle_ended.emit(winner)


func _add_log(message: String):
	battle_log.append(message)
	log_updated.emit(message)
	battle_view.add_log(message)


func reset():
	current_state = BattleState.PREPARING
	current_player_data = null
	current_monster_data = null
	player_item_runtimes.clear()
	enemy_item_runtimes.clear()
	player_unit.reset()
	enemy_unit.reset()
	battle_view.set_player_display(LABEL_PLAYER, Color(0.2, 0.5, 0.8))
	battle_view.set_enemy_display(LABEL_MONSTER, Color(0.3, 0.7, 0.3))
	battle_view.set_battle_info("\u51c6\u5907\u6218\u6597")

	battle_log.clear()
	battle_view.clear_logs()
