class_name ItemRegistry
extends RefCounted

const ITEM_ROSTER_PATH := "res://data/items/roster/first_item_roster_v1.json"
const DataLoaderScript = preload("res://scripts/data/data_loader.gd")

var _data: Dictionary = {}
var _items_by_id: Dictionary = {}

func load_data() -> void:
	_data = DataLoaderScript.load_json_file(ITEM_ROSTER_PATH)
	_items_by_id.clear()

	for item in _data.get("items", []):
		var item_id: String = item.get("id", "")
		if item_id.is_empty():
			push_warning("Encountered item without id in %s" % ITEM_ROSTER_PATH)
			continue
		_items_by_id[item_id] = item

func get_all_items() -> Array:
	return _data.get("items", [])

func get_item(item_id: String) -> Dictionary:
	return _items_by_id.get(item_id, {})
