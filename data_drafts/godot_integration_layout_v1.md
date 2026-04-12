# Godot Integration Layout v1

This document maps the current design drafts into a Godot-friendly project data layout.

## Recommended project folders

```text
data/
  items/
    roster/
      first_item_roster_v1.json
  professions/
    profession_roster_v1.json
  boards/
    board_variants_v1.json
  rewards/
    reward_tables_v1.json
  schema/
    item_schema_reference.md
```

## Recommended scene and script alignment

```text
scenes/
  hub/
  boards/
  shop/
  combat/

scripts/
  data/
  boards/
  items/
  professions/
  rewards/
  ui/
```

## File naming rules

- Use lowercase snake_case for data filenames.
- Match item `id` to future icon, tooltip, and resource naming when possible.
- Use one source-of-truth JSON file per major system during prototype stage.
- Split into per-item resources only after the data model stabilizes.

## ID naming rules

- Items: `azure_edge`
- Professions: `cultivator`
- Board variants: `formation_board`
- Reward pools: `regular_reward_pool`

## Recommended Godot loading approach

- Load JSON drafts through a lightweight data loader in `scripts/data/`.
- Convert validated JSON records into runtime dictionaries or typed helper objects.
- Keep rendering and simulation separate from raw JSON loading.

## Suggested next implementation files

```text
scripts/data/data_loader.gd
scripts/data/item_registry.gd
scripts/data/profession_registry.gd
scripts/data/board_registry.gd
scripts/data/reward_registry.gd
```

## Migration rule

- Keep `data_drafts/` as planning-stage source files.
- Copy or promote stable drafts into `data/` once implementation begins.
- Do not mutate prototype runtime data and planning drafts independently for long.
