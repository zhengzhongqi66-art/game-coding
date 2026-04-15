extends RefCounted

## 拖拽逻辑处理器
## 负责拖拽状态管理、旋转处理、放置预览

## 拖拽状态
var dragging_item = null
var drag_source_pos: Vector2i = Vector2i.ZERO
var drag_source_size: Vector2i = Vector2i.ZERO
var is_dragging: bool = false
var drag_start_pos: Vector2 = Vector2.ZERO

## 信号
signal drag_started(item_info)
signal drag_ended(item_info, new_pos)
signal item_rotated(item_info, clockwise: bool)


## 开始拖拽
func start_drag(item_info, global_pos: Vector2):
	if typeof(item_info) != TYPE_DICTIONARY:
		return false
	if not item_info.has("data") or not item_info.has("grid_pos"):
		return false

	dragging_item = item_info
	drag_start_pos = global_pos
	is_dragging = false

	var data = item_info.get("data")
	if data:
		drag_source_pos = item_info.get("grid_pos")
		drag_source_size = data.get_grid_size()

	return true


## 检查是否应该开始拖拽（移动距离阈值）
func check_drag_threshold(current_pos: Vector2) -> bool:
	if dragging_item == null:
		return false

	if is_dragging:
		return true

	var dist = current_pos.distance_to(drag_start_pos)
	if dist >= 10:
		is_dragging = true
		drag_started.emit(dragging_item)
		return true

	return false


## 旋转物品
func rotate_item(clockwise: bool):
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

	# 更新源尺寸
	drag_source_size = data.get_grid_size()

	item_rotated.emit(dragging_item, clockwise)


## 结束拖拽
func end_drag(global_pos: Vector2, inventory_manager, pixel_to_grid_func) -> bool:
	if dragging_item == null:
		cancel_drag()
		return false

	if typeof(dragging_item) != TYPE_DICTIONARY:
		cancel_drag()
		return false
	if not dragging_item.has("data"):
		cancel_drag()
		return false

	var item_data = dragging_item.get("data")
	if item_data == null:
		cancel_drag()
		return false

	# 计算新位置
	var new_grid_pos = pixel_to_grid_func.call(global_pos)

	# 尝试移动
	var old_pos = drag_source_pos
	if inventory_manager.move_item(dragging_item, new_grid_pos):
		drag_ended.emit(dragging_item, new_grid_pos)
	else:
		# 恢复原位置
		inventory_manager.move_item(dragging_item, old_pos)

	_reset_state()
	return true


## 取消拖拽
func cancel_drag():
	_reset_state()


## 重置状态
func _reset_state():
	dragging_item = null
	drag_source_pos = Vector2i.ZERO
	drag_source_size = Vector2i.ZERO
	is_dragging = false
	drag_start_pos = Vector2.ZERO


## 获取当前拖拽物品
func get_dragging_item():
	return dragging_item


## 是否正在拖拽
func is_currently_dragging() -> bool:
	return is_dragging and dragging_item != null


## 获取源位置
func get_source_position() -> Vector2i:
	return drag_source_pos


## 获取源尺寸
func get_source_size() -> Vector2i:
	return drag_source_size
