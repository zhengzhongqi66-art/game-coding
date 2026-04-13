extends Control

const UI_STYLES = preload("res://ui_styles.gd")

var test_items = []
var player_inventory
var monster_inventory
var battle_manager

enum GameState { PREPARE, BATTLE, RESULT }
var current_state: GameState = GameState.PREPARE


func _ready():
	_setup_scene_style()
	_create_test_items()
	_setup_nodes()
	_add_test_items_to_inventories()


func _create_test_items():
	var item_script = load("res://item_data.gd")

	# 飞剑 - 3x2格子
	var sword1 = item_script.new()
	sword1.id = "sword_001"
	sword1.item_name = "飞剑"
	sword1.description = "基础武器"
	sword1.max_stack = 1
	sword1.item_type = "武器"
	sword1.base_grid_size = Vector2i(3, 2)
	sword1.attack_bonus = 15
	sword1.rotation = 0
	test_items.append(sword1)

	# 木棍 - 3x1格子 (怪物武器)
	var stick = item_script.new()
	stick.id = "stick_001"
	stick.item_name = "木棍"
	stick.description = "简陋武器"
	stick.max_stack = 1
	stick.item_type = "武器"
	stick.base_grid_size = Vector2i(3, 1)
	stick.attack_bonus = 5
	stick.rotation = 0
	test_items.append(stick)

	# 八卦阵 - 2x2格子
	var shield1 = item_script.new()
	shield1.id = "shield_001"
	shield1.item_name = "八卦阵"
	shield1.description = "基础防具"
	shield1.max_stack = 1
	shield1.item_type = "防具"
	shield1.base_grid_size = Vector2i(2, 2)
	shield1.defense_bonus = 10
	shield1.hp_bonus = 20
	test_items.append(shield1)

	# 铁甲 - 2x2格子
	var armor1 = item_script.new()
	armor1.id = "armor_001"
	armor1.item_name = "铁甲"
	armor1.description = "高级防具"
	armor1.max_stack = 1
	armor1.item_type = "防具"
	armor1.base_grid_size = Vector2i(2, 2)
	armor1.defense_bonus = 15
	armor1.hp_bonus = 50
	test_items.append(armor1)

	# 生命药水 - 1x1
	var potion1 = item_script.new()
	potion1.id = "potion_hp"
	potion1.item_name = "生命药水"
	potion1.description = "生命+5"
	potion1.max_stack = 99
	potion1.item_type = "消耗品"
	potion1.base_grid_size = Vector2i(1, 1)
	potion1.hp_bonus = 5
	test_items.append(potion1)

	# 力量药水 - 1x1
	var potion2 = item_script.new()
	potion2.id = "potion_atk"
	potion2.item_name = "力量药水"
	potion2.description = "攻击+3"
	potion2.max_stack = 99
	potion2.item_type = "消耗品"
	potion2.base_grid_size = Vector2i(1, 1)
	potion2.attack_bonus = 3
	test_items.append(potion2)

	_create_item_icons()


func _create_item_icons():
	var slot_size = 46
	var gap = 3

	for item in test_items:
		var image = Image.new()
		var err = ERR_FILE_NOT_FOUND

		if item.id == "sword_001":
			err = image.load("res://assets/images/Fly_sword.png")
		elif item.id == "shield_001":
			err = image.load("res://assets/images/Eight-Diagram Array.png")

		# 使用基础尺寸创建图标
		var w = item.base_grid_size.x * slot_size + (item.base_grid_size.x - 1) * gap
		var h = item.base_grid_size.y * slot_size + (item.base_grid_size.y - 1) * gap

		if err == OK:
			image.resize(w, h, Image.INTERPOLATE_LANCZOS)
			item.icon = ImageTexture.create_from_image(image)
		else:
			image = Image.create(w, h, false, Image.FORMAT_RGBA8)
			if item.item_type == "武器":
				image.fill(Color(0.7, 0.7, 0.8, 0.8))
			elif item.item_type == "防具":
				image.fill(Color(0.6, 0.45, 0.25, 0.8))
			else:
				image.fill(Color(0.9, 0.3, 0.3, 0.8))
			item.icon = ImageTexture.create_from_image(image)


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


func _setup_nodes():
	var panel_script = load("res://inventory_panel.gd")

	# 玩家背包
	var player_container = $MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerInventoryContainer
	player_inventory = PanelContainer.new()
	player_inventory.set_script(panel_script)
	player_inventory.columns = 5
	player_inventory.rows = 4
	player_container.add_child(player_inventory)

	# 怪物背包
	var monster_container = $MarginContainer/VBoxContainer/BagsHBox/MonsterPanel/VBox/MonsterInventoryContainer
	monster_inventory = PanelContainer.new()
	monster_inventory.set_script(panel_script)
	monster_inventory.columns = 5
	monster_inventory.rows = 4
	monster_inventory.show_weapon_direction = false  # 怪物不显示武器方向
	monster_container.add_child(monster_inventory)

	# 战斗管理器
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

	# 玩家按钮
	var player_btn_hbox = $MarginContainer/VBoxContainer/BagsHBox/PlayerPanel/VBox/PlayerBtnHBox
	player_btn_hbox.get_node("AddWeaponBtn").pressed.connect(func(): _add_random_item(player_inventory, ["sword_001"]))
	player_btn_hbox.get_node("AddArmorBtn").pressed.connect(func(): _add_random_item(player_inventory, ["shield_001", "armor_001"]))
	player_btn_hbox.get_node("AddPotionBtn").pressed.connect(func(): _add_item(player_inventory, test_items[4], 5))
	player_btn_hbox.get_node("ClearBtn").pressed.connect(func(): player_inventory.clear_all())

	# 战斗按钮
	var battle_btn_hbox = $MarginContainer/VBoxContainer/BattleSection/BattleBtnHBox
	battle_btn_hbox.get_node("StartBtn").pressed.connect(_start_battle)
	battle_btn_hbox.get_node("ResetBtn").pressed.connect(_reset_game)


func _add_test_items_to_inventories():
	# 玩家初始装备
	player_inventory.add_item(test_items[0], 1)  # 飞剑
	player_inventory.add_item(test_items[2], 1)  # 八卦阵

	# 怪物初始装备 - 木棍
	monster_inventory.add_item(test_items[1], 1)  # 木棍


func _add_item(panel, item, count: int):
	panel.add_item(item, count)


func _add_random_item(panel, item_ids: Array):
	for id in item_ids:
		for item in test_items:
			if item.id == id:
				panel.add_item(item, 1)
				return


func _start_battle():
	if current_state == GameState.BATTLE:
		return

	current_state = GameState.BATTLE

	var player_items = player_inventory.get_all_items()
	var monster_items = monster_inventory.get_all_items()

	battle_manager.start_battle(player_items, monster_items)


func _reset_game():
	current_state = GameState.PREPARE
	battle_manager.reset()


func _on_battle_ended(winner: String):
	current_state = GameState.RESULT
