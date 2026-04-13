extends Control

const UI_STYLES = preload("res://ui_styles.gd")

## 怪物方向配置（可被外部修改）
var enemy_direction: String = "right"  # "right", "left", "up", "down"

## 战斗单位
var player_unit
var enemy_unit

## 战斗状态
enum BattleState { PREPARING, FIGHTING, ENDED }
var current_state: BattleState = BattleState.PREPARING

## 攻击计时器
var player_attack_timer: float = 0.0
var enemy_attack_timer: float = 0.0

## 战斗日志
var battle_log: Array[String] = []

## 信号
signal battle_ended(winner: String)
signal log_updated(message: String)

# UI节点
var log_container: VBoxContainer
var battle_info: Label


func _ready():
	_setup_ui()


func _setup_ui():
	var center_wrap = CenterContainer.new()
	center_wrap.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(center_wrap)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 30)
	center_wrap.add_child(hbox)

	var unit_script = load("res://battle_unit.gd")

	# 左侧：玩家单位
	var player_vbox = VBoxContainer.new()
	player_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	player_vbox.custom_minimum_size = Vector2(180, 0)
	hbox.add_child(player_vbox)

	player_unit = Control.new()
	player_unit.set_script(unit_script)
	player_unit.unit_name = "修士"
	player_vbox.add_child(player_unit)
	player_unit.set_color(Color(0.2, 0.5, 0.8))

	# 中间：VS和战斗日志
	var center_container = VBoxContainer.new()
	center_container.alignment = BoxContainer.ALIGNMENT_CENTER
	center_container.custom_minimum_size = Vector2(260, 0)
	hbox.add_child(center_container)

	var vs_label = Label.new()
	vs_label.text = "VS"
	vs_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vs_label.add_theme_font_size_override("font_size", 28)
	vs_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	center_container.add_child(vs_label)

	battle_info = Label.new()
	battle_info.text = "准备战斗"
	battle_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	battle_info.add_theme_font_size_override("font_size", 14)
	UI_STYLES.style_battle_info(battle_info)
	center_container.add_child(battle_info)

	var log_panel = PanelContainer.new()
	log_panel.custom_minimum_size = Vector2(180, 80)
	center_container.add_child(log_panel)

	var log_scroll = ScrollContainer.new()
	log_panel.add_child(log_scroll)

	log_container = VBoxContainer.new()
	log_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_scroll.add_child(log_container)
	UI_STYLES.style_battle_log(log_panel, log_scroll, log_container)

	# 右侧：敌人单位
	var enemy_vbox = VBoxContainer.new()
	enemy_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_vbox.custom_minimum_size = Vector2(180, 0)
	hbox.add_child(enemy_vbox)

	enemy_unit = Control.new()
	enemy_unit.set_script(unit_script)
	enemy_unit.unit_name = "史莱姆"
	enemy_vbox.add_child(enemy_unit)
	enemy_unit.set_color(Color(0.3, 0.7, 0.3))


func start_battle(player_items: Array, monster_items: Array = []):
	current_state = BattleState.FIGHTING

	# 玩家装备根据敌人方向计算攻击力
	# 怪物装备不需要方向判定，直接全额攻击
	player_unit.update_stats_from_inventory(player_items, enemy_direction)

	# 更新怪物基础属性
	enemy_unit.max_hp = 60
	enemy_unit.current_hp = enemy_unit.max_hp
	enemy_unit.base_attack = 5
	enemy_unit.base_defense = 2

	# 怪物装备不传方向参数，全额攻击
	if monster_items.size() > 0:
		enemy_unit.update_stats_from_inventory(monster_items)

	player_attack_timer = 0.0
	enemy_attack_timer = 0.0

	battle_log.clear()
	for child in log_container.get_children():
		child.queue_free()

	_add_log("战斗开始！")
	_add_log("玩家 HP=%d ATK=%d" % [player_unit.max_hp, player_unit.base_attack])
	_add_log("怪物 HP=%d ATK=%d" % [enemy_unit.max_hp, enemy_unit.base_attack])
	battle_info.text = "战斗中..."


func _process(delta):
	if current_state != BattleState.FIGHTING:
		return

	player_attack_timer += delta
	if player_attack_timer >= player_unit.attack_speed:
		player_attack_timer = 0.0
		_perform_attack(player_unit, enemy_unit, "玩家")

	enemy_attack_timer += delta
	if enemy_attack_timer >= enemy_unit.attack_speed:
		enemy_attack_timer = 0.0
		_perform_attack(enemy_unit, player_unit, "怪物")


func _perform_attack(attacker, defender, attacker_name: String):
	attacker.show_attack_effect()

	var damage = attacker.base_attack + randi() % 5
	var died = defender.take_damage(damage)

	_add_log("%s 攻击 %d伤害" % [attacker_name, damage])

	if died:
		current_state = BattleState.ENDED
		var winner = "玩家" if defender == enemy_unit else "怪物"
		_add_log("%s 获胜！" % winner)
		battle_info.text = "%s 获胜！" % winner
		battle_ended.emit(winner)


func _add_log(message: String):
	battle_log.append(message)
	log_updated.emit(message)

	var label = Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 10)
	UI_STYLES.style_battle_log_label(label)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	log_container.add_child(label)


func reset():
	current_state = BattleState.PREPARING
	player_unit.reset()
	enemy_unit.reset()
	battle_info.text = "准备战斗"

	battle_log.clear()
	for child in log_container.get_children():
		child.queue_free()
