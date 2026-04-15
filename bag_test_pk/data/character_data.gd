extends Resource
class_name CharacterData

@export var id: String
@export var character_name: String = "\u89d2\u8272"

@export_group("Base Stats")
@export var base_hp: int = 100
@export var base_defense: int = 5

@export_group("Six Attributes")
@export var strength: int = 0
@export var agility: int = 0
@export var intelligence: int = 0
@export var constitution: int = 0
@export var spirit: int = 0
@export var perception: int = 0

@export_group("Display")
@export var display_color: Color = Color(0.2, 0.5, 0.8)
