extends Control

const UI_STYLES = preload("res://view/ui_styles.gd")
const TEST_ITEMS = preload("res://test_items.gd")
const CHARACTER_DATA = preload("res://data/character_data.gd")
const MONSTER_DATA = preload("res://data/monster_data.gd")
const DEBUG_OVERLAY_SCENE = preload("res://debug_overlay.tscn")

var item_factory: RefCounted
var test_items: Array = []

var character_templates: Dictionary = {}
var monster_templates: Dictionary = {}

var current_character_data
var current_monster_data

var player_inventory
var monster_inventory
var battle_manager
var debug_overlay

enum GameState { PREPARE, BATTLE, RESULT }
var current_state: GameState = GameState.PREPARE


func _ready():
	_init_item_factory()
	_init_character_templates()
	_init_monster_templates()
	_init_default_character()
	_init_default_monster()
	_setup_scene_style()
	_setup_nodes()
	_setup_debug_overlay()
	_add_test_items_to_inventories()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug_overlay") and debug_overlay:
		debug_overlay.toggle()


func _init_item_factory():
	item_factory = TEST_ITEMS.new()
	test_items = item_factory.create_all_items()


func _init_character_templates():
	character_templates.clear()

	var cultivator = CHARACTER_DATA.new()
	cultivator.id = "cultivator"
	cultivator.character_name = "\u4fee\u58eb"
	cultivator.base_hp = 100
	cultivator.base_defense = 5
	cultivator.strength = 2
	cultivator.agility = 3
	cultivator.constitution = 2
	cultivator.display_color = Color(0.2, 0.5, 0.8)
	character_templates[cultivator.id] = cultivator

	var guard = CHARACTER_DATA.new()
	guard.id = "guard"
	guard.character_name = "\u5b88\u536b"
	guard.base_hp = 120
	guard.base_defense = 7
	guard.strength = 3
	guard.agility = 1
	guard.constitution = 3
	guard.display_color = Color(0.30, 0.55, 0.78)
	character_templates[guard.id] = guard

	var rogue = CHARACTER_DATA.new()
	rogue.id = "rogue"
	rogue.character_name = "\u884c\u8005"
	rogue.base_hp = 90
	rogue.base_defense = 4
	rogue.strength = 1
	rogue.agility = 5
	rogue.constitution = 1
	rogue.display_color = Color(0.18, 0.65, 0.72)
	character_templates[rogue.id] = rogue


func _init_monster_templates():
	monster_templates.clear()

	var slime = MONSTER_DATA.new()
	slime.id = "slime"
	slime.monster_name = "\u53f2\u83b1\u59c6"
	slime.base_hp = 180
	slime.base_defense = 2
	slime.strength = 1
	slime.agility = 1
	slime.constitution = 1
	slime.display_color = Color(0.3, 0.7, 0.3)
	slime.default_item_ids = [TEST_ITEMS.ITEM_SLIME_HIT]
	monster_templates[slime.id] = slime

	var wolf = MONSTER_DATA.new()
	wolf.id = "wolf"
	wolf.monster_name = "\u72fc\u5996"
	wolf.base_hp = 75
	wolf.base_defense = 3
	wolf.strength = 2
	wolf.agility = 4
	wolf.constitution = 2
	wolf.display_color = Color(0.55, 0.72, 0.42)
	wolf.default_item_ids = [TEST_ITEMS.ITEM_WOLF_CLAW]
	monster_templates[wolf.id] = wolf

	var golem = MONSTER_DATA.new()
	golem.id = "golem"
	golem.monster_name = "\u77f3\u50cf"
	golem.base_hp = 120
	golem.base_defense = 8
	golem.strength = 5
	golem.agility = 0
	golem.constitution = 4
	golem.display_color = Color(0.55, 0.58, 0.63)
	golem.default_item_ids = [TEST_ITEMS.ITEM_GOLEM_SMASH]
	monster_templates[golem.id] = golem


func _init_default_character():
	current_character_data = _duplicate_template(character_templates.get("cultivator"))


