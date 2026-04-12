class_name BoardRegistry
extends RefCounted

const BOARD_VARIANTS_PATH := "res://data/boards/board_variants_v1.json"
const DataLoaderScript = preload("res://scripts/data/data_loader.gd")

var _data: Dictionary = {}
var _variants_by_profession: Dictionary = {}

func load_data() -> void:
	_data = DataLoaderScript.load_json_file(BOARD_VARIANTS_PATH)
	_variants_by_profession.clear()

	for variant in _data.get("profession_board_variants", []):
		var profession_id: String = variant.get("profession_id", "")
		if profession_id.is_empty():
			push_warning("Encountered board variant without profession_id in %s" % BOARD_VARIANTS_PATH)
			continue
		_variants_by_profession[profession_id] = variant

func get_base_spaces() -> Dictionary:
	return _data.get("base_spaces", {})

func get_special_cell_types() -> Dictionary:
	return _data.get("special_cell_types", {})

func get_variant_for_profession(profession_id: String) -> Dictionary:
	return _variants_by_profession.get(profession_id, {})
