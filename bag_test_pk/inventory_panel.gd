extends PanelContainer

const UI_STYLES = preload("res://ui_styles.gd")

@export var columns: int = 5
@export var rows: int = 4
@export var enemy_direction: String = "right"  # 鎬墿鏂瑰悜: "right", "left", "up", "down"
@export var show_weapon_direction: bool = true  # 鏄惁鏄剧ず姝﹀櫒鏂瑰悜淇℃伅

const SLOT_SIZE := 46
const SLOT_GAP := 3

var slots = []
var items = []

var grid_container: GridContainer
var item_layer: Control
var tooltip: Control
var tooltip_name: Label
var tooltip_type: Label
var tooltip_desc: Label

var dragging_item = null
var drag_source_pos = null
var drag_source_size: Vector2i = Vector2i.ZERO
var drag_source_rotation: int = 0
var drag_target_preview = null
var drag_start_pos = null
var is_dragging = false

signal inventory_changed()


func _ready():
	_setup_style()
	_setup_ui()


func _setup_style():
	UI_STYLES.style_inventory_panel(self)


func _setup_ui():
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var bag_container = Control.new()
	var bag_width = columns * SLOT_SIZE + (columns - 1) * SLOT_GAP + 16
	var bag_height = rows * SLOT_SIZE + (rows - 1) * SLOT_GAP + 16
	bag_container.custom_minimum_size = Vector2(bag_width, bag_height)
	margin.add_child(bag_container)

	grid_container = GridContainer.new()
	grid_container.columns = columns
	grid_container.add_theme_constant_override("h_separation", SLOT_GAP)
	grid_container.add_theme_constant_override("v_separation", SLOT_GAP)
	bag_container.add_child(grid_container)

	for i in range(columns * rows):
		slots.append(null)
		grid_container.add_child(_create_slot(i))

	item_layer = Control.new()
	item_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bag_container.add_child(item_layer)

	tooltip = _create_tooltip()
	tooltip.visible = false
	add_child(tooltip)


func _create_slot(_index: int) -> PanelContainer:
	var slot = PanelContainer.new()
	slot.custom_minimum_size = Vector2(SLOT_SIZE, SLOT_SIZE)
	UI_STYLES.style_inventory_slot(slot)
	return slot


func _create_tooltip() -> Control:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(100, 50)
	UI_STYLES.style_tooltip(panel)

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


func _get_index_from_pos(col: int, row: int) -> int:
	if col < 0 or col >= columns or row < 0 or row >= rows:
		return -1
	return row * columns + col


func _get_item_pixel_size(grid_size: Vector2i) -> Vector2:
	return Vector2(
		grid_size.x * SLOT_SIZE + (grid_size.x - 1) * SLOT_GAP,
		grid_size.y * SLOT_SIZE + (grid_size.y - 1) * SLOT_GAP
	)


func _create_item_icon(data, container_size: Vector2, alpha: float) -> TextureRect:
	var base_size = _get_item_pixel_size(data.base_grid_size)
	var icon = TextureRect.new()
	icon.texture = data.icon
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_SCALE
	icon.size = base_size
	icon.position = (container_size - base_size) * 0.5
	icon.modulate = Color(1, 1, 1, alpha)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.pivot_offset = base_size * 0.5
	icon.rotation_degrees = data.rotation
	return icon


func _create_preview_grid_layer(grid_size: Vector2i) -> Control:
	var layer = Control.new()
	layer.size = _get_item_pixel_size(grid_size)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell = PanelContainer.new()
			cell.position = Vector2(x, y) * float(SLOT_SIZE + SLOT_GAP)
			cell.size = Vector2(SLOT_SIZE, SLOT_SIZE)

			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.2, 0.8, 0.2, 0.22)
			style.border_color = Color(0.3, 0.9, 0.3, 0.8)
			style.set_border_width_all(2)
			style.set_corner_radius_all(4)
			cell.add_theme_stylebox_override("panel", style)
			layer.add_child(cell)

	return layer


func _set_preview_grid_state(preview: Control, can_place: bool):
	if preview == null or preview.get_child_count() == 0:
		return

	var grid_layer = preview.get_child(0)
	if grid_layer == null:
		return

	for cell in grid_layer.get_children():
		var style = cell.get_theme_stylebox("panel") as StyleBoxFlat
		if style == null:
			continue
		if can_place:
			style.bg_color = Color(0.2, 0.8, 0.2, 0.22)
			style.border_color = Color(0.3, 0.9, 0.3, 0.8)
		else:
			style.bg_color = Color(0.8, 0.2, 0.2, 0.22)
			style.border_color = Color(0.9, 0.3, 0.3, 0.8)


func _build_item_preview(data, alpha: float) -> Control:
	var preview = Control.new()
	var preview_size = _get_item_pixel_size(data.get_grid_size())
	preview.size = preview_size
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var grid_layer = _create_preview_grid_layer(data.get_grid_size())
	preview.add_child(grid_layer)

	var icon_layer = Control.new()
	icon_layer.size = preview_size
	icon_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_layer.add_child(_create_item_icon(data, preview_size, alpha))
	preview.add_child(icon_layer)

	return preview


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
	_rebuild_slots()
	_refresh_items()


