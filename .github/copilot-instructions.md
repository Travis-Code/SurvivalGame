# Copilot Instructions for SurvivalGame (Godot 4)

These notes help AI coding agents work productively in this repo. Focus on what already exists; prefer incremental, idiomatic Godot 4 GDScript.

## Project Overview
- Engine: Godot 4.x, language: GDScript. Entry scene is `res://scenes/Main.tscn` (set in `project.godot`).
- Current gameplay: simple 2D platformer scaffold with a controllable `Player` and a ground platform.

## Layout & Conventions
- Scenes: `scenes/` with subfolders per domain (`player/`, `base/`, `world/`, `ui/`). Example: `scenes/player/Player.tscn`.
- Scripts: `scripts/` mirroring scene domains (`player/`, `systems/`, `resources/`). Example: `scripts/player/Player.gd`.
- Data: Godot resources live under `resources/` (`items/`, `recipes/`) — presently placeholders for item/recipe definitions.
- Assets: art/audio under `assets/` (`sprites/`, `backgrounds/`, `ui/`, `audio/`). Currently placeholders.
- Naming: Scene files and scripts use PascalCase (e.g., `Player.tscn`, `Player.gd`); directories are lowercase.

## Input Map & Controls
- Inputs are defined in `project.godot` under `[input]`: `move_left`, `move_right`, `jump`, `interact`, `inventory`.
- Controls (from `README.md`): A/D or arrows to move, W/Space to jump, E interact, I inventory.
- Pattern: Use `Input.get_action_strength("move_right") - Input.get_action_strength("move_left")` for horizontal input; `Input.is_action_just_pressed("jump")` for jumping.

## Player Pattern (CharacterBody2D)
- Script: `scripts/player/Player.gd` extends `CharacterBody2D` and updates in `_physics_process(delta)`.
- Movement: writes to `velocity` then calls `move_and_slide()`.
- Gravity: applied when not on floor; uses `@export` vars for tuning: `speed`, `jump_velocity`, `gravity`, `max_fall_speed`.
- Example reference: see `Player.gd` for exact implementation and style (tabs, concise methods, exported floats).

## Scene Composition
- `scenes/Main.tscn`: root `Node2D` with a `StaticBody2D` ground (`CollisionShape2D` + visual `Polygon2D`) and an instanced `Player`.
- `scenes/player/Player.tscn`: `CharacterBody2D` + `CollisionShape2D` (rect), simple `Polygon2D` body, and `Camera2D` with `current=true`.
- Pattern: author reusable scenes, then instance them in parent scenes via PackedScene resources.

## Common Tasks (do it this way)
- New gameplay system: create script in `scripts/systems/` and attach to a scene or an autoload if needed. Keep APIs small and signal-driven when applicable (only if signals exist; avoid inventing new patterns without code references).
- New actor: create a `*.tscn` under `scenes/<domain>/`, extend `CharacterBody2D` or `Node2D`, export tunables, update in `_physics_process` if physics-based.
- Input changes: update `[input]` in `project.godot`; consume via `Input.*` in scripts using the existing naming pattern.
- Data definitions: add `.tres`/`.res` resources in `resources/items/` and `resources/recipes/`; load via `preload()`/`load()` from systems in `scripts/resources/`.

## Running & Debugging
- Open `project.godot` in Godot 4.x; press F5 to run. The configured main scene is `scenes/Main.tscn`.
- Use the Remote Scene Tree and live variables to tweak exported values on `Player` for quick iteration.

## Style Notes
- Keep node/script paths in `res://` form; keep directory structure intact.
- Prefer exported vars for tunables visible in the editor; keep physics logic in `_physics_process`.
- Reuse the input action names already defined; don’t hardcode keycodes.

## Pointers to Source
- Entry: `project.godot` → `run/main_scene`, `[input]`.
- Main scene: `scenes/Main.tscn`.
- Player: `scenes/player/Player.tscn`, `scripts/player/Player.gd`.
- Placeholders: `resources/items/`, `resources/recipes/`, `scripts/systems/`.
