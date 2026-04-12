# First Profession Passives And Unlock Branch

## 1. Purpose

This document defines the first-pass implementation layer for shipped professions.

The goal is to move from profession identity to profession-ready prototype rules.

Each shipped profession should get:

- one first passive
- one small first unlock branch
- one clear playstyle promise

## 2. Design rules

First-pass profession rules should be:

- easy to understand
- visible in normal play
- directly connected to build decisions
- narrow enough to prototype quickly

Avoid first-pass profession rules that:

- only add flat stats
- require large amounts of unique content
- need too much tutorial explanation
- override the core construction loop

## 3. Cultivator

### Core playstyle promise

The Cultivator should feel like a precise build master who gains more value from correct positioning, direction, and spiritual support.

### First passive: Spiritual Alignment

Rule:

- items with directional or energy-link requirements gain bonus effectiveness when all their required links are satisfied cleanly

Player-facing meaning:

- correct arrangement is rewarded more sharply
- "clean" builds feel stronger than sloppy but functional builds

Why this works:

- reinforces the core project fantasy
- encourages readable layout optimization
- supports xianxia-flavored support logic naturally

### First unlock branch

#### Node 1: Talisman Harmony

Effect:

- talisman-style support items provide slightly more support value when placed adjacent to a valid target

#### Node 2: Spirit Stone Conduction

Effect:

- spirit-stone-type energy providers lose less efficiency across linked activation paths

#### Node 3: Weapon Facing Insight

Effect:

- correctly oriented weapon items gain a clearer payoff bonus

Branch purpose:

- strengthen direction
- strengthen support clarity
- strengthen energy identity

## 4. Mage

### Core playstyle promise

The Mage should feel like a profession that prepares charged magical structure and converts setup into visible burst payoff.

### First passive: Charged Casting

Rule:

- spell-form items gain an additional benefit when activated after at least one supporting magical setup condition has been met

Player-facing meaning:

- the Mage is rewarded for sequencing and preparation
- spell bursts should feel intentional rather than random

Why this works:

- creates a very different fantasy from Cultivator
- supports readable magical combo moments
- gives the player a strong reason to care about order and setup

### First unlock branch

#### Node 1: Quick Sigil

Effect:

- the first magical support item in a battle becomes active more reliably or more quickly

#### Node 2: Stored Charge

Effect:

- charged spell items retain more of their prepared value between setup and payoff moments

#### Node 3: Arcane Echo

Effect:

- one spell-type trigger each battle gains a lighter repeat or echo effect under valid conditions

Branch purpose:

- strengthen magical setup
- strengthen charged payoff
- strengthen spell identity

## 5. Artificial Intelligence

### Core playstyle promise

The Artificial Intelligence profession should feel like building an optimized machine logic where structure, routing, and consistency matter more than raw fantasy flair.

### First passive: Predictive Routine

Rule:

- items that are part of a valid logic or support chain gain improved consistency when their activation dependencies are satisfied in full

Player-facing meaning:

- complete structured systems perform better than loosely assembled builds
- the profession rewards planning, not just stuffing in strong pieces

Why this works:

- fits the game's system-first personality
- creates a distinct non-fantasy identity
- naturally supports readable automation logic

### First unlock branch

#### Node 1: Efficient Processing

Effect:

- support or logic-chain items consume less operational efficiency cost under valid chain conditions

#### Node 2: Redundant Safeguard

Effect:

- once per battle, one failed structured activation can be partially recovered

#### Node 3: Optimization Cycle

Effect:

- builds with stable linked structure gain a small end-of-cycle efficiency bonus

Branch purpose:

- strengthen logic-chain identity
- reduce feel-bad failure spikes
- reward clean automation structure

## 6. Shared implementation rules

To keep first-pass profession content manageable:

- each branch should have only 3 early nodes
- each node should alter one understandable part of the loop
- profession passives should use existing item tags whenever possible
- profession rules should be inspectable in the UI

## 7. Validation questions

These profession passives are working only if:

- players can feel the difference after one or two runs
- each profession changes how items are valued
- each profession changes how players arrange space
- no profession requires extensive explanation to understand its fantasy
- the game still feels like one coherent product instead of three separate games

## 8. Immediate production implications

The next planning layer should define:

- exact item tags needed for profession checks
- UI wording for each passive
- unlock order and cost for each branch node
- first profession-specific tutorial hints
