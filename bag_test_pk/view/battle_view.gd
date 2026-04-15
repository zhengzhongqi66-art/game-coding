extends Control

const UI_STYLES = preload("res://view/ui_styles.gd")

var player_unit_view
var enemy_unit_view

var log_container: VBoxContainer
var battle_info: Label

signal view_ready()


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

	var unit_script = load("res://view/battle_unit_view.gd")

	var player_vbox = VBoxContainer.new()
	player_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	player_vbox.custom_minimum_size = Vector2(180, 0)
	hbox.add_child(player_vbox)

	player_unit_view = Control.new()
	player_unit_view.set_script(unit_script)
	player_unit_view.unit_name = "\u4fee\u58eb"
	player_vbox.add_child(player_unit_view)
	player_unit_view.set_color(Color(0.2, 0.5, 0.8))

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
	battle_info.text = "\u51c6\u5907\u6218\u6597"
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

	var enemy_vbox = VBoxContainer.new()
	enemy_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_vbox.custom_minimum_size = Vector2(180, 0)
	hbox.add_child(enemy_vbox)

	enemy_unit_view = Control.new()
	enemy_unit_view.set_script(unit_script)
	enemy_unit_view.unit_name = "\u53f2\u83b1\u59c6"
	enemy_vbox.add_child(enemy_unit_view)
	enemy_unit_view.set_color(Color(0.3, 0.7, 0.3))

	view_ready.emit()


func add_log(message: String):
	var label = Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 10)
	UI_STYLES.style_battle_log_label(label)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	log_container.add_child(label)


func clear_logs():
	for child in log_container.get_children():
		child.queue_free()


func set_battle_info(text: String):
	if battle_info:
		battle_info.text = text


func set_player_display(name: String, color: Color):
	if player_unit_view:
		player_unit_view.unit_name = name
		if player_unit_view.name_label:
			player_unit_view.name_label.text = name
		player_unit_view.set_color(color)


func set_enemy_display(name: String, color: Color):
	if enemy_unit_view:
		enemy_unit_view.unit_name = name
		if enemy_unit_view.name_label:
			enemy_unit_view.name_label.text = name
		enemy_unit_view.set_color(color)


func get_player_unit():
	return player_unit_view


func get_enemy_unit():
	return enemy_unit_view
