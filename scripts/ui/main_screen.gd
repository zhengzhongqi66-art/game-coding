extends Control

const GameDataScript = preload("res://scripts/data/game_data.gd")
const CELL_SIZE := Vector2(84, 84)
const CELL_GAP := 6.0

@onready var _summary_label: Label = $MarginContainer/RootVBox/Header/TitleBlock/Summary
@onready var _action_hint_label: Label = $MarginContainer/RootVBox/Header/TitleBlock/ActionHint
@onready var _profession_selector: OptionButton = $MarginContainer/RootVBox/Header/ProfessionPanel/ProfessionMargin/ProfessionVBox/ProfessionSelector
@onready var _variant_label: Label = $MarginContainer/RootVBox/Header/ProfessionPanel/ProfessionMargin/ProfessionVBox/VariantLabel
@onready var _battle_info_label: Label = $MarginContainer/RootVBox/Content/BoardSide/BattlePanel/BattleMargin/BattleVBox/BattleInfo
@onready var _storage_info_label: Label = $MarginContainer/RootVBox/Content/BoardSide/StoragePanel/StorageMargin/StorageVBox/StorageInfo
@onready var _battle_cells: Control = $MarginContainer/RootVBox/Content/BoardSide/BattlePanel/BattleMargin/BattleVBox/BattleBoard/BattleCells
@onready var _battle_items: Control = $MarginContainer/RootVBox/Content/BoardSide/BattlePanel/BattleMargin/BattleVBox/BattleBoard/BattleItems
@onready var _storage_cells: Control = $MarginContainer/RootVBox/Content/BoardSide/StoragePanel/StorageMargin/StorageVBox/StorageBoard/StorageCells
@onready var _storage_items: Control = $MarginContainer/RootVBox/Content/BoardSide/StoragePanel/StorageMargin/StorageVBox/StorageBoard/StorageItems
@onready var _reward_details: RichTextLabel = $MarginContainer/RootVBox/Content/InfoSide/RewardPanel/RewardMargin/RewardVBox/RewardDetails
@onready var _item_details: RichTextLabel = $MarginContainer/RootVBox/Content/InfoSide/ItemPanel/ItemMargin/ItemVBox/ItemDetails

var _game_data = GameDataScript.new()
var _profession_ids: Array[String] = []
var _current_profession_id := "cultivator"
var _selected_item_uid := ""
var _drag_item_uid := ""
var _drag_pointer_offset := Vector2.ZERO
var _placed_items: Array[Dictionary] = []
var _next_uid := 1