func _rebuild_slots():
	for i in range(slots.size()):
		slots[i] = null

	for item_info in items:
		if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
			continue
		if not item_info.has("data") or not item_info.has("grid_pos"):
			continue

		var data = item_info.get("data")
		var grid_pos = item_info.get("grid_pos")
		if data == null or grid_pos == null:
			continue

		for dy in range(data.get_grid_size().y):
			for dx in range(data.get_grid_size().x):
				var idx = _get_index_from_pos(grid_pos.x + dx, grid_pos.y + dy)
				if idx >= 0:
					slots[idx] = item_info


func _refresh_items():
	for child in item_layer.get_children():
		child.queue_free()

	for item in items:
		_render_item(item)


func _render_item(item_info):
	if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
		return
	if not item_info.has("data") or not item_info.has("grid_pos"):
		return

	var data = item_info.get("data")
	var grid_pos = item_info.get("grid_pos")
	if data == null or grid_pos == null:
		return

	var start_slot = grid_container.get_child(0)
	if start_slot == null:
		return

	var container = Control.new()
	container.position = start_slot.position + Vector2(grid_pos.x, grid_pos.y) * float(SLOT_SIZE + SLOT_GAP)
	container.size = _get_item_pixel_size(data.get_grid_size())
	container.mouse_filter = Control.MOUSE_FILTER_STOP
	container.set_meta("item_info", item_info)
	container.add_child(_create_item_icon(data, container.size, 0.85))
	item_layer.add_child(container)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var item = _get_item_at_position(event.global_position)
			if item:
				dragging_item = item
				drag_start_pos = event.global_position
				is_dragging = false
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if dragging_item:
				var move_dist = event.global_position.distance_to(drag_start_pos)
				if move_dist < 10 and not is_dragging:
					_cancel_drag()
				else:
					_end_drag(event.global_position)
			else:
				_cancel_drag()

	elif event is InputEventMouseMotion:
		if dragging_item and not is_dragging:
			var move_dist = event.global_position.distance_to(drag_start_pos)
			if move_dist >= 10:
				is_dragging = true
				_begin_drag_visual(dragging_item, event.global_position)
		elif is_dragging and drag_target_preview and dragging_item:
			_update_drag_preview(event.global_position)

	elif event is InputEventKey and is_dragging:
		if event.pressed:
			if event.keycode == KEY_Q:
				_rotate_item(false)
			elif event.keycode == KEY_E:
				_rotate_item(true)


func _get_item_at_position(global_pos: Vector2):
	for child in item_layer.get_children():
		if child == drag_target_preview:
			continue
		if not child.has_meta("item_info"):
			continue
		if Rect2(child.global_position, child.size).has_point(global_pos):
			var info = child.get_meta("item_info")
			if info != null and typeof(info) == TYPE_DICTIONARY:
				return info
	return null


func _begin_drag_visual(item_info, global_pos):
	if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
		return
	if not item_info.has("data") or not item_info.has("grid_pos"):
		return

	var data = item_info.get("data")
	if data == null:
		return

	drag_source_pos = item_info.get("grid_pos")
	drag_source_size = data.get_grid_size()
	drag_source_rotation = data.rotation

	for child in item_layer.get_children():
		if child.has_meta("item_info") and child.get_meta("item_info") == item_info:
			child.visible = false
			break

	if drag_target_preview:
		drag_target_preview.queue_free()

	drag_target_preview = _build_item_preview(data, 0.45)
	drag_target_preview.z_index = 50
	item_layer.add_child(drag_target_preview)
	_update_drag_preview(global_pos)


func _rotate_item(clockwise: bool):
	if dragging_item == null or typeof(dragging_item) != TYPE_DICTIONARY:
		return
	if not dragging_item.has("data"):
		return

	var data = dragging_item.get("data")
	if data == null:
		return

	if clockwise:
		data.rotation = (data.rotation + 90) % 360
	else:
		data.rotation = (data.rotation + 270) % 360

	_recreate_drag_preview()


func _recreate_drag_preview():
	if dragging_item == null or typeof(dragging_item) != TYPE_DICTIONARY:
		return
	if not dragging_item.has("data"):
		return

	var data = dragging_item.get("data")
	if data == null:
		return

	var mouse_pos = get_global_mouse_position()
	if drag_target_preview:
		drag_target_preview.queue_free()

	drag_target_preview = _build_item_preview(data, 0.45)
	drag_target_preview.z_index = 50
	item_layer.add_child(drag_target_preview)
	_update_drag_preview(mouse_pos)


func _cancel_drag():
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
	drag_source_size = Vector2i.ZERO
	drag_source_rotation = 0
	drag_start_pos = null
	is_dragging = false


