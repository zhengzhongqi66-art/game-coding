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
@export var grid_size: Vector2i = Vector2i(1, 1)  # 宽x高

## 战斗属性加成
@export_group("战斗属性")
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0
@export var hp_bonus: int = 0
@export var speed_bonus: float = 0.0

## 武器朝向
@export_group("武器朝向")
@export_enum("right:0", "left:1") var direction: int = 0  # 0=向右, 1=向左

## 获取当前攻击力（根据朝向）
func get_attack() -> int:
	if item_type == "武器":
		if direction == 0:  # 向右
			return attack_bonus
		else:  # 向左
			return int(attack_bonus * 0.5)  # 向左伤害减半
	return attack_bonus