func _init_default_monster():
	current_monster_data = _duplicate_template(monster_templates.get("slime"))


func _setup_scene_style():
	UI_STYLES.setup_scene_background(self)
	UI_STYLES.style_root_layout($MarginContainer, $MarginContainer/VBoxContainer)
	UI_STYLES.style_title($MarginContainer/VBoxContainer/TitleLabel)
	UI_STYLES.style_hint($MarginContainer/VBoxContainer/InfoLabel)
	$MarginContainer/VBoxContainer/BagsHBox.add_theme_constant_override("separation", 16)
	$MarginContainer/VBoxContainer/BattleSection.add_theme_constant_override("separation", 10)
	$MarginContainer/VBoxContainer/BattleSection.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$MarginContainer/VBoxContainer/BattleSection/BattleContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$MarginContainer/VBoxContainer/BattleSection/BattleLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$MarginContainer/VBoxContainer/BattleSection/BattleBtnHBox.size_flags_horizontal = Control.SIZE_FILL
	$MarginContainer/VBoxContainer/InfoLabel.custom_minimum_size = Vector2(0, 36)
	UI_STYLES.style_card($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel, Color(0.16, 0.22, 0.30, 0.95))
	UI_STYLES.style_card($MarginContainer/VBoxContainer/BagsHBox/MonsterPanel, Color(0.21, 0.18, 0.26, 0.95))
	UI_STYLES.style_section_label($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerLabel)
	UI_STYLES.style_section_label($MarginContainer/VBoxContainer/BagsHBox/MonsterPanel/VBox/MonsterLabel)
	UI_STYLES.style_section_label($MarginContainer/VBoxContainer/BattleSection/BattleLabel)
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox/AddWeaponBtn, Color(0.24, 0.47, 0.75))
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox/AddArmorBtn, Color(0.29, 0.58, 0.44))
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox/AddPotionBtn, Color(0.72, 0.41, 0.28))
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox/ClearBtn, Color(0.42, 0.43, 0.48))
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BattleSection/BattleBtnHBox/StartBtn, Color(0.81, 0.34, 0.29))
	UI_STYLES.style_button($MarginContainer/VBoxContainer/BattleSection/BattleBtnHBox/ResetBtn, Color(0.30, 0.52, 0.67))

	$MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox.visible = false


func _setup_nodes():
	var panel_script = load("res://view/inventory_view.gd")

	var player_container = $MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerInventoryContainer
	player_inventory = PanelContainer.new()
	player_inventory.set_script(panel_script)
	player_inventory.columns = 5
	player_inventory.rows = 4
	player_inventory.inventory_changed.connect(_on_player_inventory_changed)
	player_container.add_child(player_inventory)

	var monster_container = $MarginContainer/VBoxContainer/BagsHBox/MonsterPanel/VBox/MonsterInventoryContainer
	monster_inventory = PanelContainer.new()
	monster_inventory.set_script(panel_script)
	monster_inventory.columns = 5
	monster_inventory.rows = 4
	monster_inventory.show_weapon_direction = false
	monster_inventory.inventory_changed.connect(_on_monster_inventory_changed)
	monster_container.add_child(monster_inventory)

	var battle_container = $MarginContainer/VBoxContainer/BattleSection/BattleContainer
	var battle_script = load("res://battle_manager.gd")
	battle_manager = Control.new()
	battle_manager.set_script(battle_script)
	battle_manager.custom_minimum_size = Vector2(400, 180)
	battle_manager.set_anchors_preset(Control.PRESET_FULL_RECT)
	battle_manager.offset_left = 0
	battle_manager.offset_top = 0
	battle_manager.offset_right = 0
	battle_manager.offset_bottom = 0
	battle_manager.battle_ended.connect(_on_battle_ended)
	battle_container.add_child(battle_manager)

	var battle_btn_hbox = $MarginContainer/VBoxContainer/BattleSection/BattleBtnHBox
	battle_btn_hbox.get_node("StartBtn").pressed.connect(_start_battle)
	battle_btn_hbox.get_node("ResetBtn").pressed.connect(_reset_game)


