# Profession Special Cell Effects

## 1. Purpose

This document defines the first-version gameplay effects of profession-specific marked cells.

The goal is to make profession boards:

- mechanically meaningful
- easy to teach
- easy to read in combat and preparation
- controlled enough for a small-team prototype

## 2. Shared design rules

Profession special cells should:

- reward certain arrangements
- improve board identity
- increase decision quality

Profession special cells should not:

- replace item logic
- grant huge raw stat spikes
- create one mandatory solved layout
- make normal cells irrelevant

## 3. Effect language rule

Special-cell effects should use these first-version effect patterns:

- activation clarity bonus
- support efficiency bonus
- charge or setup efficiency bonus
- chain consistency bonus

Avoid first-version effects that:

- rewrite item behavior completely
- trigger many extra edge cases
- require hidden calculations that players cannot read

## 4. Cultivator cell effects

### Cell types

- formation heart cells
- formation cells

### Formation heart effect

Recommended effect:

- when a Cultivator-affinity item is placed on or directly adjacent to a formation heart cell, and its directional or energy requirement is fully satisfied, it gains `clean_alignment`

Gameplay meaning:

- the board rewards elegant, completed setups
- the reward is conditional, not automatic

### Formation cell effect

Recommended effect:

- support items on formation cells provide slightly improved support efficiency to valid adjacent targets

Gameplay meaning:

- support placement around the center becomes more meaningful
- players are encouraged to think in terms of formation structure

### UI explanation

Suggested short wording:

- Formation Heart: "Completed aligned setups resonate here."
- Formation Cell: "Support placed here strengthens valid nearby structure."

## 5. Mage cell effects

### Cell types

- casting lanes
- arcane anchor cells

### Casting lane effect

Recommended effect:

- spell-form or charged items placed on a casting lane gain improved setup clarity and easier qualification for `spell_sequence_ready`

Gameplay meaning:

- lanes help players structure magical flow
- the effect supports sequence planning instead of only raw damage

### Arcane anchor effect

Recommended effect:

- setup or charged items placed on an arcane anchor retain or convert prepared value more efficiently

Gameplay meaning:

- anchor cells become focal points for planned magical payoff
- the board encourages concentrated spell preparation

### UI explanation

Suggested short wording:

- Casting Lane: "Spell structure is easier to sustain here."
- Arcane Anchor: "Prepared magic holds together more efficiently here."

## 6. Artificial Intelligence cell effects

### Cell types

- processing lanes
- bridge cells
- central processing zone

### Processing lane effect

Recommended effect:

- linked AI-affinity items placed along a processing lane gain improved consistency toward `full_logic_chain`

Gameplay meaning:

- orderly routing is rewarded
- side-lane structure matters without being mandatory

### Bridge cell effect

Recommended effect:

- bridge cells improve valid connection transfer between side lanes and the central zone

Gameplay meaning:

- the board helps explain how logic routing works
- connectivity becomes a readable planning layer

### Central processing zone effect

Recommended effect:

- items in the central processing zone gain a `stable_cycle` bonus if their inbound support or link requirements are fully met

Gameplay meaning:

- complete systems are rewarded with smoother operation
- the center becomes a clear payoff region for machine logic

### UI explanation

Suggested short wording:

- Processing Lane: "Structured routing is more stable here."
- Bridge Cell: "Connections transfer more cleanly through this cell."
- Processing Zone: "Complete logic systems gain stability here."

## 7. Numerical control rule

First-version effects should stay modest.

Recommended principle:

- special cells should improve reliability, efficiency, or clarity first
- only later should they become larger numerical multipliers if needed

Reason:

- reliability and readability create better learning than hidden damage inflation

## 8. Interaction rule with non-matching professions

Special cells should still exist on the board even when a build uses mixed items.

Recommended rule:

- profession cells favor matching profession logic
- non-matching items may still be placed there legally
- non-matching items should usually receive little or no special benefit

This preserves freedom while keeping profession identity meaningful.

## 9. Validation questions

These effects are working only if:

- players can understand what each marked cell helps with
- profession boards change how players arrange items
- players can feel the benefit without reading large rule text
- special cells support identity without creating mandatory board patterns

## 10. Immediate production implications

The next planning layer should define:

- concrete tooltip text for each special cell
- board-state icons for `clean_alignment`, `spell_sequence_ready`, `full_logic_chain`, and `stable_cycle`
- whether special-cell effects are passive-only or also highlighted in combat logs
