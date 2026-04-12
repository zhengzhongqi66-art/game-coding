# Profession Battle Space Variants

## 1. Purpose

This document defines the first-version battle-space variants that appear after profession abilities are unlocked through DNA.

The goal is to make profession identity visible inside the board itself while preserving one coherent core game.

## 2. Shared design rule

All profession battle spaces should share the same baseline principles:

- same core board size expectation
- same item footprint logic
- same drag-and-drop rules
- same active-versus-storage separation

Profession variants should change:

- board emphasis
- highlighted structural zones
- profession-specific incentives

Profession variants should not change:

- the entire game genre
- the meaning of item shapes
- the basic readability of the board

## 3. Base board reference

Base battle space before profession variation:

- `6 x 5`
- 30 total cells
- no profession-specific special cells

After DNA-based profession activation, this base board gains profession identity through marked zones and structural bias.

## 4. Cultivator variant

### Variant name

- `Formation Board`

### Visual identity

- ring-like frame treatment
- formation-line accents
- central anchor impression

### Board logic

- keep the same total cell count
- mark 4 formation-adjacent cells around a central formation heart area
- directionally aligned items gain clearer synergy when interacting with formation-marked structure

### Intended gameplay effect

- rewards precise positioning
- rewards elegant support structures
- makes the board feel like a cultivated formation, not just a backpack grid

### Special-cell rule

- formation cells do not grant raw power by default
- they improve the clarity or efficiency of valid Cultivator-style setups

### Risk control

- the formation pattern must remain readable at a glance
- it should enhance clean arrangement, not force one rigid solved layout

## 5. Mage variant

### Variant name

- `Arcane Casting Board`

### Visual identity

- arcane lane markings
- glowing anchor cells
- rune-circuit highlights

### Board logic

- keep the same total cell count
- mark 2 to 3 casting lanes
- mark 2 arcane anchor cells
- spell-form and charged items naturally interact better with these lanes or anchors

### Intended gameplay effect

- rewards planned spell sequencing
- rewards burst preparation
- makes the board feel like a casting structure rather than a generic container

### Special-cell rule

- anchor cells should support setup identity
- lanes should help players read magical direction or sequencing logic
- not every Mage build should require every lane

### Risk control

- avoid making the board too linear
- the Mage board should encourage setup variety, not one mandatory casting path

## 6. Artificial Intelligence variant

### Variant name

- `Processing Grid`

### Visual identity

- segmented lanes
- logic-channel borders
- processing-zone highlights

### Board logic

- keep the same total cell count
- mark linked processing lanes
- mark 1 to 2 efficiency zones
- linked AI items gain better consistency when routed through coherent logic structure

### Intended gameplay effect

- rewards clean routing
- rewards system consistency
- makes the board feel computational and optimized

### Special-cell rule

- processing zones should reward stable structure
- lane identity should help players understand logic-chain layouts
- the board should communicate machine order, not raw size advantage

### Risk control

- avoid making the board look too technical to parse
- the variant should help readability, not bury it in abstraction

## 7. Implementation style recommendation

Recommended first-version method:

- use highlighted cell groups rather than radically different board geometry
- keep the outer board rectangle consistent
- apply profession identity through cell roles, frame treatment, and overlay markings

Reason:

- cheaper to implement
- easier to teach
- easier to compare across professions

## 8. Unlock presentation

When the player unlocks a profession battle-space variant:

- show a before-and-after board comparison
- highlight newly changed zones
- explain the new board identity in one short sentence

Examples:

- Cultivator: "Your battle space now resonates like a formation."
- Mage: "Your battle space now channels arcane casting lanes."
- Artificial Intelligence: "Your battle space now routes through structured processing zones."

## 9. Validation questions

These board variants are working only if:

- players can identify the profession board change immediately
- the board change affects real arrangement decisions
- the same item can be valued differently on different profession boards
- players do not need long explanation to use the new board
- all three variants still feel like one game's board system

## 10. Immediate production implications

The next planning layer should define:

- exact marked-cell positions for each profession
- cell-state UI style
- profession-board tutorial popups
- whether profession boards unlock instantly or progressively
