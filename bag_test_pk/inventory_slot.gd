extends PanelContainer

## 格子索引
@export var slot_index: int = 0

# 物品数据
var item_data = null
var item_count: int = 0

# 主格子标记（多格物品只渲染一次）
var is_main_slot: bool = true
var main_slot = null

# UI节点
var icon_texture: TextureRect
var count_label: Label
var direction_indicator: Label

# 拖拽相关
signal slot_clicked(slot, button)
signal slot_drag_started(slot)
signal slot_drag_ended(slot)
signal slot_drop_requested(source_slot, target_slot)

static var dragged_slot = null


func _ready():
	custom_minimum_size = Vector2(50, 50)
	_setup_style()
	_setup_ui()


func _setup_style():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.25, 0.8)
	style.border_color = Color(0.4, 0.4, 0.45)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	add_theme_stylebox_override("panel", style)


func _setup_ui():
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 2)
	margin.add_theme_constant_override("margin_right", 2)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_bottom", 2)
	add_child(margin)

	icon_texture = TextureRect.new()
	icon_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_texture.texture = null
	margin.add_child(icon_texture)

	direction_indicator = Label.new()
	direction_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	direction_indicator.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	direction_indicator.add_theme_font_size_override("font_size", 10)
	direction_indicator.add_theme_color_override("font_color", Color.YELLOW)
	direction_indicator.visible = false
	margin.add_child(direction_indicator)

	count_label = Label.new()
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	count_label.add_theme_font_size_override("font_size", 12)
	count_label.add_theme_color_override("font_color", Color.WHITE)
	count_label.add_theme_color_override("font_outline_color", Color.BLACK)
	count_label.add_theme_constant_override("outline_size", 2)
	count_label.anchors_preset = Control.PRESET_BOTTOM_RIGHT
	count_label.offset_left = -18
	count_label.offset_top = -14
	count_label.offset_right = -2
	count_label.offset_bottom = -2
	count_label.text = ""
	add_child(count_label)


func set_item(data, count: int = 1):
	item_data = data
	item_count = count
	is_main_slot = true
	main_slot = null
	_update_display()


func set_as_sub_slot(main):
	item_data = main.item_data
	item_count = 0
	is_main_slot = false
	main_slot = main
	_update_display()


func clear_item():
	item_data = null
	item_count = 0
	is_main_slot = true
	main_slot = null
	_update_display()


func is_empty() -> bool:
	return item_data == null or not is_main_slot


func has_item() -> bool:
	return item_data != null and is_main_slot


func _update_display():
	if item_data and is_main_slot:
		icon_texture.texture = item_data.icon
		icon_texture.modulate = Color.WHITE

		if item_data.item_type == "武器":
			direction_indicator.visible = true
			direction_indicator.text = "→" if item_data.direction == 0 else "←"
		else:
			direction_indicator.visible = false

		if item_count > 1:
			count_label.text = str(item_count)
		else:
			count_label.text = ""
	elif item_data and not is_main_slot:
		icon_texture.texture = item_data.icon
		icon_texture.modulate = Color(1, 1, 1, 0.3)
		direction_indicator.visible = false
		count_label.text = ""
	else:
		icon_texture.texture = null
		icon_texture.modulate = Color.WHITE
		direction_indicator.visible = false
		count_label.text = ""


func _get_drag_data(at_position: Vector2):
	if not has_item():
		return null

	# 创建预览
	var preview = Control.new()
	var preview_icon = TextureRect.new()
	preview_icon.texture = item_data.icon
	preview_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview_icon.custom_minimum_size = Vector2(50 * item_data.grid_size.x, 50 * item_data.grid_size.y)
	preview.add_child(preview_icon)
	preview.position = at_position * -1

	set_drag_preview(preview)
	dragged_slot = self

	var data = {
		"slot": self,
		"item_data": item_data,
		"item_count": item_count
	}

	slot_drag_started.emit(self)
	return data


func _can_drop_data(at_position: Vector2, data) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	if not data.has("slot"):
		return false

	var source_slot = data["slot"]
	if source_slot == self:
		return true

	# 子格子不能接受拖放
	if not is_main_slot:
		return false

	# 有物品时不能放（交换功能暂时禁用）
	if has_item():
		return false

	return true


func _drop_data(at_position: Vector2, data):
	if typeof(data) != TYPE_DICTIONARY:
		return

	var source_slot = data["slot"]
	if source_slot == self:
		return

	# 发送信号让panel处理多格物品放置
	slot_drop_requested.emit(source_slot, self)
	dragged_slot = null


func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if dragged_slot == self:
			dragged_slot = null
			slot_drag_ended.emit(self)
