# Game System Modules

## 1. System overview

The project should be built as a set of cleanly separated production modules.

## 2. Core runtime modules

### A. Run Flow Controller

Responsible for:

- entering a new run
- hub return flow
- world selection
- node progression
- boss transition
- run end states

Key requirement:

- every run state must be resumable and debuggable

### B. Space Construction System

This is the center of the game.

Responsibilities:

- grid or slot layout
- item placement and rotation
- size and occupancy checks
- adjacency detection
- directional influence
- support and energy routing
- quick compare between old and new layouts

Must support:

- drag and drop
- rotate item
- highlight valid cells
- preview synergy changes
- preview blocked or broken links

### C. Item System

Each item should be defined through reusable behavior parts.

Suggested item behavior dimensions:

- size
- tags
- rarity
- world origin
- trigger timing
- adjacency needs
- direction rules
- energy behavior
- scaling rules
- special conditions

Suggested first item families:

- weapons
- talismans
- furnaces
- spirit stones
- relics
- defensive pieces
- utility converters

### D. Energy and Link System

Needed because the planning documents emphasize support pieces and activation logic.

Responsibilities:

- energy generation
- energy transfer
- channel or line logic
- activation requirements
- overload or conflict rules
- visual explanation of active routes

This system is one of the strongest candidates for project identity.

### E. Combat Resolution System

Responsibilities:

- build loading into battle
- enemy formation loading
- timed action scheduling
- status effect application
- summons and spawned entities if used
- damage, shield, heal, and trigger resolution
- readable win or loss conclusion

Combat design rule:

- the simulation should be easy to inspect even if the visuals are flashy

### F. Reward and Economy System

Responsibilities:

- post-battle reward generation
- shop inventory
- reroll logic
- cost scaling
- world reward biasing
- risk versus reward branch offers

Economy design rule:

- rewards should reinforce adaptation, not only raw number growth

### G. World Theme Module

Each world should be authored as a compact package.

Per-world content bundle:

- visual theme
- enemy pool
- node event pool
- one stage rule
- reward family
- elite modifier set
- boss identity

This supports the "sampling" approach without exploding scope.

### H. Hub System

Responsibilities:

- player preparation space
- vendors or unlock nodes
- progression choices
- route selection
- lightweight narrative framing
- mirror opponent or challenge board later if needed

The hub should be efficient and readable, not a large exploration area.

### I. Meta Progression System

Must stay light in the first production version.

Recommended early uses:

- unlock new items
- unlock new world modifiers
- unlock new shop options
- unlock challenge routes

Avoid:

- large stat inflation
- progression that invalidates skillful arrangement

### J. Opponent and Encounter System

Responsibilities:

- enemy build logic or encounter scripting
- elite behaviors
- boss phases
- mirror or asynchronous encounters later

In early development, use authored encounters before trying complex procedural opponents.

## 3. UX and support modules

### A. Inspection and Readability Layer

Must answer:

- what is active
- why it is active
- what supports it
- what broke
- what triggered first

Minimum first-playable outputs:

- active item highlighting
- energy route visualization
- trigger order event feed
- failure reason summary after combat
- quick compare between current layout and previous layout

Without this, the game will feel random.

### B. Tutorial and Onboarding Layer

Need lightweight onboarding for:

- drag and rotate
- adjacency
- direction
- support activation
- world rule modifiers

### C. Telemetry and Debug Layer

Need internal tools for:

- seed capture
- item appearance rates
- encounter win rate
- item usage rate
- failed activation reasons
- post-loss cause tagging
- layout change frequency tracking

## 4. Recommended first-world module package

### First world: Xianxia trial realm

Reason:

- strongest current visual and mechanical bridge from the existing design work
- naturally supports energy, direction, and elemental logic

Recommended first-world mechanics:

- five-element relationships in placement rules
- weapon orientation bonuses
- support stones as energy sources
- talisman chain bonuses
- furnace or cauldron surround bonuses

Recommended first-world art package:

- floating gate
- formation lines
- spirit flames
- talisman paper
- stone, jade, bronze, and ink motifs

## 5. Content scale for first meaningful prototype

Recommended target:

- 1 hub
- 1 world
- 1 boss
- 20 to 30 items
- 8 to 12 regular encounters
- 3 to 5 event nodes
- 2 to 3 elite encounters
- 1 light permanent progression layer

That is enough to validate the game without overbuilding.
