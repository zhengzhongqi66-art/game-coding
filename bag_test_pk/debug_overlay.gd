extends CanvasLayer

signal request_set_player_character(character_id: String)
signal request_set_enemy_monster(monster_id: String)
signal request_add_item_to_player(item_id: String, amount: int)
signal request_add_item_to_enemy(item_id: String, amount: int)
signal request_clear_player()
signal request_clear_enemy()
signal request_clear_all()
signal request_start_battle()
signal request_reset_battle()
signal request_refresh_state()
signal request_set_enemy_direction(direction: String)
signal request_print_player_state()
signal request_print_enemy_state()

@onready var player_character_option: OptionButton = $Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/PlayerCharacterOption
@onready var add_player_item_option: OptionButton = $Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/AddPlayerItemOption
@onready var player_item_count_spin: SpinBox = $Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/PlayerItemCountSpin
@onready var enemy_monster_option: OptionButton = $Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/EnemyMonsterOption
@onready var enemy_direction_option: OptionButton = $Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/EnemyDirectionOption
@onready var add_enemy_item_option: OptionButton = $Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/AddEnemyItemOption
@onready var enemy_item_count_spin: SpinBox = $Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/EnemyItemCountSpin
@onready var log_box: RichTextLabel = $Mask/Panel/RootMargin/RootVBox/LogBox

var _character_ids: Array = []
var _monster_ids: Array = []
var _item_ids: Array = []


func _ready():
	visible = false
	layer = 100
	_bind_buttons()
	_set_default_directions()


func open():
	visible = true


func close():
	visible = false


func toggle():
	visible = not visible


func append_log(message: String):
	if log_box == null:
		return
	log_box.text += message + "\n"
	log_box.scroll_to_line(log_box.get_line_count())


func set_character_options(character_ids: Array):
	_character_ids = character_ids.duplicate()
	_fill_option(player_character_option, _character_ids)


func set_monster_options(monster_ids: Array):
	_monster_ids = monster_ids.duplicate()
	_fill_option(enemy_monster_option, _monster_ids)


func set_item_options(item_ids: Array):
	_item_ids = item_ids.duplicate()
	_fill_option(add_player_item_option, _item_ids)
	_fill_option(add_enemy_item_option, _item_ids)


func _bind_buttons():
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/ApplyPlayerCharacterBtn.pressed.connect(_on_apply_player_character_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/AddPlayerItemBtn.pressed.connect(_on_add_player_item_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/ClearPlayerBtn.pressed.connect(_on_clear_player_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/LeftPanel/PrintPlayerBtn.pressed.connect(_on_print_player_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ApplyEnemyMonsterBtn.pressed.connect(_on_apply_enemy_monster_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ApplyDirectionBtn.pressed.connect(_on_apply_direction_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/AddEnemyItemBtn.pressed.connect(_on_add_enemy_item_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/ClearEnemyBtn.pressed.connect(_on_clear_enemy_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/MiddlePanel/PrintEnemyBtn.pressed.connect(_on_print_enemy_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/StartBattleBtn.pressed.connect(_on_start_battle_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/ResetBattleBtn.pressed.connect(_on_reset_battle_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/ClearAllBtn.pressed.connect(_on_clear_all_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/RefreshStateBtn.pressed.connect(_on_refresh_state_btn_pressed)
	$Mask/Panel/RootMargin/RootVBox/ContentHBox/RightPanel/CloseBtn.pressed.connect(close)


func _set_default_directions():
	_fill_option(enemy_direction_option, ["right", "down", "left", "up"])


func _fill_option(option: OptionButton, values: Array):
	if option == null:
		return
	option.clear()
	for value in values:
		option.add_item(str(value))
	if option.item_count > 0:
		option.select(0)


func _get_selected_text(option: OptionButton) -> String:
	if option == null or option.item_count == 0 or option.selected < 0:
		return ""
	return option.get_item_text(option.selected)


func _on_apply_player_character_btn_pressed():
	var character_id = _get_selected_text(player_character_option)
	if character_id == "":
		return
	request_set_player_character.emit(character_id)
	append_log("\u5207\u6362\u73a9\u5bb6\u89d2\u8272\uff1a" + character_id)


func _on_add_player_item_btn_pressed():
	var item_id = _get_selected_text(add_player_item_option)
	if item_id == "":
		return
	var amount = int(player_item_count_spin.value)
	request_add_item_to_player.emit(item_id, amount)
	append_log("\u7ed9\u73a9\u5bb6\u6dfb\u52a0\u9053\u5177\uff1a%s x%d" % [item_id, amount])


func _on_clear_player_btn_pressed():
	request_clear_player.emit()
	append_log("\u5df2\u6e05\u7a7a\u73a9\u5bb6\u80cc\u5305")


func _on_print_player_btn_pressed():
	request_print_player_state.emit()


func _on_apply_enemy_monster_btn_pressed():
	var monster_id = _get_selected_text(enemy_monster_option)
	if monster_id == "":
		return
	request_set_enemy_monster.emit(monster_id)
	append_log("\u5207\u6362\u602a\u7269\u6a21\u677f\uff1a" + monster_id)


func _on_apply_direction_btn_pressed():
	var direction = _get_selected_text(enemy_direction_option)
	if direction == "":
		return
	request_set_enemy_direction.emit(direction)
	append_log("\u654c\u4eba\u65b9\u5411\u5207\u6362\u4e3a\uff1a" + direction)


func _on_add_enemy_item_btn_pressed():
	var item_id = _get_selected_text(add_enemy_item_option)
	if item_id == "":
		return
	var amount = int(enemy_item_count_spin.value)
	request_add_item_to_enemy.emit(item_id, amount)
	append_log("\u7ed9\u602a\u7269\u6dfb\u52a0\u9053\u5177\uff1a%s x%d" % [item_id, amount])


func _on_clear_enemy_btn_pressed():
	request_clear_enemy.emit()
	append_log("\u5df2\u6e05\u7a7a\u602a\u7269\u80cc\u5305")


func _on_print_enemy_btn_pressed():
	request_print_enemy_state.emit()


func _on_start_battle_btn_pressed():
	request_start_battle.emit()
	append_log("\u8bf7\u6c42\u5f00\u59cb\u6218\u6597")


func _on_reset_battle_btn_pressed():
	request_reset_battle.emit()
	append_log("\u8bf7\u6c42\u91cd\u7f6e\u6218\u6597")


func _on_clear_all_btn_pressed():
	request_clear_all.emit()
	append_log("\u5df2\u8bf7\u6c42\u6e05\u7a7a\u53cc\u65b9\u80cc\u5305")


func _on_refresh_state_btn_pressed():
	request_refresh_state.emit()
	append_log("\u8bf7\u6c42\u5237\u65b0\u5f53\u524d\u72b6\u6001")