var _profession_name_map := {
	"cultivator": "修士",
	"mage": "魔法师",
	"artificial_intelligence": "人工智能"
}
var _profession_pitch_map := {
	"cultivator": "围绕阵位、朝向和供能，做出干净稳定的修仙构筑。",
	"mage": "围绕施法通道、充能和爆发时机，做出法术连锁。",
	"artificial_intelligence": "围绕逻辑链、桥接和稳定循环，做出自动化结构。"
}
var _profession_goal_map := {
	"cultivator": "目标：把核心输出和供能件摆进阵心附近，让支撑件覆盖更多有效格。",
	"mage": "目标：把法术件接进施法通道，再用锚点稳定准备和爆发。",
	"artificial_intelligence": "目标：把处理器、桥接和供能串成一条不断链的逻辑通路。"
}
var _profession_variant_name_map := {
	"Formation Board": "阵图棋盘",
	"Arcane Casting Board": "奥术施法棋盘",
	"Processing Grid": "处理网格"
}
var _container_name_map := {
	"Spatial Ring": "纳戒",
	"Arcane Grimoire": "奥术魔典",
	"Data Core": "数据核心"
}
var _pool_name_map := {
	"regular_reward_pool": "普通奖励池",
	"shop_pool": "商店池",
	"elite_reward_pool": "精英奖励池",
	"boss_faceup_pool": "Boss 明牌池"
}
var _cell_name_map := {
	"formation_heart": "阵心格",
	"formation_cell": "阵位格",
	"casting_lane": "施法通道",
	"arcane_anchor": "奥术锚点",
	"processing_lane": "处理通道",
	"bridge_cell": "桥接格",
	"processing_zone": "处理区"
}
var _cell_tooltip_map := {
	"formation_heart": "修士核心件尽量靠近这里，适合摆放真正吃阵法收益的主力。",
	"formation_cell": "支撑件和供能件放在这里，通常更容易带动周围结构。",
	"casting_lane": "法术件接入施法通道后，更容易形成清晰的施法链。",
	"arcane_anchor": "适合放需要准备、储能或回响的法术核心件。",
	"processing_lane": "AI 结构件沿着这里摆放，更容易形成稳定逻辑链。",
	"bridge_cell": "桥接格适合放连接件，让左右结构真正串起来。",
	"processing_zone": "处理区适合放最重要的核心处理器。"
}
var _item_name_map := {
	"azure_edge": "青锋",
	"spirit_talisman_strip": "灵符条",
	"lesser_spirit_stone": "下品灵石",
	"copper_furnace": "铜炉",
	"jade_guard_seal": "玉守印",
	"meridian_needle": "经脉针",
	"five_element_compass": "五行罗盘",
	"golden_core_fragment": "金丹残片",
	"ember_wand": "余烬法杖",
	"echo_sigil": "回响法印",
	"mana_prism": "法力棱镜",
	"delayed_glyph": "延时刻印",
	"mirror_ward": "镜面护障",
	"arc_flash_orb": "奥术闪球",
	"rune_lattice": "符文格阵",
	"astral_archive_page": "星界书页",
	"logic_core": "逻辑核心",
	"relay_node": "中继节点",
	"micro_battery": "微型电池",
	"drone_shell": "无人机外壳",
	"barrier_grid": "屏障矩阵",
	"error_filter": "错误过滤器",
	"optimization_engine": "优化引擎",
	"predictive_kernel": "预测内核"
}
var _item_desc_map := {
	"azure_edge": "需要合适朝向才能打出更高收益的基础输出件。",
	"spirit_talisman_strip": "修士支撑件，适合贴着核心输出件摆放。",
	"lesser_spirit_stone": "基础供能件，适合给修士主力或关键支撑补能。",
	"copper_furnace": "占地较大的修士引擎件，适合围绕它组织阵法结构。",
	"jade_guard_seal": "给附近有效结构提供保护的防御件。",
	"meridian_needle": "偏精细调整的修士辅助件。",
	"five_element_compass": "偏朝向与调律的修士工具件。",
	"golden_core_fragment": "偏后期构筑价值的高概念核心件。",
	"ember_wand": "把充能转成直接输出的法杖。",
	"echo_sigil": "放大附近法术结构的法印，适合做回响中心。",
	"mana_prism": "基础魔力来源，适合接到施法通道附近。",
	"delayed_glyph": "偏准备与延时触发的法术工具件。",
	"mirror_ward": "把法力转换成护盾的防御件。",
	"arc_flash_orb": "爆发型奥术输出件。",
	"rune_lattice": "适合搭建施法结构的法术框架件。",
	"astral_archive_page": "偏连锁与记忆效果的书页型法术件。",
	"logic_core": "AI 主核心，没有稳定链路时很难发挥全部价值。",
	"relay_node": "专门用来补链和延长结构的中继件。",
	"micro_battery": "给 AI 结构提供基础能源的便携电池。",
	"drone_shell": "偏执行层的机械外壳，适合挂在逻辑链末端。",
	"barrier_grid": "围绕结构展开的 AI 防御矩阵。",
	"error_filter": "降低链路不稳定风险的安全件。",
	"optimization_engine": "偏效率提升的 AI 引擎件。",
	"predictive_kernel": "偏预判和稳定循环的高阶处理件。"
}


