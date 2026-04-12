class_name RewardRegistry
extends RefCounted

const REWARD_TABLES_PATH := "res://data/rewards/reward_tables_v1.json"
const DataLoaderScript = preload("res://scripts/data/data_loader.gd")

var _data: Dictionary = {}

func load_data() -> void:
	_data = DataLoaderScript.load_json_file(REWARD_TABLES_PATH)

func get_encounter_reward_rules() -> Dictionary:
	return _data.get("encounter_reward_rules", {})

func get_shop_rules() -> Dictionary:
	return _data.get("shop_rules", {})

func get_pools() -> Dictionary:
	return _data.get("pools", {})

func get_profession_bias() -> Dictionary:
	return _data.get("profession_bias", {})
