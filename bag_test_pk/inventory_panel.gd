extends PanelContainer

@export var columns: int = 5
@export var rows: int = 4

var slots = []  # 格子数据
var items = []  # 物品列表

var grid_container: GridContainer
var item_layer: Control
var tooltip: Control
var tooltip_name: Label
var tooltip_type: Label
var tooltip_desc: Label

var dragging_item = null
var drag_source_pos = null
var drag_target_preview = null   # 目标位置预览框
var drag_start_pos = null  # 记录开始拖拽的位置
var is_dragging = false    # 是否正在拖拽

signal inventory_changed()


func _ready():
	_setup_style()
	_setup_ui()


func _setup_style():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.18, 0.95)
	style.border_color = Color(0.35, 0.35, 0.4)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	add_theme_stylebox_override("panel", style)


func _setup_ui():
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var vbox = VBoxContainer.new()
	margin.add_child(vbox)

	var title = Label.new()
	title.text = "背包"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)

	var bag_container = Control.new()
	bag_container.custom_minimum_size = Vector2(250, 200)
	vbox.add_child(bag_container)

	# 格子层
	grid_container = GridContainer.new()
	grid_container.columns = columns
	grid_container.add_theme_constant_override("h_separation", 3)
	grid_container.add_theme_constant_override("v_separation", 3)
	bag_container.add_child(grid_container)

	for i in range(columns * rows):
		slots.append(null)
		var slot = _create_slot(i)
		grid_container.add_child(slot)

	# 物品层
	item_layer = Control.new()
	item_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bag_container.add_child(item_layer)

	tooltip = _create_tooltip()
	tooltip.visible = false
	add_child(tooltip)


func _create_slot(index: int) -> PanelContainer:
	var slot = PanelContainer.new()
	slot.custom_minimum_size = Vector2(46, 46)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.25, 0.8)
	style.border_color = Color(0.4, 0.4, 0.45)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	slot.add_theme_stylebox_override("panel", style)

	return slot


func _create_tooltip() -> Control:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(100, 50)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.5)
	style.border_color = Color(0.6, 0.6, 0.7, 0.8)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	panel.add_theme_stylebox_override("panel", style)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_top", 3)
	margin.add_theme_constant_override("margin_bottom", 3)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	margin.add_child(vbox)

	tooltip_name = Label.new()
	tooltip_name.add_theme_font_size_override("font_size", 11)
	vbox.add_child(tooltip_name)

	tooltip_type = Label.new()
	tooltip_type.add_theme_font_size_override("font_size", 9)
	tooltip_type.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(tooltip_type)

	tooltip_desc = Label.new()
	tooltip_desc.add_theme_font_size_override("font_size", 9)
	vbox.add_child(tooltip_desc)

	return panel


func _get_slot_position(index: int) -> Vector2i:
	return Vector2i(index % columns, index / columns)


func _get_index_from_pos(col: int, row: int) -> int:
	if col < 0 or col >= columns or row < 0 or row >= rows:
		return -1
	return row * columns + col


func _can_place_item(grid_pos: Vector2i, grid_size: Vector2i, exclude_item = null) -> bool:
	for dy in range(grid_size.y):
		for dx in range(grid_size.x):
			var col = grid_pos.x + dx
			var row = grid_pos.y + dy
			if col >= columns or row >= rows:
				return false
			var idx = _get_index_from_pos(col, row)
			if idx < 0:
				return false
			if slots[idx] != null and slots[idx] != exclude_item:
				return false
	return true


func _place_item(data, count: int, grid_pos: Vector2i):
	var item_info = {
		"data": data,
		"count": count,
		"grid_pos": grid_pos
	}
	items.append(item_info)

	for dy in range(data.grid_size.y):
		for dx in range(data.grid_size.x):
			var idx = _get_index_from_pos(grid_pos.x + dx, grid_pos.y + dy)
			if idx >= 0:
				slots[idx] = item_info

	_refresh_items()


func _refresh_items():
	for child in item_layer.get_children():
		child.queue_free()

	for item in items:
		_render_item(item)