func _setup_debug_overlay():
	debug_overlay = DEBUG_OVERLAY_SCENE.instantiate()
	add_child(debug_overlay)
	_style_debug_overlay()
	debug_overlay.set_character_options(_get_sorted_keys(character_templates))
	debug_overlay.set_monster_options(_get_sorted_keys(monster_templates))
	debug_overlay.set_item_options(_get_all_debug_item_ids())
	debug_overlay.request_set_player_character.connect(_on_debug_set_player_character)
	debug_overlay.request_set_enemy_monster.connect(_on_debug_set_enemy_monster)
	debug_overlay.request_add_item_to_player.connect(_on_debug_add_item_to_player)
	debug_overlay.request_add_item_to_enemy.connect(_on_debug_add_item_to_enemy)
	debug_overlay.request_clear_player.connect(_on_debug_clear_player)
	debug_overlay.request_clear_enemy.connect(_on_debug_clear_enemy)
	debug_overlay.request_clear_all.connect(_on_debug_clear_all)
	debug_overlay.request_start_battle.connect(_on_debug_start_battle)
	debug_overlay.request_reset_battle.connect(_on_debug_reset_battle)
	debug_overlay.request_refresh_state.connect(_on_debug_refresh_state)
	debug_overlay.request_set_enemy_direction.connect(_on_debug_set_enemy_direction)
	debug_overlay.request_print_player_state.connect(_on_debug_print_player_state)
	debug_overlay.request_print_enemy_state.connect(_on_debug_print_enemy_state)
	debug_overlay.append_log("~ \u6253\u5f00/\u5173\u95ed Debug Overlay")


func _style_debug_overlay():
	var panel: PanelContainer = debug_overlay.get_node("Mask/Panel")
	UI_STYLES.style_card(panel, Color(0.10, 0.13, 0.19, 0.97))

	for path in [
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/ApplyPlayerCharacterBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/AddPlayerItemBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/ClearPlayerBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/PrintPlayerBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ApplyEnemyMonsterBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ApplyDirectionBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/AddEnemyItemBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ClearEnemyBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/PrintEnemyBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/StartBattleBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/ResetBattleBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/ClearAllBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/RefreshStateBtn",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/CloseBtn"
	]:
		var button = debug_overlay.get_node(path)
		if button is Button:
			UI_STYLES.style_button(button, Color(0.24, 0.47, 0.75))

	for path in [
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/PlayerSectionLabel",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/EnemySectionLabel",
		"Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/BattleSectionLabel"
	]:
		var label = debug_overlay.get_node(path)
		if label is Label:
			UI_STYLES.style_section_label(label)

	var title = debug_overlay.get_node("Mask/Panel/RootMargin/RootVBox/TitleLabel")
	if title is Label:
		UI_STYLES.style_title(title)

	var log_box = debug_overlay.get_node("Mask/Panel/RootMargin/RootVBox/LogBox")
	if log_box is RichTextLabel:
		log_box.bbcode_enabled = false
		log_box.custom_minimum_size = Vector2(0, 150)
		log_box.add_theme_color_override("default_color", Color(0.86, 0.90, 0.97))


func _add_test_items_to_inventories():
	player_inventory.add_item(item_factory.get_item_by_id(TEST_ITEMS.ITEM_SWORD), 1)
	player_inventory.add_item(item_factory.get_item_by_id(TEST_ITEMS.ITEM_SHIELD), 1)
	_load_monster_default_items()


func _load_monster_default_items():
	if current_monster_data == null:
		return
	for item_id in current_monster_data.default_item_ids:
		var item = item_factory.get_item_by_id(item_id)
		if item:
			monster_inventory.add_item(item, 1)


func _add_item_by_id(panel, item_ids: Array, count: int = 1):
	for id in item_ids:
		var item = item_factory.get_item_by_id(id)
		if item:
			panel.add_item(item, count)
			return


