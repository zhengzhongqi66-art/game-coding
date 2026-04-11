# Technical Stack

## 1. Engine recommendation

### Recommended engine: Godot 4.x

Reasoning:

- best fit for a small team and fast prototyping
- strong 2D workflow
- good scene-based composition for UI-heavy and system-heavy games
- fast iteration for grid logic, combat visualization, and tool scripts
- lower project overhead than Unity for this scope
- easier long-term ownership for a small indie team

### Why Godot fits this project specifically

The project depends on:

- grid-based arrangement logic
- data-heavy item definitions
- UI-heavy build interaction
- deterministic combat simulation
- quick content iteration

These are all areas where Godot is efficient.

### When Unity would be justified instead

Switch only if the team later decides to prioritize:

- advanced third-party live ops tooling
- a much larger hiring pipeline based on Unity experience
- heavy middleware dependence

For the current scope, that would be overkill.

## 2. Programming language

### Recommended: GDScript for gameplay and tools

Use GDScript for:

- gameplay logic
- item logic orchestration
- combat sequencing
- UI flow
- content tools

Reasoning:

- fastest iteration for a small team
- easiest scripting for design-heavy systems
- lower friction when building editor tools and content utilities

### Optional secondary use: C# only for proven hotspots

Do not start with C#.
Introduce it only if profiling later shows clear performance bottlenecks in:

- simulation bursts
- path or influence calculations
- heavy procedural generation

## 3. Project structure recommendation

Recommended top-level structure inside the game project:

- `scenes/`
- `scripts/`
- `data/`
- `art/`
- `audio/`
- `ui/`
- `tools/`
- `tests/`
- `docs/`

Recommended module split:

- `scripts/core/`
- `scripts/run/`
- `scripts/hub/`
- `scripts/combat/`
- `scripts/items/`
- `scripts/worlds/`
- `scripts/meta/`
- `scripts/ui/`
- `scripts/debug/`

## 4. Data-driven architecture

The project should be heavily data-driven.

Store most content definitions in external data files:

- item definitions
- enemy definitions
- world modifiers
- event pools
- reward tables
- run parameters

Recommended formats:

- JSON for readable interchange and tools
- Godot `Resource` assets for editor-integrated content when stable

Suggested rule:

- prototype in JSON or simple resources
- migrate only stable content to richer editor assets

## 5. Core technical architecture

### Gameplay model

Use a rules-first architecture:

- item data defines static identity
- effect components define behavior blocks
- simulation resolves through ordered phases
- visual layer listens to simulation output instead of owning game truth

This reduces chaos as content scales.

### Simulation model

Combat should run on deterministic simulation rules:

- pre-battle setup
- start-of-battle effects
- repeating timed actions
- triggered reactions
- death resolution
- reward resolution

This makes:

- debugging easier
- replays easier
- balance testing easier

### UI model

Use UI as a thin layer over state:

- space grid state
- item selection state
- hover inspection state
- combat telemetry state
- reward and shop state

Avoid letting UI widgets hold authoritative rules.

## 6. Save and persistence

Need separate save layers:

- settings save
- player progression save
- run snapshot save
- debug or replay snapshots

Minimum persistence needs:

- unlocked content
- player options
- last active run if suspended
- tutorial state
- statistics for balancing

## 7. Tools and workflow

Recommended tools:

- Git for version control
- GitHub or Gitea for collaboration
- Figma for UI wireframes
- Aseprite for pixel item and icon iteration if pixel-based
- Krita or Photoshop for painted concept work
- Obsidian or Markdown docs for design tracking

## 8. Testing strategy

Testing must focus on systems, not just manual play.

Need:

- unit-like tests for item effect resolution
- regression tests for combat ordering
- validation checks for malformed data
- debug seed support for repeatable runs
- sandbox simulation mode for balance checks

Most important early debug features:

- force-add item
- force-load seed
- skip to encounter
- inspect effect chain
- export combat log

## 9. Build targets

Primary:

- Windows PC

Secondary later:

- Steam Deck verification

Do not expand platform scope before the first public demo is stable.
