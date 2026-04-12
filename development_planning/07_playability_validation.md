# Playability Validation

## 1. Purpose

This document defines how the team should judge whether the game is becoming genuinely playable rather than only conceptually promising.

It exists to answer four production-critical questions:

1. Is space arrangement producing meaningful decisions?
2. Is combat payoff readable and satisfying?
3. Is a full run motivating enough to continue?
4. Are failures teaching adaptation rather than feeling arbitrary?

This file should be used as a validation layer on top of the roadmap, not as a replacement for it.

## 2. Validation philosophy

The project should not be treated as "fun" just because:

- the theme is attractive
- item ideas sound clever on paper
- battles have flashy effects
- testers can describe the premise

The project is only proving itself when players repeatedly:

- change their layout on purpose
- predict at least part of the outcome
- understand why the build worked or failed
- want to immediately try a revised build

## 3. Core playability questions

### A. Space decision test

The construction layer is working only if players regularly face real tradeoffs involving:

- space efficiency
- adjacency value
- directional alignment
- energy routing
- support dependency
- future flexibility versus immediate strength

Validation rule:

- moving one tile should frequently create a meaningful projected difference
- rotating an item should matter often enough to be taught as a core rule
- support items should feel like enablers, not dead tax pieces

Failure signs:

- players place mostly by raw stats
- players stop rearranging after the first acceptable layout
- direction and adjacency are forgotten instead of actively used

### B. Combat readability test

Combat is working only if it clearly reveals build logic.

Players should be able to answer:

- what activated
- what failed to activate
- what the main damage source was
- what the main defensive failure was
- which placement choice mattered most

Validation rule:

- after a win or loss, most testers should be able to name two or three decisive causes without designer explanation

Failure signs:

- players describe outcomes as random
- players cannot trace a strong combo back to placement
- losses feel sudden and unearned

### C. Run motivation test

The run loop is working only if it creates short-term and medium-term reasons to continue.

Players should feel:

- immediate curiosity about the next reward
- pressure to adapt around imperfect choices
- anticipation toward elite or boss checks
- motivation to try a different build idea next run

Validation rule:

- a short complete run should create at least one "I want to try that differently" moment

Failure signs:

- rewards feel flat or interchangeable
- encounter flow feels like filler between build screens
- players do not care what happens after the first few fights

### D. Fair failure test

Failure is acceptable only when it teaches.

Good failure should help the player identify:

- one mistaken placement
- one missing support need
- one greedy reward choice
- one world rule they failed to respect

Validation rule:

- post-loss review should reveal a likely next adjustment within one minute

Failure signs:

- players blame drops alone
- players cannot tell whether the build was close to working
- runs feel doomed too early without recovery options

## 4. Prototype metrics to track

These metrics should be tracked during internal playtests and early external tests.

### Construction metrics

- average number of layout changes per reward step
- percent of items rotated at least once during a run
- percent of placed items that are inactive or poorly supported
- average time spent in construction compared to combat

### Combat metrics

- average combat duration
- top damage source frequency
- failed activation count
- energy starvation frequency
- runs ending from burst damage versus slow collapse

### Run metrics

- average run length
- encounter reach before failure
- reward pick distribution
- reroll usage rate
- boss reach rate

### Learning metrics

- percent of testers who can explain their last loss
- percent of testers who can name a build goal before the next encounter
- percent of testers who ask for "one more run"

## 5. Playtest checklist

Use this checklist after every meaningful prototype round.

### Construction

- Did players rearrange often without being forced?
- Did at least one placement decision create a surprising but understandable outcome?
- Did support pieces feel strategically interesting?

### Combat

- Could players follow the major trigger order?
- Could they identify why a combo succeeded?
- Could they identify why a defense failed?

### Rewards and economy

- Did rewards meaningfully branch strategy?
- Did players ever have to choose between immediate power and future flexibility?
- Did shops or reward screens create adaptation instead of autopicks?

### Motivation

- Did players want to see the next encounter or boss?
- Did they form a build hypothesis for the next run?
- Did the world rule shape decisions instead of sitting in the background?

### Failure and recovery

- Was the last loss understandable?
- Did the run offer at least one recovery opportunity after a weak reward sequence?
- Did players feel ownership over the result?

## 6. Minimum acceptance gates by milestone

### Milestone 1: Core interaction prototype

Must prove:

- placement changes projected value often
- adjacency and direction are understandable
- players voluntarily optimize layouts

Do not advance if:

- construction is only busywork before combat

### Milestone 2: Combat validation prototype

Must prove:

- combat resolves in a readable order
- players can identify their main win or loss causes
- item activations can be inspected clearly

Do not advance if:

- combat feels flashy but causality is unclear

### Milestone 3: Full run loop prototype

Must prove:

- reward choices cause real layout changes
- encounter order creates tension
- a short run produces adaptation motivation

Do not advance if:

- the run feels like disconnected screens

### Milestone 4: First-world vertical slice

Must prove:

- the first world changes how players build
- theme rules create memorable strategic identity
- the world is recognizable in both visuals and mechanics

Do not advance if:

- the world is mostly a cosmetic skin over generic systems

### Milestone 5: Demo candidate

Must prove:

- new players understand the loop in one session
- most players can finish onboarding without outside help
- failures still feel learnable under demo conditions

Do not advance if:

- the game can only be enjoyed after designer explanation

## 7. Immediate planning implications

The planning set should explicitly support these needs:

- combat readability UI must be specified, not implied
- economy and reward branching need stronger definition
- failure review tools need to exist early
- first-world identity must be mechanically sharper than a theme skin
- item pool planning should track strategic roles, not just item count

## 8. Decision rule

When priorities conflict, protect in this order:

1. meaningful construction decisions
2. readable combat causality
3. motivating reward adaptation
4. fair failure and retry desire
5. presentation polish

If polish improves perception but weakens readability, readability wins.