func _start_battle():
	if current_state == GameState.BATTLE:
		return

	current_state = GameState.BATTLE

	var player_items = player_inventory.get_all_items()
	var monster_items = monster_inventory.get_all_items()

	battle_manager.start_battle(current_character_data, player_items, current_monster_data, monster_items)


func _reset_game():
	current_state = GameState.PREPARE
	battle_manager.reset()


func _on_battle_ended(_winner: String):
	current_state = GameState.RESULT


func _on_player_inventory_changed():
	if battle_manager == null or current_state != GameState.BATTLE:
		return

	var player_items = player_inventory.get_all_items()
	battle_manager.refresh_player_side(current_character_data, player_items)


func _on_monster_inventory_changed():
	if battle_manager == null or current_state != GameState.BATTLE:
		return

	var monster_items = monster_inventory.get_all_items()
	battle_manager.refresh_enemy_side(current_monster_data, monster_items)


func _on_debug_set_player_character(character_id: String):
	var template = character_templates.get(character_id)
	if template == null:
		return
	current_character_data = _duplicate_template(template)
	debug_overlay.append_log("玩家角色已切换为：" + current_character_data.character_name)
	_on_debug_refresh_state()


func _on_debug_set_enemy_monster(monster_id: String):
	var template = monster_templates.get(monster_id)
	if template == null:
		return
	current_monster_data = _duplicate_template(template)
	monster_inventory.clear_all()
	_load_monster_default_items()
	debug_overlay.append_log("怪物模板已切换为：" + current_monster_data.monster_name)
	_on_debug_refresh_state()


func _on_debug_add_item_to_player(item_id: String, amount: int):
	var item = item_factory.get_item_by_id(item_id)
	if item:
		player_inventory.add_item(item, amount)


func _on_debug_add_item_to_enemy(item_id: String, amount: int):
	var item = item_factory.get_item_by_id(item_id)
	if item:
		monster_inventory.add_item(item, amount)


func _on_debug_clear_player():
	player_inventory.clear_all()


func _on_debug_clear_enemy():
	monster_inventory.clear_all()


func _on_debug_clear_all():
	player_inventory.clear_all()
	monster_inventory.clear_all()


func _on_debug_start_battle():
	_start_battle()


func _on_debug_reset_battle():
	_reset_game()


func _on_debug_refresh_state():
	if current_state == GameState.BATTLE:
		battle_manager.refresh_player_side(current_character_data, player_inventory.get_all_items())
		battle_manager.refresh_enemy_side(current_monster_data, monster_inventory.get_all_items())
	else:
		debug_overlay.append_log("当前未在战斗中，已保留变更等待开战")


func _on_debug_set_enemy_direction(direction: String):
	DirectionManager.enemy_direction = direction
	debug_overlay.append_log("敌方方向已更新：" + direction)
	_on_debug_refresh_state()


func _on_debug_print_player_state():
	debug_overlay.append_log(_build_unit_state_text(current_character_data, player_inventory.get_all_items()))


func _on_debug_print_enemy_state():
	debug_overlay.append_log(_build_unit_state_text(current_monster_data, monster_inventory.get_all_items()))


func _build_unit_state_text(unit_data, items: Array) -> String:
	var item_names: Array = []
	for item in items:
		if item != null:
			item_names.append(item.item_name)

	var name = "\u672a\u77e5"
	if unit_data != null:
		var character_name = unit_data.get("character_name")
		var monster_name = unit_data.get("monster_name")
		if character_name != null and character_name != "":
			name = character_name
		elif monster_name != null and monster_name != "":
			name = monster_name
	var hp = unit_data.base_hp if unit_data else 0
	var defense = unit_data.base_defense if unit_data else 0
	return "%s | base_hp=%d | base_def=%d | items=%s" % [name, hp, defense, ",".join(item_names)]


func _get_all_debug_item_ids() -> Array:
	var ids: Array = item_factory.items.keys()
	ids.sort()
	return ids


func _get_sorted_keys(source: Dictionary) -> Array:
	var keys: Array = source.keys()
	keys.sort()
	return keys


func _duplicate_template(template):
	return template.duplicate(true) if template != null else null
