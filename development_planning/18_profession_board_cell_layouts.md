# Profession Board Cell Layouts

## 1. Purpose

This document defines the exact first-pass marked-cell layouts for profession battle-space variants.

The goal is to make profession boards concrete enough for:

- UI wireframes
- board rendering
- cell highlighting
- rule-state prototyping

## 2. Coordinate convention

Battle space uses:

- `6 columns x 5 rows`
- columns: `1` to `6`
- rows: `1` to `5`
- coordinate format: `(column,row)`

Top-left cell is `(1,1)`.
Bottom-right cell is `(6,5)`.

## 3. Base board

Base board contains no special profession cells.

All cells are standard cells until DNA-based profession activation changes the board state.

## 4. Cultivator board layout

### Variant identity

- `Formation Board`

### Marked cells

- formation heart: `(3,3)` and `(4,3)`
- upper formation cells: `(3,2)` and `(4,2)`
- lower formation cells: `(3,4)` and `(4,4)`

### Layout logic

This creates:

- a centered formation band
- a strong mid-board identity
- natural support for elegant symmetric or near-symmetric layouts

### Intended use

- formation-adjacent structure should support directional items
- support pieces placed around the central band should feel especially meaningful

### UI note

- heart cells should be visually distinct from the surrounding formation cells
- the board should read as a controlled formation, not a mandatory rigid template

## 5. Mage board layout

### Variant identity

- `Arcane Casting Board`

### Marked cells

- left casting lane: `(2,1)`, `(2,2)`, `(2,3)`, `(2,4)`, `(2,5)`
- right casting lane: `(5,1)`, `(5,2)`, `(5,3)`, `(5,4)`, `(5,5)`
- arcane anchor cells: `(3,3)` and `(4,3)`

### Layout logic

This creates:

- two readable vertical casting channels
- a central anchor pair for major spell setup or magical convergence

### Intended use

- spells should feel like they are routed through casting structure
- the center anchors should reward planned magical payoff

### UI note

- casting lanes should be visually lighter than walls or restrictions
- the board should suggest magical flow, not trap the player into only one pattern

## 6. Artificial Intelligence board layout

### Variant identity

- `Processing Grid`

### Marked cells

- left processing lane: `(2,2)`, `(2,3)`, `(2,4)`
- right processing lane: `(5,2)`, `(5,3)`, `(5,4)`
- upper bridge cells: `(3,2)` and `(4,2)`
- lower bridge cells: `(3,4)` and `(4,4)`
- central processing zone: `(3,3)` and `(4,3)`

### Layout logic

This creates:

- two side lanes
- a structured central processing zone
- visible bridge logic between outer and central cells

### Intended use

- logic-chain items should feel cleaner when routed through the marked structure
- the board should communicate computational order

### UI note

- bridge cells should help explain connectivity
- the board should feel structured without becoming visually noisy

## 7. First-pass control rule

Marked cells should be treated as:

- incentive cells
- identity cells
- explanation cells

They should not be treated as:

- hard restrictions in most cases
- mandatory placement cells for every build
- large raw stat multipliers

## 8. Shared implementation guidance

Recommended first-pass board rendering:

- standard cells use one neutral style
- marked profession cells use a profession-themed overlay
- the strongest identity cells use a slightly stronger border or glow

This helps preserve readability while still making each board feel distinct.

## 9. Validation questions

These layouts are working only if:

- players can spot the profession pattern in a glance
- item placement choices change because of marked-cell incentives
- the center of the board matters in different ways for different professions
- the board still feels open enough for experimentation

## 10. Immediate production implications

The next planning layer should define:

- what each marked-cell type actually does
- board overlay visual language
- hover and tooltip behavior for marked cells
