extends Resource

## 物品ID
@export var id: String
## 物品名称
@export var item_name: String
## 物品描述
@export_multiline var description: String
## 物品图标
@export var icon: Texture2D
## 最大堆叠数量
@export var max_stack: int = 1
## 物品类型
@export var item_type: String = "道具"

## 占用格子尺寸
@export_group("格子尺寸")
@export var base_grid_size: Vector2i = Vector2i(1, 1)  # 基础尺寸（未旋转时）
@export var rotation: int = 0  # 旋转角度 (0, 90, 180, 270)

## 战斗属性加成
@export_group("战斗属性")
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0
@export var hp_bonus: int = 0
@export var speed_bonus: float = 0.0

## 获取当前格子尺寸（根据旋转）
func get_grid_size() -> Vector2i:
	if rotation == 90 or rotation == 270:
		return Vector2i(base_grid_size.y, base_grid_size.x)
	return base_grid_size

## 剑尖是否朝向指定方向
## direction: "right", "left", "up", "down"
func is_facing_direction(direction: String) -> bool:
	match direction:
		"right": return rotation == 0
		"down": return rotation == 90
		"left": return rotation == 180
		"up": return rotation == 270
	return false

## 获取剑尖朝向描述
func get_facing_text() -> String:
	match rotation:
		0: return "→"
		90: return "↓"
		180: return "←"
		270: return "↑"
	return ""

## 获取当前攻击力
## enemy_direction: "right", "left", "up", "down"
## 如果不传方向参数，则直接返回全额攻击（用于怪物装备）
func get_attack(enemy_direction: String = "") -> int:
	if item_type == "武器" and enemy_direction != "":
		if is_facing_direction(enemy_direction):
			return attack_bonus
		else:
			return int(attack_bonus * 0.5)  # 背向敌人伤害减半
	return attack_bonus