func _render_item(item_info):
	if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
		return
	if not item_info.has("data"):
		return

	var data = item_info.get("data")
	if data == null:
		return

	if not item_info.has("grid_pos"):
		return
	var grid_pos = item_info.get("grid_pos")
	if grid_pos == null:
		return

	var slot_size = 46
	var gap = 3

	var start_slot = grid_container.get_child(0)
	if start_slot == null:
		return

	var grid_origin = start_slot.position

	var x = grid_origin.x + grid_pos.x * (slot_size + gap)
	var y = grid_origin.y + grid_pos.y * (slot_size + gap)
	var w = data.grid_size.x * slot_size + (data.grid_size.x - 1) * gap
	var h = data.grid_size.y * slot_size + (data.grid_size.y - 1) * gap

	# 外层容器，保持位置和大小不变
	var container = Control.new()
	container.position = Vector2(x, y)
	container.size = Vector2(w, h)
	container.mouse_filter = Control.MOUSE_FILTER_STOP
	container.set_meta("item_info", item_info)

	# 内层图片
	var item_control = TextureRect.new()
	item_control.texture = data.icon
	item_control.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_control.stretch_mode = TextureRect.STRETCH_SCALE
	item_control.size = Vector2(w, h)
	item_control.modulate = Color(1, 1, 1, 0.85)
	item_control.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# 武器方向镜像 - 只翻转图片，容器位置不变
	if data.item_type == "武器" and data.direction == 1:
		item_control.flip_h = true

	container.add_child(item_control)
	item_layer.add_child(container)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# 检查是否点击了物品
			var item = _get_item_at_position(event.global_position)
			if item:
				dragging_item = item
				drag_start_pos = event.global_position
				is_dragging = false
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if dragging_item:
				# 判断是单击还是拖拽
				var move_dist = event.global_position.distance_to(drag_start_pos)
				if move_dist < 10 and not is_dragging:
					# 单击 - 翻转方向
					_flip_item_direction(dragging_item)
					_cancel_drag()
				else:
					# 拖拽结束
					_end_drag(event.global_position)
			else:
				_cancel_drag()

	elif event is InputEventMouseMotion:
		if dragging_item and not is_dragging:
			# 检测是否开始拖拽
			var move_dist = event.global_position.distance_to(drag_start_pos)
			if move_dist >= 10:
				is_dragging = true
				_begin_drag_visual(dragging_item, event.global_position)
		elif is_dragging and drag_target_preview and dragging_item:
			_update_drag_preview(event.global_position)


func _get_item_at_position(global_pos: Vector2):
	for child in item_layer.get_children():
		# 跳过预览控件
		if child == drag_target_preview:
			continue
		# 检查是否有有效的 meta
		if not child.has_meta("item_info"):
			continue
		var rect = Rect2(child.global_position, child.size)
		if rect.has_point(global_pos):
			var info = child.get_meta("item_info")
			if info != null and typeof(info) == TYPE_DICTIONARY:
				return info
	return null


func _begin_drag_visual(item_info, global_pos):
	if item_info == null:
		return

	# 安全检查
	if typeof(item_info) != TYPE_DICTIONARY:
		return
	if not item_info.has("data") or not item_info.has("grid_pos"):
		return

	var data = item_info.get("data")
	if data == null:
		return

	drag_source_pos = item_info.get("grid_pos")

	# 隐藏物品
	for child in item_layer.get_children():
		if child.has_meta("item_info") and child.get_meta("item_info") == item_info:
			child.visible = false
			break

	# 清理旧预览
	if drag_target_preview:
		drag_target_preview.queue_free()
		drag_target_preview = null

	var slot_size = 46
	var gap = 3
	var w = data.grid_size.x * slot_size + (data.grid_size.x - 1) * gap
	var h = data.grid_size.y * slot_size + (data.grid_size.y - 1) * gap

	# 创建目标位置预览框（显示在格子位置）
	drag_target_preview = Control.new()
	drag_target_preview.size = Vector2(w, h)
	drag_target_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drag_target_preview.z_index = 50

	var bg = PanelContainer.new()
	bg.size = Vector2(w, h)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.8, 0.2, 0.35)  # 默认绿色
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
	bg.add_theme_stylebox_override("panel", style)
	drag_target_preview.add_child(bg)

	# 目标预览框内的物品图标
	var preview_icon = TextureRect.new()
	preview_icon.texture = data.icon
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_icon.stretch_mode = TextureRect.STRETCH_SCALE
	preview_icon.size = Vector2(w, h)
	preview_icon.modulate = Color(1, 1, 1, 0.45)
	preview_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if data.item_type == "武器" and data.direction == 1:
		preview_icon.flip_h = true
	bg.add_child(preview_icon)

	item_layer.add_child(drag_target_preview)

	_update_drag_preview(global_pos)


