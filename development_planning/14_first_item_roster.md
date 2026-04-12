# First Item Roster

## 1. Purpose

This document defines the recommended first-version item roster for prototype and vertical-slice production.

The goal is not maximum content volume.
The goal is a compact item pool that can already prove:

- meaningful arrangement
- profession contrast
- reward branching
- readable combat payoff

## 2. Scope target

Recommended first production pool:

- 24 items total

Recommended split:

- 8 Cultivator-leaning items
- 8 Mage-leaning items
- 8 Artificial-Intelligence-leaning items

Design rule:

- this does not mean each item is profession-locked
- it means each profession should have enough affinity support to form a recognizable early build identity

## 3. Roster structure rules

The first roster should include:

- engine items
- support items
- energy items
- conversion or utility items
- defense items
- a few high-payoff pieces

The first roster should avoid:

- too many edge-case-only items
- joke items
- items that require many exceptions to understand

## 4. Cultivator-leaning items

### 1. Azure Edge

- family tags: `weapon`
- function tags: `engine`, `burst`
- activation tags: `requires_direction`
- spatial tags: `rotatable`, `layout_sensitive`
- profession affinity: `cultivator_affinity`
- source: regular reward or shop
- role: basic directional damage engine

### 2. Spirit Talisman Strip

- family tags: `talisman`
- function tags: `support`
- activation tags: `requires_adjacent`, `on_support`
- spatial tags: `adjacency_core`
- profession affinity: `cultivator_affinity`
- source: regular reward or shop
- role: basic adjacent support enabler

### 3. Lesser Spirit Stone

- family tags: `spirit_stone`
- function tags: `energy_source`
- activation tags: `start_of_battle`
- profession affinity: `cultivator_affinity`
- source: regular reward or shop
- role: baseline energy provider

### 4. Copper Furnace

- family tags: `furnace`
- function tags: `setup`, `support`
- activation tags: `requires_adjacent`, `timed_trigger`
- spatial tags: `occupies_large_space`, `layout_sensitive`
- profession affinity: `cultivator_affinity`
- source: shop or elite reward
- role: surround-style support engine

### 5. Jade Guard Seal

- family tags: `talisman`, `defense`
- function tags: `defense_layer`
- activation tags: `requires_adjacent`
- profession affinity: `cultivator_affinity`
- source: regular reward or shop
- role: adjacency-based shield support

### 6. Meridian Needle

- family tags: `weapon`, `utility`
- function tags: `converter`
- activation tags: `requires_energy`, `on_hit`
- spatial tags: `line_based`
- profession affinity: `cultivator_affinity`
- source: elite reward
- role: converts clean energy routing into precision payoff

### 7. Five-Element Compass

- family tags: `relic`
- function tags: `support`, `control`
- activation tags: `requires_direction`
- spatial tags: `rotatable`
- profession affinity: `cultivator_affinity`
- source: elite reward or boss face-up choice
- role: directional support anchor

### 8. Golden Core Fragment

- family tags: `relic`
- function tags: `burst`, `setup`
- activation tags: `requires_energy`, `on_cycle_end`
- profession affinity: `cultivator_affinity`
- source: boss face-up choice
- role: high-payoff spiritual burst piece

## 5. Mage-leaning items

### 9. Ember Wand

- family tags: `focus`, `spell_tool`
- function tags: `engine`, `burst`
- activation tags: `requires_charge`
- profession affinity: `mage_affinity`
- source: regular reward or shop
- role: simple charge-to-damage spell engine

### 10. Echo Sigil

- family tags: `spell_tool`
- function tags: `support`, `setup`
- activation tags: `requires_adjacent`, `on_support`
- spatial tags: `adjacency_core`
- profession affinity: `mage_affinity`
- source: regular reward or shop
- role: basic spell support amplifier

### 11. Mana Prism

- family tags: `focus`
- function tags: `energy_source`
- activation tags: `start_of_battle`
- profession affinity: `mage_affinity`
- source: regular reward or shop
- role: baseline magical energy source

### 12. Delayed Glyph

