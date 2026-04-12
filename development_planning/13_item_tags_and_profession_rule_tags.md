# Item Tags And Profession Rule Tags

## 1. Purpose

This document defines the first standardized tag set for:

- item identity
- item behavior
- profession checks
- space and activation logic

The goal is to ensure that future content, balance, UI, and code all refer to the same concepts consistently.

## 2. Tagging principles

The first-version tag system should be:

- small enough to manage
- expressive enough to support profession rules
- readable by designers
- easy to validate in tools

Tagging should not become an uncontrolled keyword dump.

## 3. Tag categories

The first version should separate tags into these groups:

- item family tags
- function tags
- activation tags
- spatial tags
- profession affinity tags
- world identity tags

Each tag should have one primary meaning.

## 4. Item family tags

These tags describe what an item fundamentally is.

Recommended first-version family tags:

- `weapon`
- `talisman`
- `spirit_stone`
- `furnace`
- `relic`
- `focus`
- `spell_tool`
- `processor`
- `drone_module`
- `logic_relay`
- `defense`
- `utility`

Rule:

- every item should have at least one family tag
- most items should have only one or two family tags

## 5. Function tags

These tags describe what an item mainly does in a build.

Recommended first-version function tags:

- `engine`
- `support`
- `energy_source`
- `energy_link`
- `converter`
- `burst`
- `sustain`
- `defense_layer`
- `economy`
- `recovery`
- `control`
- `setup`

Rule:

- every item should have exactly one primary function tag
- an item may have one secondary function tag if needed

## 6. Activation tags

These tags describe how an item becomes active or gains value.

Recommended first-version activation tags:

- `requires_adjacent`
- `requires_direction`
- `requires_energy`
- `requires_link`
- `requires_charge`
- `requires_chain`
- `start_of_battle`
- `timed_trigger`
- `on_hit`
- `on_support`
- `on_destroy`
- `on_cycle_end`

Rule:

- activation tags should be used by simulation and UI
- profession rules should reference these tags instead of hardcoding item names whenever possible

## 7. Spatial tags

These tags describe space-facing structure.

Recommended first-version spatial tags:

- `rotatable`
- `line_based`
- `adjacency_core`
- `occupies_large_space`
- `backline_pref`
- `frontline_pref`
- `storage_friendly`
- `layout_sensitive`

Rule:

- spatial tags should help UI preview and quick sorting
- not every item needs a spatial tag, but layout-sensitive items should always have one

## 8. Profession affinity tags

These tags indicate which profession naturally benefits from or prefers an item.

Recommended first-version profession affinity tags:

- `cultivator_affinity`
- `mage_affinity`
- `ai_affinity`

Rule:

- affinity tags indicate synergy bias, not hard restriction
- an item may support more than one profession
- avoid profession-locked items in the first version unless absolutely needed

## 9. World identity tags

These tags indicate theme or world origin.

Recommended first-version world tags:

- `xianxia_origin`
- `arcane_origin`
- `synthetic_origin`

Rule:

- world tags should support content grouping, reward biasing, and art direction
- world tags should not automatically define profession synergy

## 10. Profession rule tags

In addition to item tags, the system should define reusable rule tags for profession checks.

Recommended first-version profession rule tags:

- `clean_alignment`
- `valid_energy_path`
- `valid_support_target`
- `charged_state`
- `spell_sequence_ready`
- `full_logic_chain`
- `stable_cycle`

Purpose:

- these tags describe validated build states
- profession passives can reward these states directly
- UI can explain them cleanly

## 11. First-pass profession tag usage

### Cultivator

Should most often interact with:

- `talisman`
- `spirit_stone`
- `weapon`
- `requires_direction`
- `requires_energy`
- `valid_energy_path`
- `clean_alignment`

### Mage

Should most often interact with:

- `focus`
- `spell_tool`
- `requires_charge`
- `requires_chain`
- `charged_state`
- `spell_sequence_ready`

### Artificial Intelligence

Should most often interact with:

- `processor`
- `drone_module`
- `logic_relay`
- `requires_link`
- `full_logic_chain`
- `stable_cycle`

## 12. Data rules

Recommended minimum item data fields:

- `id`
- `name`
- `family_tags`
- `function_tags`
- `activation_tags`
- `spatial_tags`
- `profession_affinity_tags`
- `world_tags`

Optional later fields:

- `rule_state_outputs`
- `tooltip_keywords`
- `ai_evaluation_notes`

## 13. Validation rules

The tag system is working only if:

- designers can tag new items without confusion
- profession rules can be implemented mostly through tags
- UI explanations can reuse the same terms
- balance review can group items by tag
- the number of tags stays understandable

## 14. Immediate production implications

The next planning layer should define:

- first item roster with assigned tags
- profession passive UI wording using these tags
- data validation rules for tag misuse
- reward table bias logic by profession and world tags