func _flip_item_direction(item_info):
	"""翻转物品方向"""
	if item_info == null:
		return
	if typeof(item_info) != TYPE_DICTIONARY:
		return
	if not item_info.has("data"):
		return

	var data = item_info.get("data")
	if data == null:
		return

	if data.item_type == "武器":
		# 翻转方向 0 <-> 1
		data.direction = 1 - data.direction
		_refresh_items()


func _cancel_drag():
	"""取消拖拽"""
	# 恢复物品可见性
	if dragging_item and typeof(dragging_item) == TYPE_DICTIONARY:
		for child in item_layer.get_children():
			if not child.has_meta("item_info"):
				continue
			var meta = child.get_meta("item_info")
			if meta != null and meta == dragging_item:
				child.visible = true
				break

	if drag_target_preview:
		drag_target_preview.queue_free()
		drag_target_preview = null
	dragging_item = null
	drag_source_pos = null
	drag_start_pos = null
	is_dragging = false


func _update_drag_preview(global_pos: Vector2):
	# 更新目标位置预览框
	if drag_target_preview == null or dragging_item == null:
		return

	# 安全检查 dragging_item 是否为有效字典
	if typeof(dragging_item) != TYPE_DICTIONARY:
		return
	if not dragging_item.has("data"):
		return

	var item_data = dragging_item.get("data")
	if item_data == null:
		return

	var local_pos = global_pos - item_layer.global_position
	var grid_pos = _local_to_grid(local_pos)

	var slot_size = 46
	var gap = 3

	# 计算目标位置像素坐标
	var start_slot = grid_container.get_child(0)
	var grid_origin = Vector2.ZERO
	if start_slot:
		grid_origin = start_slot.position

	var x = grid_origin.x + grid_pos.x * (slot_size + gap)
	var y = grid_origin.y + grid_pos.y * (slot_size + gap)

	drag_target_preview.position = Vector2(x, y)

	# 检查能否放置，更新颜色
	var can_place = _can_place_item(grid_pos, item_data.grid_size, dragging_item)

	var bg = drag_target_preview.get_child(0)
	if bg:
		var style = bg.get_theme_stylebox("panel") as StyleBoxFlat
		if style:
			if can_place:
				style.bg_color = Color(0.2, 0.8, 0.2, 0.35)  # 绿色
				style.border_color = Color(0.3, 0.9, 0.3, 0.8)
			else:
				style.bg_color = Color(0.8, 0.2, 0.2, 0.35)  # 红色
				style.border_color = Color(0.9, 0.3, 0.3, 0.8)


func _end_drag(global_pos):
	if dragging_item == null:
		return

	# 移除预览
	if drag_target_preview:
		drag_target_preview.queue_free()
		drag_target_preview = null

	# 安全检查
	if typeof(dragging_item) != TYPE_DICTIONARY:
		dragging_item = null
		drag_source_pos = null
		drag_start_pos = null
		is_dragging = false
		_refresh_items()
		return

	if not dragging_item.has("data") or not dragging_item.has("grid_pos"):
		dragging_item = null
		drag_source_pos = null
		drag_start_pos = null
		is_dragging = false
		_refresh_items()
		return

	var item_data = dragging_item.get("data")
	if item_data == null:
		dragging_item = null
		drag_source_pos = null
		drag_start_pos = null
		is_dragging = false
		_refresh_items()
		return

	# 检查 drag_source_pos 是否有效
	if drag_source_pos == null:
		drag_source_pos = dragging_item.get("grid_pos")

	# 如果仍然没有有效的 source_pos，取消操作
	if drag_source_pos == null:
		dragging_item = null
		drag_source_pos = null
		drag_start_pos = null
		is_dragging = false
		_refresh_items()
		return

	# 计算目标位置
	var local_pos = global_pos - item_layer.global_position
	var grid_pos = _local_to_grid(local_pos)

	# 清除原位置标记
	for dy in range(item_data.grid_size.y):
		for dx in range(item_data.grid_size.x):
			var idx = _get_index_from_pos(drag_source_pos.x + dx, drag_source_pos.y + dy)
			if idx >= 0:
				slots[idx] = null

	# 检查能否放置
	if grid_pos.x >= 0 and _can_place_item(grid_pos, item_data.grid_size):
		dragging_item.grid_pos = grid_pos
	else:
		dragging_item.grid_pos = drag_source_pos

	# 重新标记格子
	for dy in range(item_data.grid_size.y):
		for dx in range(item_data.grid_size.x):
			var idx = _get_index_from_pos(dragging_item.grid_pos.x + dx, dragging_item.grid_pos.y + dy)
			if idx >= 0:
				slots[idx] = dragging_item

	_refresh_items()
	dragging_item = null
	drag_source_pos = null
	drag_start_pos = null
	is_dragging = false
	inventory_changed.emit()