func _update_drag_preview(global_pos: Vector2):
	if drag_target_preview == null or dragging_item == null:
		return
	if typeof(dragging_item) != TYPE_DICTIONARY or not dragging_item.has("data"):
		return

	var item_data = dragging_item.get("data")
	if item_data == null:
		return

	var local_pos = global_pos - item_layer.global_position
	var grid_pos = _get_drag_grid_pos(local_pos, item_data)
	var start_slot = grid_container.get_child(0)
	var grid_origin = Vector2.ZERO if start_slot == null else start_slot.position
	drag_target_preview.position = grid_origin + Vector2(grid_pos.x, grid_pos.y) * float(SLOT_SIZE + SLOT_GAP)

	var can_place = _can_place_item(grid_pos, item_data.get_grid_size(), dragging_item)
	_set_preview_grid_state(drag_target_preview, can_place)


func _end_drag(global_pos):
	if dragging_item == null:
		return

	if drag_target_preview:
		drag_target_preview.queue_free()
		drag_target_preview = null

	if typeof(dragging_item) != TYPE_DICTIONARY:
		_reset_drag_state()
		_refresh_items()
		return
	if not dragging_item.has("data") or not dragging_item.has("grid_pos"):
		_reset_drag_state()
		_refresh_items()
		return

	var item_data = dragging_item.get("data")
	if item_data == null:
		_reset_drag_state()
		_refresh_items()
		return

	if drag_source_pos == null:
		drag_source_pos = dragging_item.get("grid_pos")
		drag_source_size = item_data.get_grid_size()
	if drag_source_pos == null:
		_reset_drag_state()
		_refresh_items()
		return

	var local_pos = global_pos - item_layer.global_position
	var grid_pos = _get_drag_grid_pos(local_pos, item_data)

	if grid_pos.x >= 0 and _can_place_item(grid_pos, item_data.get_grid_size(), dragging_item):
		dragging_item["grid_pos"] = grid_pos
	else:
		item_data.rotation = drag_source_rotation
		dragging_item["grid_pos"] = drag_source_pos

	_rebuild_slots()
	_refresh_items()
	_reset_drag_state()
	inventory_changed.emit()


func _reset_drag_state():
	dragging_item = null
	drag_source_pos = null
	drag_source_size = Vector2i.ZERO
	drag_source_rotation = 0
	drag_start_pos = null
	is_dragging = false


func _get_drag_grid_pos(local_pos: Vector2, item_data) -> Vector2i:
	var item_size = item_data.get_grid_size()
	var item_pixel_size = _get_item_pixel_size(item_size)
	var centered_pos = local_pos - item_pixel_size * 0.5
	var col = int(round(centered_pos.x / float(SLOT_SIZE + SLOT_GAP)))
	var row = int(round(centered_pos.y / float(SLOT_SIZE + SLOT_GAP)))

	col = clamp(col, 0, columns - item_size.x)
	row = clamp(row, 0, rows - item_size.y)
	return Vector2i(col, row)


func _local_to_grid(local_pos: Vector2) -> Vector2i:
	var col = int(local_pos.x / float(SLOT_SIZE + SLOT_GAP))
	var row = int(local_pos.y / float(SLOT_SIZE + SLOT_GAP))

	col = clamp(col, 0, columns - 1)
	row = clamp(row, 0, rows - 1)
	return Vector2i(col, row)


func add_item(data, count: int = 1) -> int:
	var remaining = count

	if data.get_grid_size() == Vector2i(1, 1):
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

	while remaining > 0:
		var placed = false
		for row in range(rows):
			for col in range(columns):
				var item_instance = data.duplicate(true)
				var grid_pos = Vector2i(col, row)
				if _can_place_item(grid_pos, item_instance.get_grid_size()):
					_place_item(item_instance, 1, grid_pos)
					remaining -= 1
					placed = true
					break
			if placed:
				break
		if not placed:
			break

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
		items.erase(item)

	_rebuild_slots()
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
		if not child.visible or not child.has_meta("item_info"):
			continue

		if Rect2(child.global_position, child.size).has_point(mouse_pos):
			var item_info = child.get_meta("item_info")
			if item_info == null or typeof(item_info) != TYPE_DICTIONARY:
				continue
			if not item_info.has("data"):
				continue

			var data = item_info.get("data")
			if data == null:
				continue

			tooltip_name.text = data.item_name
			tooltip_type.text = data.item_type + " (%dx%d)" % [data.get_grid_size().x, data.get_grid_size().y]

			var desc = data.description
			if data.attack_bonus > 0:
				var atk = data.get_attack(enemy_direction if show_weapon_direction else "")
				desc += " | ATK+%d" % atk
			if data.defense_bonus > 0:
				desc += " | DEF+%d" % data.defense_bonus
			if data.hp_bonus > 0:
				desc += " | HP+%d" % data.hp_bonus

			tooltip_desc.text = desc
			tooltip.global_position = mouse_pos + Vector2(15, 15)
			tooltip.visible = true
			return

	tooltip.visible = false
