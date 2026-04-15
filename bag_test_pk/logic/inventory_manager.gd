extends RefCounted

## 背包数据管理器
## 负责格子数据存储、物品放置验证、增删查

var columns: int = 5
var rows: int = 4

var slots: Array = []  # 存储每个格子对应的物品信息
var items: Array = []  # 存储所有物品信息


func _init(cols: int = 5, rows: int = 4):
	self.columns = cols
	self.rows = rows
	_init_slots()


func _init_slots():
	slots.clear()
	for i in range(columns * rows):
		slots.append(null)


## 获取格子索引
func get_index_from_pos(col: int, row: int) -> int:
	if col < 0 or col >= columns or row < 0 or row >= rows:
		return -1
	return row * columns + col


## 检查是否可以放置物品
func can_place_item(grid_pos: Vector2i, grid_size: Vector2i, exclude_item = null) -> bool:
	for dy in range(grid_size.y):
		for dx in range(grid_size.x):
			var col = grid_pos.x + dx
			var row = grid_pos.y + dy
			if col >= columns or row >= rows:
				return false
			var idx = get_index_from_pos(col, row)
			if idx < 0:
				return false
			if slots[idx] != null and slots[idx] != exclude_item:
				return false
	return true


## 放置物品
func place_item(data, count: int, grid_pos: Vector2i) -> Dictionary:
	var item_info = {
		"data": data,
		"count": count,
		"grid_pos": grid_pos
	}
	items.append(item_info)

	var grid_size = data.get_grid_size()
	for dy in range(grid_size.y):
		for dx in range(grid_size.x):
			var idx = get_index_from_pos(grid_pos.x + dx, grid_pos.y + dy)
			if idx >= 0:
				slots[idx] = item_info

	return item_info


## 移除物品占用
func clear_item_slots(item_info):
	if typeof(item_info) != TYPE_DICTIONARY or not item_info.has("data") or not item_info.has("grid_pos"):
		return

	var data = item_info.get("data")
	var grid_pos = item_info.get("grid_pos")
	if data == null or grid_pos == null:
		return

	var grid_size = data.get_grid_size()
	for dy in range(grid_size.y):
		for dx in range(grid_size.x):
			var idx = get_index_from_pos(grid_pos.x + dx, grid_pos.y + dy)
			if idx >= 0:
				slots[idx] = null


## 添加物品（自动寻找位置）
func add_item(data, count: int = 1) -> int:
	var remaining = count

	# 1x1物品尝试堆叠
	if data.get_grid_size() == Vector2i(1, 1):
		for item in items:
			if item.data.id == data.id and item.count < data.max_stack:
				var can_add = data.max_stack - item.count
				var added = min(remaining, can_add)
				item.count += added
				remaining -= added
				if remaining <= 0:
					return 0

	# 寻找空位放置
	while remaining > 0:
		var placed = false
		for row in range(rows):
			for col in range(columns):
				var item_instance = data.duplicate(true)
				var grid_pos = Vector2i(col, row)
				if can_place_item(grid_pos, item_instance.get_grid_size()):
					place_item(item_instance, 1, grid_pos)
					remaining -= 1
					placed = true
					break
			if placed:
				break
		if not placed:
			break

	return remaining


## 移除物品
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
		clear_item_slots(item)
		items.erase(item)

	return remaining <= 0


## 清空所有物品
func clear_all():
	items.clear()
	for i in range(slots.size()):
		slots[i] = null


## 获取所有物品数据
func get_all_items() -> Array:
	var result = []
	for item in items:
		result.append(item.data)
	return result


## 获取指定位置的物品
func get_item_at(grid_pos: Vector2i):
	var idx = get_index_from_pos(grid_pos.x, grid_pos.y)
	if idx >= 0 and idx < slots.size():
		return slots[idx]
	return null


## 移动物品到新位置
func move_item(item_info, new_grid_pos: Vector2i) -> bool:
	if typeof(item_info) != TYPE_DICTIONARY:
		return false
	if not item_info.has("data"):
		return false

	var data = item_info.get("data")
	if data == null:
		return false

	# 先清除原位置
	clear_item_slots(item_info)

	# 检查新位置是否可用
	if can_place_item(new_grid_pos, data.get_grid_size()):
		item_info["grid_pos"] = new_grid_pos
		# 在新位置设置
		var grid_size = data.get_grid_size()
		for dy in range(grid_size.y):
			for dx in range(grid_size.x):
				var idx = get_index_from_pos(new_grid_pos.x + dx, new_grid_pos.y + dy)
				if idx >= 0:
					slots[idx] = item_info
		return true
	else:
		# 恢复原位置
		var old_pos = item_info.get("grid_pos")
		if old_pos:
			var grid_size = data.get_grid_size()
			for dy in range(grid_size.y):
				for dx in range(grid_size.x):
					var idx = get_index_from_pos(old_pos.x + dx, old_pos.y + dy)
					if idx >= 0:
						slots[idx] = item_info
		return false
