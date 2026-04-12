extends Control

var test_items = []
var inventory_panel
var battle_manager

enum GameState { PREPARE, BATTLE, RESULT }
var current_state: GameState = GameState.PREPARE


func _ready():
	_create_test_items()
	_setup_nodes()
	_add_test_items_to_inventory()


func _create_test_items():
	var item_script = load("res://item_data.gd")

	# 飞剑 - 3x2格子
	var sword1 = item_script.new()
	sword1.id = "sword_001"
	sword1.item_name = "飞剑"
	sword1.description = "基础武器"
	sword1.max_stack = 1
	sword1.item_type = "武器"
	sword1.grid_size = Vector2i(3, 2)
	sword1.attack_bonus = 15
	sword1.direction = 0
	test_items.append(sword1)

	# 八卦阵 - 2x2格子
	var shield1 = item_script.new()
	shield1.id = "shield_001"
	shield1.item_name = "八卦阵"
	shield1.description = "基础防具"
	shield1.max_stack = 1
	shield1.item_type = "防具"
	shield1.grid_size = Vector2i(2, 2)
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
	armor1.grid_size = Vector2i(2, 2)
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
	potion1.grid_size = Vector2i(1, 1)
	potion1.hp_bonus = 5
	test_items.append(potion1)

	# 力量药水 - 1x1
	var potion2 = item_script.new()
	potion2.id = "potion_atk"
	potion2.item_name = "力量药水"
	potion2.description = "攻击+3"
	potion2.max_stack = 99
	potion2.item_type = "消耗品"
	potion2.grid_size = Vector2i(1, 1)
	potion2.attack_bonus = 3
	test_items.append(potion2)

	_create_item_icons()


func _create_item_icons():
	# 格子尺寸
	var slot_size = 46
	var gap = 3

	for item in test_items:
		var image = Image.new()
		var err = ERR_FILE_NOT_FOUND

		if item.id == "sword_001":
			err = image.load("res://assets/images/Fly_sword.png")
		elif item.id == "shield_001":
			err = image.load("res://assets/images/Eight-Diagram Array.png")

		if err == OK:
			# 计算目标尺寸
			var w = item.grid_size.x * slot_size + (item.grid_size.x - 1) * gap
			var h = item.grid_size.y * slot_size + (item.grid_size.y - 1) * gap
			# 缩放图片到格子大小
			image.resize(w, h, Image.INTERPOLATE_LANCZOS)
			item.icon = ImageTexture.create_from_image(image)
		else:
			# 创建默认图标
			var w = item.grid_size.x * slot_size + (item.grid_size.x - 1) * gap
			var h = item.grid_size.y * slot_size + (item.grid_size.y - 1) * gap
			image = Image.create(w, h, false, Image.FORMAT_RGBA8)
			if item.item_type == "武器":
				image.fill(Color(0.7, 0.7, 0.8, 0.8))
			elif item.item_type == "防具":
				image.fill(Color(0.6, 0.45, 0.25, 0.8))
			else:
				image.fill(Color(0.9, 0.3, 0.3, 0.8))
			item.icon = ImageTexture.create_from_image(image)


func _setup_nodes():
	var inventory_container = $MarginContainer/VBoxContainer/HBoxContainer/LeftPanel/VBox/InventoryContainer

	var panel_script = load("res://inventory_panel.gd")
	inventory_panel = PanelContainer.new()
	inventory_panel.set_script(panel_script)
	inventory_container.add_child(inventory_panel)

	var battle_container = $MarginContainer/VBoxContainer/HBoxContainer/RightPanel/VBox/BattleContainer

	var battle_script = load("res://battle_manager.gd")
	battle_manager = Control.new()
	battle_manager.set_script(battle_script)
	battle_manager.custom_minimum_size = Vector2(400, 220)
	battle_manager.battle_ended.connect(_on_battle_ended)
	battle_container.add_child(battle_manager)

	var btn_hbox = $MarginContainer/VBoxContainer/HBoxContainer/LeftPanel/VBox/BtnHBox
	btn_hbox.get_node("AddWeaponBtn").pressed.connect(func(): _add_random_item(["sword_001"]))
	btn_hbox.get_node("AddArmorBtn").pressed.connect(func(): _add_random_item(["shield_001", "armor_001"]))
	btn_hbox.get_node("AddPotionBtn").pressed.connect(func(): _add_item(test_items[3], 5))
	btn_hbox.get_node("ClearBtn").pressed.connect(func(): inventory_panel.clear_all())

	var battle_btn_hbox = $MarginContainer/VBoxContainer/HBoxContainer/RightPanel/VBox/BattleBtnHBox
	battle_btn_hbox.get_node("StartBtn").pressed.connect(_start_battle)
	battle_btn_hbox.get_node("ResetBtn").pressed.connect(_reset_game)


func _add_test_items_to_inventory():
	inventory_panel.add_item(test_items[0], 1)  # 飞剑
	inventory_panel.add_item(test_items[1], 1)  # 八卦阵


func _add_item(item, count: int):
	inventory_panel.add_item(item, count)


func _add_random_item(item_ids: Array):
	for id in item_ids:
		for item in test_items:
			if item.id == id:
				inventory_panel.add_item(item, 1)
				return


func _start_battle():
	if current_state == GameState.BATTLE:
		return

	current_state = GameState.BATTLE

	var items = inventory_panel.get_all_items()
	battle_manager.start_battle(items)


func _reset_game():
	current_state = GameState.PREPARE
	battle_manager.reset()


func _on_battle_ended(winner: String):
	current_state = GameState.RESULT