func _local_to_grid(local_pos: Vector2) -> Vector2i:
	var slot_size = 46
	var gap = 3

	var col = int(local_pos.x / (slot_size + gap))
	var row = int(local_pos.y / (slot_size + gap))

	if col < 0:
		col = 0
	if row < 0:
		row = 0
	if col >= columns:
		col = columns - 1
	if row >= rows:
		row = rows - 1

	return Vector2i(col, row)


func add_item(data, count: int = 1) -> int:
	var remaining = count

	if data.grid_size == Vector2i(1, 1):
		for item in items:
			if item.data.id == data.id and item.count < data.max_stack:
				var can_add = data.max_stack - item.count
				var added = min(remaining, can_add)
				item.count += added
				remaining -= added
				if remaining <= 0:
					_refresh_items()
					inventory_changed.emit()
					return 0

	for row in range(rows):
		for col in range(columns):
			var grid_pos = Vector2i(col, row)
			if _can_place_item(grid_pos, data.grid_size):
				_place_item(data, 1, grid_pos)
				remaining -= 1
				if remaining <= 0:
					inventory_changed.emit()
					return 0

	inventory_changed.emit()
	return remaining


func remove_item(item_id: String, count: int = 1) -> bool:
	var remaining = count

	var to_remove = []
	for item in items:
		if item.data.id == item_id:
			var removed = min(remaining, item.count)
			item.count -= removed
			remaining -= removed

			if item.count <= 0:
				to_remove.append(item)

			if remaining <= 0:
				break

	for item in to_remove:
		for dy in range(item.data.grid_size.y):
			for dx in range(item.data.grid_size.x):
				var idx = _get_index_from_pos(item.grid_pos.x + dx, item.grid_pos.y + dy)
				if idx >= 0:
					slots[idx] = null
		items.erase(item)

	_refresh_items()
	inventory_changed.emit()
	return remaining <= 0


func clear_all():
	items.clear()
	for i in range(slots.size()):
		slots[i] = null
	_refresh_items()
	inventory_changed.emit()


func get_all_items() -> Array:
	var result = []
	for item in items:
		result.append(item.data)
	return result


func _process(_delta):
	_check_tooltip()


func _check_tooltip():
	if dragging_item:
		tooltip.visible = false
		return

	var mouse_pos = get_global_mouse_position()

	for child in item_layer.get_children():
		if not child.visible:
			continue
		# 跳过没有 item_info meta 的控件
		if not child.has_meta("item_info"):
			continue
		var rect = Rect2(child.global_position, child.size)
		if rect.has_point(mouse_pos):
			var item_info = child.get_meta("item_info")
			if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
				continue
			if not item_info.has("data"):
				continue
			var data = item_info.get("data")
			if data == null:
				continue

			tooltip_name.text = data.item_name
			tooltip_type.text = data.item_type + " (%dx%d)" % [data.grid_size.x, data.grid_size.y]

			var desc = data.description
			if data.item_type == "武器":
				desc += " | 攻击+%d" % data.get_attack()
				desc += " →" if data.direction == 0 else " ←"
			elif data.item_type == "防具":
				if data.defense_bonus > 0:
					desc += " | 防御+%d" % data.defense_bonus
				if data.hp_bonus > 0:
					desc += " 生命+%d" % data.hp_bonus
			tooltip_desc.text = desc

			tooltip.global_position = mouse_pos + Vector2(15, 15)
			tooltip.visible = true
			return

	tooltip.visible = false
