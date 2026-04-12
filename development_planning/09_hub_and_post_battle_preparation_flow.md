# Hub And Preparation Flow

## 1. Purpose

This document defines the player-facing preparation structure around each combat.

The project should treat preparation as a major gameplay layer, not as a thin menu wrapper.

## 2. Core preparation loop

Before combat, the player should always understand three major branches of action:

1. enter the shop
2. enter the world or dungeon
3. organize space

This means the preparation phase is not only about buying power.
It is also about committing to layout, route, and readiness.

## 3. Two-space model

The player should own two clearly separated spaces:

### A. Battle space

This is the active construction space used for combat validation.

It should contain:

- currently equipped build pieces
- active engines
- active supports
- active defensive structure

Only items in battle space should affect combat.

### B. Storage space

This is a reserve space for items that are not currently active.

It should contain:

- temporarily unused items
- backup pieces
- future pivot pieces
- situational items worth holding

Storage space exists to support adaptation without forcing immediate discard.

## 4. Pre-combat preparation actions

The player should be able to do the following before entering a fight:

- buy from the shop
- refresh shop inventory
- move items between battle space and storage space
- rearrange active battle space
- inspect current world or route information
- commit to entering the selected world or encounter

The preparation phase should always make the player feel:

- "I have one more chance to improve this build."
- "I must decide what is active now."
- "What I keep in storage may matter later."

## 5. Post-combat mini-adjustment rule

After every combat, the player should be allowed to make small space adjustments.

Recommended rule:

- the player can reorganize items between battle space and storage space
- the player can slightly rebuild the active layout
- the player should not feel locked into the exact same arrangement after each fight

Design purpose:

- preserve adaptation as a constant pleasure
- reduce frustration from near-miss losses
- let rewards immediately create layout consequences

## 6. Map shops

In addition to the standard post-battle preparation shop flow, the game may include map shops at selected nodes.

Map shop purpose:

- provide stronger pivot opportunities
- create route-planning value
- justify saving Essence for future decisions

Design rule:

- map shops should feel special, not redundant
- they should offer either better inventory, special services, or better strategic timing than the regular shop access

## 7. Main-god space and profession unlocks

The main-god space acts as the long-term framing hub.

Once the player purchases a profession skill for the first time:

- the player's backpack presentation should change according to the chosen profession
- the active carry container should gain profession identity
- the battle space should begin to change according to profession identity
- profession-specific features can begin to appear

This should make profession choice feel visible, not only numerical.

## 8. Profession-dependent bag identity

The game should treat the player's carry container as part of fantasy and system identity.

Example:

- a xianxia-style profession may use a `spatial ring` instead of a generic backpack

This allows the project to connect:

- build space theme
- profession fantasy
- UI presentation
- battle-space identity
- future profession-specific mechanics

## 9. Profession-specific features

Profession choice should eventually affect more than visuals.

Recommended profession-specific outputs:

- bag presentation or container shape
- one profession-specific rule twist
- one profession-specific shop bias or item affinity
- one profession-specific long-term skill branch

Do not overload the first version.
The minimum requirement is that the profession is visible in both presentation and one meaningful rule layer.

## 10. UX requirements

The preparation flow UI should clearly separate:

- battle space
- storage space
- shop access
- world entry
- profession or long-term progression context

Players should never ask:

- which items are active right now
- whether storage items affect battle
- whether they are still in preparation or already committed to combat

## 11. Validation questions

This flow is working only if:

- players understand the three pre-combat branches without explanation
- battle space and storage space are not confused
- post-combat rebuilding feels useful and not tedious
- map shops create route value
- profession choice feels visible after first unlock

## 12. Immediate production implications

The planning set should later include:

- battle space capacity rules
- storage space capacity rules
- rules for moving items between spaces
- map node taxonomy including shop nodes
- profession-specific bag presentation spec
- profession-specific feature table