func _ready() -> void:
	_game_data.load_all()
	_build_profession_selector()
	_profession_selector.item_selected.connect(_on_profession_selected)
	_build_initial_item_layout()
	if _profession_selector.item_count > 0:
		_on_profession_selected(0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not _drag_item_uid.is_empty():
		_move_dragged_item(event.global_position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and not _drag_item_uid.is_empty():
		_finish_drag(event.global_position)


func _build_profession_selector() -> void:
	var professions: Array = _game_data.professions.get_all_professions()
	_profession_selector.clear()
	_profession_ids.clear()

	for profession in professions:
		var profession_id: String = profession.get("id", "")
		_profession_ids.append(profession_id)
		_profession_selector.add_item(_localized_profession_name(profession))


func _build_initial_item_layout() -> void:
	_placed_items.clear()
	_next_uid = 1

	var starter_ids := {
		"cultivator": ["azure_edge", "spirit_talisman_strip", "lesser_spirit_stone", "jade_guard_seal"],
		"mage": ["ember_wand", "echo_sigil", "mana_prism", "mirror_ward"],
		"artificial_intelligence": ["logic_core", "relay_node", "micro_battery", "barrier_grid"]
	}

	for profession_id in starter_ids.keys():
		var id_list: Array = starter_ids[profession_id]
		for index in range(id_list.size()):
			var item_id: String = id_list[index]
			if _game_data.items.get_item(item_id).is_empty():
				continue

			var zone := "battle" if index < 2 else "storage"
			var col := 1 + (index % 2) * 2
			var row := 1 + int(index / 2) * 2
			_placed_items.append({
				"uid": "item_%d" % _next_uid,
				"profession_id": profession_id,
				"item_id": item_id,
				"zone": zone,
				"col": col,
				"row": row
			})
			_next_uid += 1


func _on_profession_selected(index: int) -> void:
	if index < 0 or index >= _profession_ids.size():
		return

	_current_profession_id = _profession_ids[index]
	_selected_item_uid = ""
	_drag_item_uid = ""
	_refresh_current_views()
	_render_item_details({})


func _refresh_current_views() -> void:
	_render_summary(_current_profession_id)
	_render_battle_space(_current_profession_id)
	_render_storage_space(_current_profession_id)
	if not _selected_item_uid.is_empty():
		_render_item_details(_find_placed_item(_selected_item_uid))


func _render_summary(profession_id: String) -> void:
	var items: Array = _game_data.items.get_all_items()
	var professions: Array = _game_data.professions.get_all_professions()
	var board_spaces: Dictionary = _game_data.boards.get_base_spaces()
	var reward_pools: Dictionary = _game_data.rewards.get_pools()
	var profession: Dictionary = _game_data.professions.get_profession(profession_id)
	var board_variant: Dictionary = _game_data.boards.get_variant_for_profession(profession_id)

	var battle_space: Dictionary = board_spaces.get("battle_space", {})
	var storage_space: Dictionary = board_spaces.get("storage_space", {})
	var profession_names: Array[String] = []

	for entry in professions:
		profession_names.append(_localized_profession_name(entry))

	_summary_label.text = "战前准备阶段：已载入 %d 个道具、%d 个职业、%d 个奖励池。" % [
		items.size(),
		professions.size(),
		reward_pools.size()
	]
	_action_hint_label.text = "操作说明：先在右上角切职业，再点选道具看说明，按住左键拖动到战斗空间或储物空间。"
	_variant_label.text = "当前职业：%s\n玩法重点：%s\n本职业目标：%s\n棋盘：%s\n容器：%s" % [
		_localized_profession_name(profession),
		_profession_pitch_map.get(profession_id, ""),
		_profession_goal_map.get(profession_id, ""),
		_localized_variant_name(board_variant.get("variant_name", "未知棋盘")),
		_localized_container_name(profession.get("container_name", "未知容器"))
	]
	_battle_info_label.text = "%s x %s（共 %s 格）" % [
		str(battle_space.get("columns", 0)),
		str(battle_space.get("rows", 0)),
		str(battle_space.get("total_cells", 0))
	]
	_storage_info_label.text = "%s x %s（共 %s 格）" % [
		str(storage_space.get("columns", 0)),
		str(storage_space.get("rows", 0)),
		str(storage_space.get("total_cells", 0))
	]

	var reward_lines: Array[String] = [
		"[b]现在你在做什么[/b]",
		"- 选择一个职业视角看这套构筑。",
		"- 把主力件放进战斗空间，把暂时用不到的放进储物空间。",
		"- 先围绕职业特殊格摆关键件，再补供能和支撑。",
		"",
		"[b]可选职业[/b]：%s" % " / ".join(profession_names),
		"[b]当前职业[/b]：%s" % _localized_profession_name(profession),
		"[b]玩法重点[/b]：%s" % _profession_pitch_map.get(profession_id, ""),
		"",
		"[b]奖励池概览[/b]"
	]
	for pool_name in reward_pools.keys():
		var pool_items: Array = reward_pools.get(pool_name, [])
		reward_lines.append("- %s：%d 个条目" % [_localized_pool_name(str(pool_name)), pool_items.size()])
	_reward_details.text = "\n".join(reward_lines)


func _render_battle_space(profession_id: String) -> void:
	_clear_children(_battle_cells)
	_clear_children(_battle_items)

	var battle_space: Dictionary = _game_data.boards.get_base_spaces().get("battle_space", {})
	var columns: int = battle_space.get("columns", 6)
	var rows: int = battle_space.get("rows", 5)
	var variant: Dictionary = _game_data.boards.get_variant_for_profession(profession_id)
	var cell_type_map := _build_cell_type_map(variant.get("cell_groups", {}))

	for row in range(1, rows + 1):
		for column in range(1, columns + 1):
			_battle_cells.add_child(_make_cell(column, row, cell_type_map.get(_coord_key(column, row), ""), false))

	for placed_item in _placed_items:
		if placed_item.get("profession_id", "") == profession_id and placed_item.get("zone", "") == "battle":
			_battle_items.add_child(_make_item_card(placed_item))


func _render_storage_space(profession_id: String) -> void:
	_clear_children(_storage_cells)
	_clear_children(_storage_items)

	var storage_space: Dictionary = _game_data.boards.get_base_spaces().get("storage_space", {})
	var columns: int = storage_space.get("columns", 4)
	var rows: int = storage_space.get("rows", 4)

	for row in range(1, rows + 1):
		for column in range(1, columns + 1):
			_storage_cells.add_child(_make_cell(column, row, "", true))

	for placed_item in _placed_items:
		if placed_item.get("profession_id", "") == profession_id and placed_item.get("zone", "") == "storage":
			_storage_items.add_child(_make_item_card(placed_item))


func _make_cell(column: int, row: int, cell_type: String, is_storage: bool) -> PanelContainer:
	var cell := PanelContainer.new()
	cell.position = _cell_position(column, row)
	cell.custom_minimum_size = CELL_SIZE
	cell.size = CELL_SIZE
	cell.modulate = Color(0.18, 0.2, 0.24, 1) if is_storage else _cell_color_for_type(cell_type)

	var margin := MarginContainer.new()
	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0
	margin.grow_horizontal = Control.GROW_DIRECTION_BOTH
	margin.grow_vertical = Control.GROW_DIRECTION_BOTH
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	cell.add_child(margin)

	var label := Label.new()
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = ("储 " if is_storage else "") + "%d,%d" % [column, row]
	if not cell_type.is_empty():
		label.text += "\n%s" % _localized_cell_name(cell_type)
		cell.tooltip_text = _localized_cell_tooltip(cell_type)
	margin.add_child(label)
	return cell


func _make_item_card(placed_item: Dictionary) -> PanelContainer:
	var item: Dictionary = _game_data.items.get_item(placed_item.get("item_id", ""))
	var panel := PanelContainer.new()
	panel.set_meta("item_uid", placed_item.get("uid", ""))
	var footprint := _item_footprint(item)
	panel.position = _cell_position(placed_item.get("col", 1), placed_item.get("row", 1))
	panel.custom_minimum_size = footprint
	panel.size = footprint
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_default_cursor_shape = Control.CURSOR_DRAG
	panel.modulate = _item_color_for_item(item, placed_item.get("uid", "") == _selected_item_uid)
	panel.z_index = 10 if placed_item.get("uid", "") == _drag_item_uid else 1
	panel.gui_input.connect(func(event: InputEvent) -> void: _on_item_gui_input(placed_item.get("uid", ""), event))
	panel.tooltip_text = _localized_item_description(item)

	var margin := MarginContainer.new()
	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0
	margin.grow_horizontal = Control.GROW_DIRECTION_BOTH
	margin.grow_vertical = Control.GROW_DIRECTION_BOTH
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text = "%s\n%s" % [
		_localized_item_name(item),
		" / ".join(item.get("function_tags", []))
	]
	margin.add_child(label)

	return panel


func _on_item_gui_input(item_uid: String, event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_selected_item_uid = item_uid
			_render_item_details(_find_placed_item(item_uid))
			_begin_drag(item_uid, event.global_position)
		elif item_uid == _drag_item_uid:
			_finish_drag(event.global_position)


func _begin_drag(item_uid: String, global_pos: Vector2) -> void:
	var card := _find_item_card(_battle_items, item_uid)
	if card == null:
		card = _find_item_card(_storage_items, item_uid)
	if card == null:
		return

	_drag_item_uid = item_uid
	_drag_pointer_offset = global_pos - card.global_position
	card.z_index = 20
	card.modulate = card.modulate.lightened(0.12)
	_move_dragged_item(global_pos)


func _move_dragged_item(global_pos: Vector2) -> void:
	var card := _find_item_card(_battle_items, _drag_item_uid)
	if card == null:
		card = _find_item_card(_storage_items, _drag_item_uid)
	if card == null:
		return

	card.global_position = global_pos - _drag_pointer_offset
	_action_hint_label.text = _drag_hint_text(global_pos)


func _finish_drag(global_pos: Vector2) -> void:
	var placed_item := _find_placed_item(_drag_item_uid)
	if placed_item.is_empty():
		_drag_item_uid = ""
		return

	var target := _detect_drop_target(global_pos)
	if not target.is_empty():
		placed_item["zone"] = target["zone"]
		placed_item["col"] = target["col"]
		placed_item["row"] = target["row"]

	_drag_item_uid = ""
	_refresh_current_views()
	_render_item_details(placed_item)
	_action_hint_label.text = "已放到 %s %d,%d。你可以继续调整，或切换职业观察这件道具是否还适合当前棋盘。" % [
		"战斗空间" if placed_item.get("zone", "") == "battle" else "储物空间",
		int(placed_item.get("col", 1)),
		int(placed_item.get("row", 1))
	]


func _detect_drop_target(global_pos: Vector2) -> Dictionary:
	var battle_rect := Rect2(_battle_items.global_position, _battle_items.size)
	if battle_rect.has_point(global_pos):
		var battle_local := _battle_items.get_global_transform_with_canvas().affine_inverse() * global_pos
		return _snap_to_zone("battle", battle_local)

	var storage_rect := Rect2(_storage_items.global_position, _storage_items.size)
	if storage_rect.has_point(global_pos):
		var storage_local := _storage_items.get_global_transform_with_canvas().affine_inverse() * global_pos
		return _snap_to_zone("storage", storage_local)

	return {}


func _snap_to_zone(zone: String, local_pos: Vector2) -> Dictionary:
	var board_spaces: Dictionary = _game_data.boards.get_base_spaces()
	var space: Dictionary = board_spaces.get("battle_space", {}) if zone == "battle" else board_spaces.get("storage_space", {})
	var columns: int = space.get("columns", 1)
	var rows: int = space.get("rows", 1)
	var col: int = clamp(int(floor(local_pos.x / (CELL_SIZE.x + CELL_GAP))) + 1, 1, columns)
	var row: int = clamp(int(floor(local_pos.y / (CELL_SIZE.y + CELL_GAP))) + 1, 1, rows)
	return {"zone": zone, "col": col, "row": row}


func _render_item_details(placed_item: Dictionary) -> void:
	if placed_item.is_empty():
		_item_details.text = "[b]怎么理解这版原型[/b]\n- 左边是战斗空间，只有摆在这里的道具会参与战斗。\n- 下方是储物空间，用来保管暂时不用的道具。\n- 右上角切职业后，棋盘特殊格和推荐摆法都会变化。\n- 先点一个道具，再看这里的中文说明和摆放建议。"
		return

	var item: Dictionary = _game_data.items.get_item(placed_item.get("item_id", ""))
	var detail_lines: Array[String] = [
		"[b]%s[/b]" % _localized_item_name(item),
		"",
		"[b]描述[/b]：%s" % _localized_item_description(item),
		"[b]当前区域[/b]：%s" % ("战斗空间" if placed_item.get("zone", "") == "battle" else "储物空间"),
		"[b]当前坐标[/b]：(%s,%s)" % [str(placed_item.get("col", 1)), str(placed_item.get("row", 1))],
		"[b]家族标签[/b]：%s" % _format_tag_list(item.get("family_tags", [])),
		"[b]功能标签[/b]：%s" % _format_tag_list(item.get("function_tags", [])),
		"[b]激活标签[/b]：%s" % _format_tag_list(item.get("activation_tags", [])),
		"[b]职业亲和[/b]：%s" % _format_affinity_list(item.get("profession_affinity_tags", [])),
		"",
		"[b]摆放建议[/b]：%s" % _placement_suggestion(item)
	]
	_item_details.text = "\n".join(detail_lines)


func _drag_hint_text(global_pos: Vector2) -> String:
	var target := _detect_drop_target(global_pos)
	if target.is_empty():
		return "拖拽中：把道具移到左侧战斗空间，或下方储物空间后再松手。"

	return "拖拽中：准备放到 %s (%d,%d)。" % [
		"战斗空间" if target.get("zone", "") == "battle" else "储物空间",
		int(target.get("col", 1)),
		int(target.get("row", 1))
	]


func _find_placed_item(item_uid: String) -> Dictionary:
	for placed_item in _placed_items:
		if placed_item.get("uid", "") == item_uid and placed_item.get("profession_id", "") == _current_profession_id:
			return placed_item
	return {}


func _find_item_card(container: Control, item_uid: String) -> Control:
	for child in container.get_children():
		if child.has_meta("item_uid") and child.get_meta("item_uid") == item_uid:
			return child
	return null


func _build_cell_type_map(cell_groups: Dictionary) -> Dictionary:
	var cell_type_map: Dictionary = {}
	for cell_type in cell_groups.keys():
		var coords: Array = cell_groups.get(cell_type, [])
		for coord in coords:
			if coord is Array and coord.size() >= 2:
				cell_type_map[_coord_key(int(coord[0]), int(coord[1]))] = cell_type
	return cell_type_map


func _coord_key(column: int, row: int) -> String:
	return "%d,%d" % [column, row]


func _cell_position(column: int, row: int) -> Vector2:
	return Vector2((column - 1) * (CELL_SIZE.x + CELL_GAP), (row - 1) * (CELL_SIZE.y + CELL_GAP))


func _item_footprint(item: Dictionary) -> Vector2:
	var shape: Dictionary = item.get("shape", {})
	var width: int = shape.get("width", 1)
	var height: int = shape.get("height", 1)
	return Vector2(
		width * CELL_SIZE.x + max(0, width - 1) * CELL_GAP,
		height * CELL_SIZE.y + max(0, height - 1) * CELL_GAP
	)


func _clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()


func _localized_profession_name(profession: Dictionary) -> String:
	var profession_id: String = profession.get("id", "")
	return _profession_name_map.get(profession_id, profession.get("name", "未知职业"))


func _localized_variant_name(variant_name: String) -> String:
	return _profession_variant_name_map.get(variant_name, variant_name)


func _localized_container_name(container_name: String) -> String:
	return _container_name_map.get(container_name, container_name)


func _localized_pool_name(pool_name: String) -> String:
	return _pool_name_map.get(pool_name, pool_name)


func _localized_cell_name(cell_type: String) -> String:
	return _cell_name_map.get(cell_type, cell_type)


func _localized_cell_tooltip(cell_type: String) -> String:
	return _cell_tooltip_map.get(cell_type, cell_type)


func _localized_item_name(item: Dictionary) -> String:
	var item_id: String = item.get("id", "")
	return _item_name_map.get(item_id, item.get("name", "未知道具"))


func _localized_item_description(item: Dictionary) -> String:
	var item_id: String = item.get("id", "")
	return _item_desc_map.get(item_id, item.get("description", ""))


func _format_tag_list(tags: Array) -> String:
	if tags.is_empty():
		return "暂无"
	return "、".join(tags)


func _format_affinity_list(tags: Array) -> String:
	if tags.is_empty():
		return "通用"

	var localized: Array[String] = []
	for tag in tags:
		match str(tag):
			"cultivator_affinity":
				localized.append("修士")
			"mage_affinity":
				localized.append("魔法师")
			"ai_affinity":
				localized.append("人工智能")
			_:
				localized.append(str(tag))
	return "、".join(localized)


func _placement_suggestion(item: Dictionary) -> String:
	var affinities: Array = item.get("profession_affinity_tags", [])
	if _current_profession_id == "cultivator":
		if "cultivator_affinity" in affinities:
			return "优先靠近阵心格或阵位格，核心输出件吃位置，供能件和支撑件贴着摆。"
		return "这件更像通用件，先放储物空间也可以，等修士核心阵法成型后再决定是否上场。"
	if _current_profession_id == "mage":
		if "mage_affinity" in affinities:
			return "优先接进施法通道或奥术锚点附近，尽量围绕充能和爆发节奏摆放。"
		return "如果当前法术链还没成型，可以先放储物空间，等后续拿到配合件。"
	if _current_profession_id == "artificial_intelligence":
		if "ai_affinity" in affinities:
			return "优先接到处理通道、桥接格或处理区周围，尽量把结构连成一整条链。"
		return "如果暂时接不上逻辑链，先保存在储物空间会更稳。"
	return "先放在不阻塞核心位置的区域，观察后续联动。"


func _cell_color_for_type(cell_type: String) -> Color:
	match cell_type:
		"formation_heart":
			return Color(0.74, 0.56, 0.22, 1)
		"formation_cell":
			return Color(0.5, 0.39, 0.18, 1)
		"casting_lane":
			return Color(0.22, 0.36, 0.7, 1)
		"arcane_anchor":
			return Color(0.42, 0.24, 0.72, 1)
		"processing_lane":
			return Color(0.14, 0.55, 0.46, 1)
		"bridge_cell":
			return Color(0.2, 0.66, 0.62, 1)
		"processing_zone":
			return Color(0.09, 0.42, 0.36, 1)
		_:
			return Color(0.2, 0.22, 0.26, 1)


func _item_color_for_item(item: Dictionary, is_selected: bool) -> Color:
	var affinity_tags: Array = item.get("profession_affinity_tags", [])
	var base := Color(0.32, 0.34, 0.4, 1)
	if "cultivator_affinity" in affinity_tags:
		base = Color(0.55, 0.44, 0.22, 1)
	elif "mage_affinity" in affinity_tags:
		base = Color(0.33, 0.28, 0.62, 1)
	elif "ai_affinity" in affinity_tags:
		base = Color(0.18, 0.5, 0.45, 1)
	if is_selected:
		base = base.lightened(0.22)
	return base
