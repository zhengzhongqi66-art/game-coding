# Item Data Schema

## 1. Purpose

This document defines the first-version item data schema for implementation.

The goal is to convert the planning set into a format that can support:

- item content production
- tool validation
- UI tooltips
- profession rule checks
- battle and board logic

## 2. First-version schema philosophy

The first schema should be:

- simple enough to author quickly
- strict enough to validate automatically
- expressive enough to support the current prototype vision

The first schema should not try to solve every future system at once.

## 3. Recommended top-level fields

Each item record should contain:

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

## 4. Field definitions

### `id`

- unique string id
- lowercase snake_case recommended
- should never change after implementation starts

Example:

- `azure_edge`

### `name`

- full player-facing display name

Example:

- `Azure Edge`

### `short_name`

- optional short UI label for compact views

### `description`

- one short readable gameplay sentence
- should explain the main role, not every hidden rule

### `family_tags`

- array of family tags
- must contain at least one valid family tag

### `function_tags`

- array of function tags
- should contain one primary function and optionally one secondary function

### `activation_tags`

- array of activation tags
- should support both simulation logic and UI explanation

### `spatial_tags`

- array of spatial tags
- may be empty if the item has no notable spatial identity beyond shape

### `profession_affinity_tags`

- array of profession affinity tags
- may contain one or more values

### `world_tags`

- array of world origin tags

### `shape`

- object describing footprint

Recommended shape object:

- `type`
- `width`
- `height`
- `cells`

Examples:

- rectangle item: width and height are enough
- special shape item: `cells` stores occupied offsets

### `rotatable`

- boolean

### `rarity`

- first-version recommended values:
  - `common`
  - `uncommon`
  - `rare`
  - `boss`

### `source_tags`

- array describing where the item can appear

Recommended values:

- `regular_reward`
- `shop`
- `elite_reward`
- `boss_faceup`
- `event_reward`

### `base_values`

- object storing numeric base values

Examples:

- `power`
- `support_value`
- `energy_value`
- `defense_value`
- `charge_value`

Not every item needs every field.

### `requirements`

- object describing activation or board requirements

Recommended possible fields:

- `adjacent_tags`
- `required_direction`
- `required_energy`
- `required_links`
- `required_charge`
- `required_profession_state`
- `required_special_cell_state`

### `effects`

- array of structured effect objects
- each effect should define what happens if requirements are met

Recommended effect fields:

- `type`
- `target`
- `value`
- `timing`
- `conditions`

### `ui_keywords`

- array of short strings reused in tooltips and glossary UI

### `debug_notes`

- optional string for internal balance or implementation notes

## 5. Shape object recommendation

Recommended shape formats:

### Simple rectangle

```json
{
  "type": "rectangle",
  "width": 1,
  "height": 2
}
```

### Irregular shape

```json
{
  "type": "custom",
  "width": 2,
  "height": 2,
  "cells": [[0,0], [1,0], [0,1]]
}
```

## 6. Effect object recommendation

Recommended first-version effect types:

- `deal_damage`
- `grant_shield`
- `grant_support`
- `grant_energy`
- `convert_value`
- `retain_charge`
- `improve_link`
- `apply_state`

Example:

```json
{
  "type": "grant_support",
  "target": "adjacent_valid_item",
  "value": 2,
  "timing": "continuous",
  "conditions": ["requires_adjacent"]
}
```

## 7. Requirement-state integration

The schema should support profession and board-state checks without hardcoding every item.

Recommended rule:

- `requirements.required_profession_state` can reference:
  - `clean_alignment`
  - `spell_sequence_ready`
  - `full_logic_chain`
  - `stable_cycle`

- `requirements.required_special_cell_state` can reference:
  - `formation_heart`
  - `formation_cell`
  - `casting_lane`
  - `arcane_anchor`
  - `processing_lane`
  - `bridge_cell`
  - `processing_zone`

## 8. Validation rules

Tools should validate:

- every item has a unique id
- every tag exists in the approved tag list
- shape data is legal
- source tags are valid
- required states reference real states
- effects use supported effect types

## 9. Example item record

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

## 10. Immediate production implications

The next planning layer should define:

- profession data schema
- board and special-cell data schema
- reward table schema
- first actual data-sheet draft for the 24-item roster
