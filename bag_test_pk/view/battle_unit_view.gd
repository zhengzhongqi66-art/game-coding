extends Control

const UI_STYLES = preload("res://view/ui_styles.gd")
const UNIT_STATS = preload("res://data/unit_stats.gd")

@export var unit_name: String = "角色"

var _stats: Resource

var unit_sprite: ColorRect
var hp_bar: ProgressBar
var hp_label: Label
var name_label: Label
var attack_indicator: Label
var original_position: Vector2

signal unit_died(unit)

var max_hp: int:
	get:
		return _stats.max_hp if _stats else 100
	set(value):
		if _stats:
			_stats.max_hp = value

var current_hp: int:
	get:
		return _stats.current_hp if _stats else 0
	set(value):
		if _stats:
			_stats.current_hp = value

var base_defense: int:
	get:
		return _stats.base_defense if _stats else 5
	set(value):
		if _stats:
			_stats.base_defense = value


func _ready():
	_init_stats()
	_setup_ui()


func _init_stats():
	_stats = UNIT_STATS.new()
	_stats.unit_name = unit_name
	_stats.reset_hp()


func _setup_ui():
	custom_minimum_size = Vector2(120, 160)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(vbox)

	name_label = Label.new()
	name_label.text = unit_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 14)
	UI_STYLES.style_unit_name(name_label)
	vbox.add_child(name_label)

	var sprite_container = CenterContainer.new()
	sprite_container.custom_minimum_size = Vector2(100, 100)
	vbox.add_child(sprite_container)

	unit_sprite = ColorRect.new()
	unit_sprite.custom_minimum_size = Vector2(60, 80)
	unit_sprite.color = Color(0.3, 0.5, 0.8)
	UI_STYLES.style_unit_sprite(unit_sprite)
	sprite_container.add_child(unit_sprite)

	attack_indicator = Label.new()
	attack_indicator.text = ""
	attack_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	attack_indicator.add_theme_font_size_override("font_size", 20)
	UI_STYLES.style_attack_indicator(attack_indicator)
	attack_indicator.visible = false
	sprite_container.add_child(attack_indicator)

	hp_bar = ProgressBar.new()
	hp_bar.custom_minimum_size = Vector2(100, 16)
	hp_bar.max_value = _stats.max_hp
	hp_bar.value = _stats.current_hp
	hp_bar.show_percentage = false
	UI_STYLES.style_hp_bar(hp_bar)
	vbox.add_child(hp_bar)

	hp_label = Label.new()
	hp_label.text = "%d / %d" % [_stats.current_hp, _stats.max_hp]
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_label.add_theme_font_size_override("font_size", 12)
	UI_STYLES.style_hp_label(hp_label)
	vbox.add_child(hp_label)

	original_position = Vector2.ZERO


func set_color(color: Color):
	if unit_sprite:
		unit_sprite.color = color


func _update_hp_display():
	hp_bar.max_value = _stats.max_hp
	hp_bar.value = _stats.current_hp
	hp_label.text = "%d / %d" % [_stats.current_hp, _stats.max_hp]


func take_damage(damage: int) -> bool:
	var died = _stats.take_damage(damage)
	_update_hp_display()
	_shake()

	if died:
		unit_died.emit(self)

	return died


func heal(amount: int):
	_stats.heal(amount)
	_update_hp_display()


func _shake():
	var tween = create_tween()
	tween.tween_property(unit_sprite, "position:x", original_position.x + 5, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x - 5, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x + 3, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x, 0.05)


func show_attack_effect():
	attack_indicator.text = "*"
	attack_indicator.visible = true
	attack_indicator.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(attack_indicator, "modulate:a", 1.0, 0.1)
	tween.tween_interval(0.2)
	tween.tween_property(attack_indicator, "modulate:a", 0.0, 0.1)
	tween.tween_callback(func(): attack_indicator.visible = false)


func reset():
	_stats.reset_hp()
	_update_hp_display()
