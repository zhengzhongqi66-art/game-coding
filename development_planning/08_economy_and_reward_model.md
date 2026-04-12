# Economy And Reward Model

## 1. Purpose

This document defines how rewards, shops, rerolls, and run economy should support the core play pattern:

- build in limited space
- validate in combat
- adapt under constraints
- push one more node

The economy should not exist only to inflate numbers.
It should create meaningful adaptation pressure.

## 2. Economy design goals

The reward model should consistently create these feelings:

- "I have options, but not enough room for everything."
- "This reward is strong, but it may force a rebuild."
- "I can stabilize now or gamble for a stronger engine."
- "This run is becoming its own build story."

If rewards only increase power without changing structure, the system is underperforming.

## 3. Core economic layers

### A. Run currency

Use one primary run currency in the first production version: `Essence`.

Definition:

- Essence is a cross-world universal currency
- it represents extractable power value rather than world-specific money
- it can be spent both during a run and in the hub layer

This currency should be used for:

- shop purchases
- rerolls
- selected event choices
- optional repair or recovery actions if added
- hub-side exchange for long-term capability options where appropriate

Reason:

- easier readability for early players
- lower balancing complexity
- cleaner risk-reward tradeoffs

Do not add multiple run currencies in the first vertical slice unless the first system clearly fails.

### B. Experience

Experience should exist as a separate progression signal during runs.

Purpose:

- support run pacing and growth feedback
- provide a stable reward even when item rewards are skipped
- create room for level-based or threshold-based power pacing if later needed

Recommended rule:

- experience is earned mainly from combat resolution
- experience should not replace build decisions
- experience should amplify the run arc, not dominate it

### C. Reward objects

Rewards should come in a small number of readable categories:

- experience
- Essence
- chest reward
- named item choice, often presented as pick one of three
- new item choice
- upgrade or refine action
- utility action such as remove, rotate assist, or expand option later
- world-specific reward

Recommended interpretation:

- experience is the baseline growth reward
- Essence is the main flexible economy reward
- chests are higher-variance reward containers
- named item choice is the clearest strategy-branching reward

The player should usually choose between categories, not just receive one flat payout.

### D. Meta progression

Meta progression must stay separate from run economy.

Use early meta only for:

- unlocking item families
- unlocking world variants
- unlocking shop possibilities
- unlocking challenge modifiers

Avoid:

- permanent stat inflation
- meta systems that solve weak run design

## 4. Reward pacing across a run

### Early run

The early run should prioritize:

- identity formation
- basic support acquisition
- first engine discovery

Recommended early reward behavior:

- more item choices than pure currency
- low punishment for first reroll
- high clarity over high randomness

### Mid run

The mid run should prioritize:

- structural adaptation
- counter-build responses
- synergy deepening

Recommended mid-run reward behavior:

- stronger branching rewards
- more expensive rerolls
- more world-biased rewards
- more pressure to replace or remove weak pieces

### Late run

The late run should prioritize:

- commitment payoff
- boss preparation
- limited recovery windows

Recommended late-run reward behavior:

- fewer generic rewards
- higher value but riskier choices
- boss-oriented adaptation opportunities

## 5. Reward source design

### A. Regular encounters

Regular encounters should mostly provide:

- Essence
- experience
- low chance to obtain one held enemy item

Recommended reward feel:

- reliable progression
- low-complexity adaptation
- occasional surprise through enemy item capture

Purpose:

- keep the run moving
- encourage incremental build shaping

### B. Elite encounters

Elite encounters should provide:

- more Essence
- more experience
- medium chance to obtain one held enemy item
- stronger branching reward pressure than regular fights

Purpose:

- create deliberate tension
- reward risk-taking with real build direction shifts

### C. Boss encounters

Boss rewards should provide:

- the standard boss-tier Essence and experience payout
- one face-up named item choice from three options

Recommended presentation:

- all three options are visible
- the player is making a conscious strategic commitment
- the reward should feel more authored and memorable than a normal chest reward

Current note:

- profession-skill unlock materials and exchange rules should be defined separately from the boss reward baseline
- do not automatically tie boss reward payout to DNA Fragment drops unless later approved

Boss rewards should not feel like just a larger common chest.

### D. Events

Events should test judgment rather than raw combat strength.

Good event rewards include:

- trade HP for economy
- destroy one item to gain a specialized reward
- duplicate a narrow item type with a drawback
- lock in a world modifier for greater payout

## 6. Shop design

### First-version shop rule

The first shop should stay small and understandable.

Recommended first-version structure:

- 4 to 6 offer slots
- 1 reroll button
- 1 optional remove or refine service
- clear world-biased slot if needed

Availability rule:

- the shop can be entered during the preparation phase after every battle
- the player should consistently know that post-battle preparation includes shop access
- shop frequency is high, but purchasing power is still constrained by Essence income
- selected map nodes may also contain enhanced shop access

### Shop design goals

The shop should help answer:

- can the player stabilize?
- can the player pivot?
- can the player greed for a stronger engine?

If the shop only sells generic upgrades, it is not doing enough strategic work.

## 7. Reroll model

Reroll should be a meaningful economic decision, not a reflex.

Recommended first-version model:

- first reroll in a shop is cheap
- repeated rerolls scale up within the same visit
- scale resets at the next shop
- all rerolls are paid with Essence

Why:

- allows recovery from a bad shop
- discourages endless fishing
- creates visible tension between consistency and greed

Failure signs:

- players reroll almost every time
- players never reroll because the price is obviously wrong
- rerolling is stronger than learning how to adapt

## 8. Build adaptation tools

The reward economy should provide limited ways to reshape a run.

Recommended first-version adaptation tools:

- remove one item
- upgrade one item
- convert one reward choice into currency
- one conditional repair option after heavy damage if needed

These tools matter because the game is about rebuilding intelligently, not just adding more pieces.

## 9. Strategic role distribution in the item pool

The reward system should track strategic roles, not only item count.

Recommended role buckets for the first item pool:

- engine pieces
- energy pieces
- support pieces
- conversion pieces
- defense pieces
- economy or utility pieces
- risky payoff pieces

Validation rule:

- a successful run should usually contain more than one role category
- rewards should not overproduce only payoff pieces

## 10. Recovery and anti-doom rules

The run should not feel doomed too early unless the player made repeated bad decisions.

Recommended anti-doom rules:

- at least one mid-run chance to clean up a weak layout
- at least one reliable source of baseline support tools
- avoid reward pools that can completely deny basic engine formation

This does not mean making every run easy.
It means protecting the feeling that adaptation remains possible.

## 11. First prototype numbers to tune

The team should explicitly tune:

- average Essence earned per encounter
- average experience earned per encounter
- average item choices seen before boss
- reroll cost curve
- remove or refine service price
- rare reward appearance rate
- world-biased reward rate
- enemy-item capture rate by encounter tier
- face-up named-item quality and appearance pacing

These should be reviewed together, not one by one.

## 12. Validation questions

The economy is working only if the team can answer yes to most of these:

- Do rewards regularly force real layout decisions?
- Do players ever skip strong-looking rewards because of structural cost?
- Do shops create pivot moments instead of filler pauses?
- Does reroll feel useful but not mandatory?
- Can players describe why they spent or saved Essence?
- Do losses sometimes trace back to economic choices, not just combat numbers?
- Does the boss face-up item choice create a memorable strategic commitment?

## 13. Immediate production implications

The planning set should eventually include:

- reward table structure
- shop inventory logic
- reroll cost scaling table
- item role tags for balance tracking
- economy telemetry definitions
- profession-skill unlock resource design
- post-battle preparation flow specification

If these stay vague for too long, build variety will become hard to tune.
