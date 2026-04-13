extends RefCounted


static func setup_scene_background(root: Control):
	var background = ColorRect.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.07, 0.09, 0.14, 1.0)
	root.add_child(background)
	root.move_child(background, 0)

	var glow = ColorRect.new()
	glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	glow.color = Color(0.06, 0.18, 0.22, 0.22)
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(glow)
	root.move_child(glow, 1)


static func style_root_layout(margin: MarginContainer, root: VBoxContainer):
	root.add_theme_constant_override("separation", 14)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 14)


static func style_title(label: Label):
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(0.93, 0.95, 1.0))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


static func style_hint(label: Label):
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.72, 0.78, 0.88))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = false


static func style_card(panel: PanelContainer, bg_color: Color):
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = bg_color.lightened(0.22)
	style.shadow_color = Color(0, 0, 0, 0.28)
	style.shadow_size = 10
	style.shadow_offset = Vector2(0, 4)
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	panel.add_theme_stylebox_override("panel", style)

	var inner = panel.get_child(0)
	if inner is VBoxContainer:
		inner.add_theme_constant_override("separation", 10)


static func style_section_label(label: Label):
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.92, 0.95, 1.0))


static func style_button(button: Button, color: Color):
	button.custom_minimum_size = Vector2(72, 32)
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_color_override("font_color", Color(1, 1, 1))

	var normal = StyleBoxFlat.new()
	normal.bg_color = color
	normal.border_color = color.lightened(0.18)
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(10)

	var hover = normal.duplicate()
	hover.bg_color = color.lightened(0.08)
	hover.border_color = color.lightened(0.26)

	var pressed = normal.duplicate()
	pressed.bg_color = color.darkened(0.12)
	pressed.border_color = color.darkened(0.04)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", hover)


static func style_inventory_panel(panel: PanelContainer):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.12, 0.18, 0.94)
	style.border_color = Color(0.25, 0.34, 0.48, 1.0)
	style.shadow_color = Color(0, 0, 0, 0.25)
	style.shadow_size = 10
	style.shadow_offset = Vector2(0, 4)
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", style)


static func style_inventory_slot(slot: PanelContainer):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.17, 0.20, 0.28, 0.88)
	style.border_color = Color(0.39, 0.50, 0.64, 0.9)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	slot.add_theme_stylebox_override("panel", style)


static func style_tooltip(panel: PanelContainer):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.16, 0.95)
	style.border_color = Color(0.45, 0.55, 0.70, 0.9)
	style.shadow_color = Color(0, 0, 0, 0.24)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 3)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", style)


static func style_battle_info(label: Label):
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.88, 0.93, 1.0))


static func style_battle_log(panel: PanelContainer, scroll: ScrollContainer, container: VBoxContainer):
	panel.custom_minimum_size = Vector2(220, 110)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var log_style = StyleBoxFlat.new()
	log_style.bg_color = Color(0.10, 0.13, 0.19, 0.92)
	log_style.border_color = Color(0.26, 0.34, 0.46, 1.0)
	log_style.shadow_color = Color(0, 0, 0, 0.22)
	log_style.shadow_size = 8
	log_style.shadow_offset = Vector2(0, 3)
	log_style.set_border_width_all(1)
	log_style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", log_style)

	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	container.add_theme_constant_override("separation", 4)


static func style_battle_log_label(label: Label):
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.82, 0.88, 0.97))


static func style_unit_name(label: Label):
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.92, 0.95, 1.0))


static func style_unit_sprite(sprite: ColorRect):
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.color = sprite.color


static func style_hp_bar(bar: ProgressBar):
	bar.custom_minimum_size = Vector2(110, 16)
	bar.add_theme_color_override("font_color", Color(1, 1, 1, 0))
	var bg = StyleBoxFlat.new()
	bg.bg_color = Color(0.12, 0.15, 0.21, 1.0)
	bg.set_corner_radius_all(8)
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color(0.34, 0.79, 0.48, 1.0)
	fill.set_corner_radius_all(8)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fill)


static func style_hp_label(label: Label):
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.84, 0.90, 0.97))


static func style_attack_indicator(label: Label):
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