- family tags: `spell_tool`
- function tags: `setup`
- activation tags: `requires_charge`, `timed_trigger`
- profession affinity: `mage_affinity`
- source: shop or elite reward
- role: delayed spell burst setup

### 13. Mirror Ward

- family tags: `spell_tool`, `defense`
- function tags: `defense_layer`
- activation tags: `requires_charge`
- profession affinity: `mage_affinity`
- source: regular reward or shop
- role: charge-based magical defense

### 14. Arc Flash Orb

- family tags: `focus`
- function tags: `burst`
- activation tags: `requires_chain`, `timed_trigger`
- profession affinity: `mage_affinity`
- source: elite reward
- role: chain-reward magical burst finisher

### 15. Rune Lattice

- family tags: `relic`
- function tags: `support`, `converter`
- activation tags: `requires_chain`
- spatial tags: `layout_sensitive`
- profession affinity: `mage_affinity`
- source: elite reward or boss face-up choice
- role: converts spell sequencing into broader support value

### 16. Astral Archive Page

- family tags: `relic`
- function tags: `setup`, `economy`
- activation tags: `on_cycle_end`
- profession affinity: `mage_affinity`
- source: boss face-up choice
- role: high-value magical scaling piece

## 6. Artificial-Intelligence-leaning items

### 17. Logic Core

- family tags: `processor`
- function tags: `engine`
- activation tags: `requires_link`
- profession affinity: `ai_affinity`
- source: regular reward or shop
- role: baseline logic-chain engine

### 18. Relay Node

- family tags: `logic_relay`
- function tags: `support`, `energy_link`
- activation tags: `requires_link`, `on_support`
- spatial tags: `line_based`
- profession affinity: `ai_affinity`
- source: regular reward or shop
- role: chain connectivity support

### 19. Micro Battery

- family tags: `processor`, `utility`
- function tags: `energy_source`
- activation tags: `start_of_battle`
- profession affinity: `ai_affinity`
- source: regular reward or shop
- role: baseline synthetic energy provider

### 20. Drone Shell

- family tags: `drone_module`
- function tags: `setup`, `burst`
- activation tags: `requires_link`, `timed_trigger`
- profession affinity: `ai_affinity`
- source: shop or elite reward
- role: delayed drone deployment payoff

### 21. Barrier Grid

- family tags: `logic_relay`, `defense`
- function tags: `defense_layer`
- activation tags: `requires_link`
- spatial tags: `line_based`
- profession affinity: `ai_affinity`
- source: regular reward or shop
- role: chain-based structural defense

### 22. Error Filter

- family tags: `processor`, `utility`
- function tags: `recovery`, `converter`
- activation tags: `on_destroy`, `on_cycle_end`
- profession affinity: `ai_affinity`
- source: elite reward
- role: reduces failure spikes in structured builds

### 23. Optimization Engine

- family tags: `processor`, `relic`
- function tags: `support`, `burst`
- activation tags: `full_logic_chain`, `on_cycle_end`
- profession affinity: `ai_affinity`
- source: elite reward or boss face-up choice
- role: rewards complete logic-chain builds

### 24. Predictive Kernel

- family tags: `relic`
- function tags: `engine`, `control`
- activation tags: `requires_link`, `timed_trigger`
- profession affinity: `ai_affinity`
- source: boss face-up choice
- role: high-identity machine-mind payoff item

## 7. Source distribution guidance

Recommended first-pass distribution:

- regular reward pool: foundational engines, support pieces, baseline energy, simple defense
- shop pool: foundational items, utility, and adaptation tools
- elite reward pool: stronger branching items and specialization tools
- boss face-up pool: memorable high-identity items with clearer build commitment

## 8. Balance control notes

This roster should be checked for:

- enough baseline energy support in every profession lane
- enough defensive options in every profession lane
- at least one simple and one advanced payoff piece per profession lane
- enough cross-profession utility to avoid forced archetypes

## 9. Immediate production implications

The next planning layer should define:

- exact item shapes and sizes
- first text descriptions and tooltips
- initial rarity assignment
- item data sheet format
