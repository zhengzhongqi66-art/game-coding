class_name GameData
extends RefCounted

const ItemRegistryScript = preload("res://scripts/data/item_registry.gd")
const ProfessionRegistryScript = preload("res://scripts/data/profession_registry.gd")
const BoardRegistryScript = preload("res://scripts/data/board_registry.gd")
const RewardRegistryScript = preload("res://scripts/data/reward_registry.gd")

var items = ItemRegistryScript.new()
var professions = ProfessionRegistryScript.new()
var boards = BoardRegistryScript.new()
var rewards = RewardRegistryScript.new()

func load_all() -> void:
	items.load_data()
	professions.load_data()
	boards.load_data()
	rewards.load_data()
