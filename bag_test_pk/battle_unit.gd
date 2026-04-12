extends Control

## 单位名称
@export var unit_name: String = "角色"

## 基础属性
@export var max_hp: int = 100
@export var base_attack: int = 10
@export var base_defense: int = 5
@export var attack_speed: float = 1.0

# 当前状态
var current_hp: int
var is_attacking: bool = false
var attack_timer: float = 0.0

# UI节点
var unit_sprite: ColorRect
var hp_bar: ProgressBar
var hp_label: Label
var name_label: Label
var attack_indicator: Label

# 信号
signal attack_target(unit)
signal unit_died(unit)

# 动画相关
var original_position: Vector2


func _ready():
	current_hp = max_hp
	_setup_ui()


func _setup_ui():
	custom_minimum_size = Vector2(120, 160)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(vbox)

	name_label = Label.new()
	name_label.text = unit_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(name_label)

	var sprite_container = CenterContainer.new()
	sprite_container.custom_minimum_size = Vector2(100, 100)
	vbox.add_child(sprite_container)

	unit_sprite = ColorRect.new()
	unit_sprite.custom_minimum_size = Vector2(60, 80)
	unit_sprite.color = Color(0.3, 0.5, 0.8)
	sprite_container.add_child(unit_sprite)

	attack_indicator = Label.new()
	attack_indicator.text = ""
	attack_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	attack_indicator.add_theme_font_size_override("font_size", 20)
	attack_indicator.visible = false
	sprite_container.add_child(attack_indicator)

	hp_bar = ProgressBar.new()
	hp_bar.custom_minimum_size = Vector2(100, 16)
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp
	hp_bar.show_percentage = false
	vbox.add_child(hp_bar)

	hp_label = Label.new()
	hp_label.text = "%d / %d" % [current_hp, max_hp]
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(hp_label)

	original_position = unit_sprite.position


func set_color(color: Color):
	if unit_sprite:
		unit_sprite.color = color


func update_stats_from_inventory(items: Array):
	var bonus_hp = 0
	var bonus_attack = 0
	var bonus_defense = 0
	var bonus_speed = 0.0

	for item in items:
		if item == null:
			continue

		# 使用get_attack()来获取根据朝向计算的攻击力
		bonus_attack += item.get_attack()
		bonus_defense += item.defense_bonus
		bonus_hp += item.hp_bonus
		bonus_speed += item.speed_bonus

	max_hp = 100 + bonus_hp
	base_attack = 10 + bonus_attack
	base_defense = 5 + bonus_defense
	attack_speed = max(0.3, 1.0 - bonus_speed)

	current_hp = min(current_hp, max_hp)
	_update_hp_display()


func _update_hp_display():
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "%d / %d" % [current_hp, max_hp]


func take_damage(damage: int):
	var actual_damage = max(1, damage - base_defense)
	current_hp -= actual_damage

	_update_hp_display()
	_shake()

	if current_hp <= 0:
		current_hp = 0
		_update_hp_display()
		unit_died.emit(self)
		return true

	return false


func heal(amount: int):
	current_hp = min(max_hp, current_hp + amount)
	_update_hp_display()


func _shake():
	var tween = create_tween()
	tween.tween_property(unit_sprite, "position:x", original_position.x + 5, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x - 5, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x + 3, 0.05)
	tween.tween_property(unit_sprite, "position:x", original_position.x, 0.05)


func show_attack_effect():
	attack_indicator.text = "⚔"
	attack_indicator.visible = true

	var tween = create_tween()
	tween.tween_property(attack_indicator, "modulate:a", 1.0, 0.1)
	tween.tween_interval(0.2)
	tween.tween_property(attack_indicator, "modulate:a", 0.0, 0.1)
	tween.tween_callback(func(): attack_indicator.visible = false)


func reset():
	current_hp = max_hp
	_update_hp_display()
