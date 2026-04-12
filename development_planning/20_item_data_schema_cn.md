# 道具数据结构规范

## 1. 文档目的

这份文档用于定义首版实现层的道具数据结构规范。

目标是把现有规划转成能够支撑以下工作的数据格式：

- 道具内容生产
- 工具校验
- UI tooltip
- 职业规则判定
- 战斗与棋盘逻辑

## 2. 首版 schema 原则

首版 schema 应满足：

- 足够简单，能快速录入
- 足够严格，能自动校验
- 足够表达当前原型愿景

首版 schema 不应该试图一次性解决所有未来系统。

## 3. 推荐顶层字段

每个道具记录建议包含：

- `id`
- `name`
- `short_name`
- `description`
- `family_tags`
- `function_tags`
- `activation_tags`
- `spatial_tags`
- `profession_affinity_tags`
- `world_tags`
- `shape`
- `rotatable`
- `rarity`
- `source_tags`
- `base_values`
- `requirements`
- `effects`
- `ui_keywords`
- `debug_notes`

## 4. 字段定义

### `id`

- 唯一字符串 id
- 建议使用小写 snake_case
- 一旦进入实现阶段，尽量不要再改

例如：

- `azure_edge`

### `name`

- 玩家可见的完整显示名

例如：

- `Azure Edge`

### `short_name`

- 用于紧凑 UI 的短名

### `description`

- 一句简短、可读的玩法描述
- 解释主作用，不要把隐藏规则全塞进去

### `family_tags`

- 家族标签数组
- 至少要有一个有效家族标签

### `function_tags`

- 功能标签数组
- 应包含一个主功能标签，必要时可再补一个次功能标签

### `activation_tags`

- 激活标签数组
- 应同时服务模拟层与 UI 层

### `spatial_tags`

- 空间标签数组
- 如果该道具除了形状没有额外空间身份，可以为空

### `profession_affinity_tags`

- 职业亲和标签数组
- 可以包含一个或多个值

### `world_tags`

- 世界来源标签数组

### `shape`

- 用于描述占位的对象

建议结构：

- `type`
- `width`
- `height`
- `cells`

例如：

- 矩形道具只需要宽高
- 特殊形状道具通过 `cells` 存占位偏移

### `rotatable`

- 布尔值

### `rarity`

- 首版建议值：
  - `common`
  - `uncommon`
  - `rare`
  - `boss`

### `source_tags`

- 描述道具来源的数组

建议值：

- `regular_reward`
- `shop`
- `elite_reward`
- `boss_faceup`
- `event_reward`

### `base_values`

- 用于存放基础数值的对象

例如：

- `power`
- `support_value`
- `energy_value`
- `defense_value`
- `charge_value`

并不是每个道具都必须拥有全部字段。

### `requirements`

- 用于描述激活条件或棋盘条件的对象

建议可能字段：

- `adjacent_tags`
- `required_direction`
- `required_energy`
- `required_links`
- `required_charge`
- `required_profession_state`
- `required_special_cell_state`

### `effects`

- 由结构化 effect 对象组成的数组
- 每个 effect 用于描述满足条件后发生什么

建议 effect 字段：

- `type`
- `target`
- `value`
- `timing`
- `conditions`

### `ui_keywords`

- 可复用于 tooltip 和术语表的短字符串数组

### `debug_notes`

- 内部平衡或实现备注，可选

## 5. Shape 对象建议

推荐 shape 格式：

### 简单矩形

```json
{
  "type": "rectangle",
  "width": 1,
  "height": 2
}
```

### 不规则形状

```json
{
  "type": "custom",
  "width": 2,
  "height": 2,
  "cells": [[0,0], [1,0], [0,1]]
}
```

## 6. Effect 对象建议

首版建议的 effect 类型：

- `deal_damage`
- `grant_shield`
- `grant_support`
- `grant_energy`
- `convert_value`
- `retain_charge`
- `improve_link`
- `apply_state`

例如：

```json
{
  "type": "grant_support",
  "target": "adjacent_valid_item",
  "value": 2,
  "timing": "continuous",
  "conditions": ["requires_adjacent"]
}
```

## 7. 与职业状态和棋盘状态的整合

这个 schema 应支持职业状态与棋盘状态判定，而不是把所有道具写死。

建议规则：

- `requirements.required_profession_state` 可引用：
  - `clean_alignment`
  - `spell_sequence_ready`
  - `full_logic_chain`
  - `stable_cycle`

- `requirements.required_special_cell_state` 可引用：
  - `formation_heart`
  - `formation_cell`
  - `casting_lane`
  - `arcane_anchor`
  - `processing_lane`
  - `bridge_cell`
  - `processing_zone`

## 8. 校验规则

工具层应校验：

- 每个道具 id 唯一
- 所有标签都存在于批准标签表中
- shape 数据合法
- source_tags 合法
- 引用的状态名真实存在
- effect 类型在支持列表中

## 9. 示例道具记录

```json
{
  "id": "azure_edge",
  "name": "Azure Edge",
  "short_name": "Azure Edge",
  "description": "A directional blade that rewards clean alignment.",
  "family_tags": ["weapon"],
  "function_tags": ["engine", "burst"],
  "activation_tags": ["requires_direction"],
  "spatial_tags": ["rotatable", "layout_sensitive"],
  "profession_affinity_tags": ["cultivator_affinity"],
  "world_tags": ["xianxia_origin"],
  "shape": {
	"type": "rectangle",
	"width": 1,
	"height": 2
  },
  "rotatable": true,
  "rarity": "common",
  "source_tags": ["regular_reward", "shop"],
  "base_values": {
	"power": 4
  },
  "requirements": {
	"required_direction": true
  },
  "effects": [
	{
	  "type": "deal_damage",
	  "target": "front_enemy",
	  "value": 4,
	  "timing": "timed_trigger",
	  "conditions": ["requires_direction"]
	}
  ],
  "ui_keywords": ["direction", "blade", "alignment"],
  "debug_notes": "Baseline Cultivator weapon."
}
```

## 10. 对制作的直接影响

下一层规划应继续定义：

- 职业数据结构规范
- 棋盘与特殊格数据结构规范
- 奖励表数据结构规范
- 24 个首批道具的实际数据表草案
