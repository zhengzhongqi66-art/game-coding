class_name DataLoader
extends RefCounted

static func load_json_file(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open JSON file: %s" % path)
		return {}

	var raw_text := file.get_as_text()
	var json := JSON.new()
	var parse_error := json.parse(raw_text)
	if parse_error != OK:
		push_error("Failed to parse JSON file %s: %s at line %d" % [
			path,
			json.get_error_message(),
			json.get_error_line()
		])
		return {}

	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Expected JSON object at root for file: %s" % path)
		return {}

	return data

