extends Resource
class_name MonsterData

@export var id: String
@export var monster_name: String = "\u602a\u7269"
@export_multiline var description: String = ""

@export_group("Base Stats")
@export var base_hp: int = 60
@export var base_defense: int = 2

@export_group("Six Attributes")
@export var strength: int = 0
@export var agility: int = 0
@export var intelligence: int = 0
@export var constitution: int = 0
@export var spirit: int = 0
@export var perception: int = 0

@export_group("Display")
@export var display_color: Color = Color(0.3, 0.7, 0.3)

@export_group("Default Items")
@export var default_item_ids: Array = []
