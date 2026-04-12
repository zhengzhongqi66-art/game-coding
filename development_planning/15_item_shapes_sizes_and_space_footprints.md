# Item Shapes, Sizes, And Space Footprints

## 1. Purpose

This document defines the first-pass shape and footprint rules for the first item roster.

The goal is to make space-construction decisions concrete enough for:

- UI wireframes
- drag-and-drop implementation
- placement validation
- balance testing

## 2. Shape system rules

The first version should keep the shape language readable and limited.

Recommended first-version footprint types:

- `1x1`
- `1x2`
- `2x1`
- `2x2`
- `L3`
- `line3`

Rule:

- avoid overly irregular shapes in the first prototype
- most items should use simple rectangles
- special shapes should be reserved for high-identity items

## 3. Rotation rules

Recommended first-version rotation policy:

- `1x1` items do not rotate
- `1x2` and `2x1` items rotate
- `2x2` items do not need rotation unless direction matters
- `L3` and `line3` items may rotate if their identity depends on direction

Design rule:

- rotation should matter often enough to be interesting
- rotation should not be added to items that gain nothing from it

## 4. Space role guidelines

The roster should use shape to communicate role.

Recommended logic:

- compact items often serve as utility, support, or baseline energy
- medium items often serve as core engines or defenses
- larger or irregular items often signal high identity, setup cost, or high payoff

This helps players read space commitment before reading every tooltip.

## 5. Cultivator item footprints

### Azure Edge

- footprint: `1x2`
- rotation: yes
- reason: directional weapon should visibly care about facing

### Spirit Talisman Strip

- footprint: `1x1`
- rotation: no
- reason: simple support piece should be easy to slot

### Lesser Spirit Stone

- footprint: `1x1`
- rotation: no
- reason: baseline energy source should be compact

### Copper Furnace

- footprint: `2x2`
- rotation: no
- reason: furnace should feel like a major space commitment

### Jade Guard Seal

- footprint: `1x1`
- rotation: no
- reason: defensive support should be flexible to place

### Meridian Needle

- footprint: `1x2`
- rotation: yes
- reason: line precision should matter

### Five-Element Compass

- footprint: `2x2`
- rotation: yes
- reason: high-identity directional relic should anchor layouts

### Golden Core Fragment

- footprint: `L3`
- rotation: yes
- reason: high-payoff relic should have memorable shape pressure

## 6. Mage item footprints

### Ember Wand

- footprint: `1x2`
- rotation: yes
- reason: the wand should preserve direction and casting identity

### Echo Sigil

- footprint: `1x1`
- rotation: no
- reason: support sigils should be easy to combine

### Mana Prism

- footprint: `1x1`
- rotation: no
- reason: baseline magical power source should stay compact

### Delayed Glyph

- footprint: `2x1`
- rotation: yes
- reason: setup glyph should feel placement-sensitive

### Mirror Ward

- footprint: `1x1`
- rotation: no
- reason: defense needs flexible slotting

### Arc Flash Orb

- footprint: `1x2`
- rotation: yes
- reason: burst finisher should reward line planning

### Rune Lattice

- footprint: `2x2`
- rotation: no
- reason: magical structure piece should occupy meaningful board area

### Astral Archive Page

- footprint: `L3`
- rotation: yes
- reason: high-value magical relic should pressure board planning

## 7. Artificial-Intelligence item footprints

### Logic Core

- footprint: `2x1`
- rotation: yes
- reason: foundational processor should define structured lanes

### Relay Node

- footprint: `1x2`
- rotation: yes
- reason: relay behavior should visually align with linking

### Micro Battery

- footprint: `1x1`
- rotation: no
- reason: baseline energy module should stay simple

### Drone Shell

- footprint: `2x1`
- rotation: yes
- reason: deployment module should create directional setup decisions

### Barrier Grid

- footprint: `2x2`
- rotation: no
- reason: structural defense should claim real space

### Error Filter

- footprint: `1x1`
- rotation: no
- reason: recovery utility should be easy to fit

### Optimization Engine

- footprint: `line3`
- rotation: yes
- reason: logic-chain payoff should visibly reward clean routing lines

### Predictive Kernel

- footprint: `L3`
- rotation: yes
- reason: high-identity AI relic should shape the board around itself

## 8. Global balance checks

The first footprint pass should be reviewed for:

- enough compact support pieces to keep builds flexible
- enough medium pieces to create real tradeoffs
- enough large pieces to force commitment without overcrowding the whole board
- profession lanes not all using the exact same spatial logic

## 9. Immediate production implications

The next planning layer should define:

- initial battle-space size
- initial storage-space size
- placement preview rules
- invalid placement feedback states
