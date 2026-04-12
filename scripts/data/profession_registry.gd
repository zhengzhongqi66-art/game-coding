class_name ProfessionRegistry
extends RefCounted

const PROFESSION_ROSTER_PATH := "res://data/professions/profession_roster_v1.json"
const DataLoaderScript = preload("res://scripts/data/data_loader.gd")

var _data: Dictionary = {}
var _professions_by_id: Dictionary = {}

func load_data() -> void:
	_data = DataLoaderScript.load_json_file(PROFESSION_ROSTER_PATH)
	_professions_by_id.clear()

	for profession in _data.get("professions", []):
		var profession_id: String = profession.get("id", "")
		if profession_id.is_empty():
			push_warning("Encountered profession without id in %s" % PROFESSION_ROSTER_PATH)
			continue
		_professions_by_id[profession_id] = profession

func get_all_professions() -> Array:
	return _data.get("professions", [])

func get_profession(profession_id: String) -> Dictionary:
	return _professions_by_id.get(profession_id, {})
