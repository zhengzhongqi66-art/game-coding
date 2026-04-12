# Battle Space And Storage Space Specification

## 1. Purpose

This document defines the first-version rules for the player's two main item spaces:

- battle space
- storage space

The goal is to make space management concrete enough for:

- UI implementation
- item placement rules
- profession interaction
- reward and adaptation flow

## 2. Core two-space rule

The player owns two different spaces with different meanings.

### Battle space

Battle space is the active space.

Only items placed in battle space:

- contribute to combat
- provide active support
- generate combat-facing energy or logic payoff

### Storage space

Storage space is the reserve space.

Items placed in storage space:

- do not directly affect combat
- are preserved for future adjustment
- support build adaptation between fights

The player should always understand which items are active and which are only being held.

## 3. First-version size recommendation

### Battle space

Recommended starting size:

- `6 columns x 5 rows`
- total: `30 cells`

Reason:

- large enough to support identity builds
- small enough to force real tradeoffs
- compatible with the first roster's mix of 1x1, 1x2, 2x1, 2x2, L3, and line3 items

### Storage space

Recommended starting size:

- `4 columns x 4 rows`
- total: `16 cells`

Reason:

- enough room for adaptation pieces
- not enough room to hoard everything
- encourages choosing what to keep for future pivots

## 4. Placement rules

### Battle space placement

Rules:

- items cannot overlap
- items must fit fully within the active grid
- rotated items must still fit legally
- invalid placements should preview clearly before release

### Storage space placement

Rules:

- items also obey footprint rules in storage
- storage is spatial, not a hidden list
- players should feel that keeping items has a real space cost

This is important because storage is part of strategy, not just inventory overflow.

## 5. Space interaction rules

Players should be able to:

- drag items from battle space to storage space
- drag items from storage space to battle space
- rotate items before placement when allowed
- reorganize both spaces during preparation phases

Players should not be allowed to:

- gain active benefits from storage-only placement
- bypass footprint rules by sending items into abstract storage slots

## 6. When reorganization is allowed

### Before combat

Players may:

- fully reorganize battle space
- move items between battle and storage
- purchase and place new items
- remove items from active use

### After combat

Players may:

- make limited but meaningful adjustments
- re-equip from storage
- reorganize space in response to rewards

Design rule:

- the player should feel adaptable after each fight
- the system should avoid exhausting full rebuild friction every single time

## 7. Limited post-combat adjustment rule

Recommended first-version approach:

- after each battle, players may freely reorganize within the preparation phase
- however, UI flow should frame this as a short adjustment window, not a giant management mode

This creates a balance:

- adaptation remains satisfying
- pacing stays readable

## 8. Expansion rules

The first version should treat space expansion carefully.

Recommended rule:

- battle space expansion should be rare and meaningful
- storage space expansion can be slightly more common
- early progression should not trivialize space pressure

Reason:

- space pressure is core to the game's identity
- too much expansion weakens arrangement decisions

## 9. DNA-driven profession space variation

After the player unlocks profession abilities through DNA:

- the battle space is allowed to change according to profession identity
- this change should be visible and mechanically relevant
- the change should not fully remove the core space-pressure rule

Recommended first-version interpretation:

- profession changes should alter battle-space shape, special cells, or structural bias
- profession changes should create different arrangement incentives
- profession changes should be easier to read than raw hidden bonuses

Examples of acceptable first-version variation:

- Cultivator: battle space gains a more ring-like or formation-like identity
- Mage: battle space gains clearer casting lanes or arcane anchor cells
- Artificial Intelligence: battle space gains structured logic lanes or processing zones

Control rule:

- profession space variation should be meaningful but not so extreme that each profession becomes a completely separate board game

## 10. Profession interaction guidelines

Professions may affect space, but only in controlled ways.

Good first-version profession interactions:

- improving value of specific placements
- improving use of certain item shapes
- granting limited storage efficiency or structured support bonuses

Avoid early profession interactions that:

- massively expand board size
- remove spatial constraints entirely
- make one profession obviously superior because of raw capacity

## 11. UX requirements

The UI should clearly show:

- battle space boundary
- storage space boundary
- active versus stored status
- invalid placement state
- placement preview
- rotation state where relevant

The UI should also make it obvious when the player is:

- still preparing
- entering combat
- reviewing post-combat rewards

The UI should also make profession-space changes obvious through:

- board frame changes
- profession markers
- special cell highlighting if used
- before-and-after comparison at first unlock

## 12. Validation questions

This specification is working only if:

- players understand the difference between battle and storage without explanation
- space pressure remains real in both zones
- storage supports adaptation instead of pure hoarding
- battle space feels large enough for creativity but small enough for tradeoffs
- item shapes create interesting friction without becoming tedious
- profession-based board changes feel exciting without becoming confusing

## 13. Immediate production implications

The next planning layer should define:

- exact drag-and-drop interaction flow
- placement highlight rules
- storage expansion sources
- battle-space expansion sources
- first UI wireframe for the dual-space screen
- profession-specific battle-space variants
