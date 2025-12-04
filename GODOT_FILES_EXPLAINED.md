# Understanding Godot File Types

This guide explains the two main file types in Godot projects: `.tscn` (scenes) and `.gd` (scripts).

---

## `.tscn` Files - Scene Files (Structure/Blueprint)

**What they are:**
- Scene files that define the **structure** of game objects
- Think of them like architectural blueprints or LEGO instruction manuals
- Written in Godot's text-based scene format
- **Cannot have comments** (Godot's parser doesn't support them)

**What they contain:**
- Node hierarchy (parent-child relationships)
- Node properties (positions, sizes, colors, physics settings)
- References to external resources (scripts, textures, other scenes)
- Visual layout and component configuration

---

### Example: `Player.tscn` Breakdown

```gdscene
[gd_scene load_steps=3 format=3]
```
- `gd_scene` = This is a Godot scene file
- `load_steps=3` = This file has 3 resources to load
- `format=3` = Using Godot 4's scene format

```gdscene
[ext_resource type="Script" path="res://scripts/player/Player.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/HealthBar.tscn" id="2"]
```
- `ext_resource` = External Resource (reference to a file outside this scene)
- `id="1"` = Internal identifier used within this file to reference the resource
- First line: Links to the Player.gd script
- Second line: Links to the HealthBar scene (we'll instance it later)

```gdscene
[sub_resource type="RectangleShape2D" id="1"]
size = Vector2(32, 48)
```
- `sub_resource` = A resource defined within this file (not external)
- Creates a collision shape: 32 pixels wide, 48 pixels tall
- This rectangle defines the player's physical boundaries

```gdscene
[node name="Player" type="CharacterBody2D"]
script = ExtResource("1")
```
- `[node ...]` = Creates a node (game object)
- `name="Player"` = The node's name in the scene tree
- `type="CharacterBody2D"` = It's a physics-based character body
- `script = ExtResource("1")` = Attach Player.gd to this node

```gdscene
[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
position = Vector2(0, 0)
shape = SubResource("1")
```
- `parent="."` = Make this a child of the Player node (. = current parent)
- `position = Vector2(0, 0)` = Position relative to parent (centered on player)
- `shape = SubResource("1")` = Use the rectangle collision shape we defined above
- This node is invisible but defines where the player collides with things

```gdscene
[node name="Body" type="Polygon2D" parent="."]
polygon = PackedVector2Array(-16, -24, 16, -24, 16, 24, -16, 24)
color = Color(0.4, 0.8, 1, 1)
```
- `Polygon2D` = A visible 2D shape made of points
- `polygon = [points]` = The four corners of a rectangle:
  - (-16, -24) = top-left
  - (16, -24) = top-right
  - (16, 24) = bottom-right
  - (-16, 24) = bottom-left
- `color = Color(r, g, b, a)` = Light blue color (0.4 red, 0.8 green, 1.0 blue, 1.0 alpha)
- This is what you see on screen (the blue square)

```gdscene
[node name="Camera2D" type="Camera2D" parent="."]
current = true
zoom = Vector2(1, 1)
```
- `Camera2D` = A camera that follows the player
- `current = true` = Make this the active camera (the one that renders the game)
- `zoom = Vector2(1, 1)` = Normal zoom level (no zoom in/out)

```gdscene
[node name="HealthBar" parent="." instance=ExtResource("2")]
```
- `instance=ExtResource("2")` = Load the entire HealthBar.tscn scene as a child node
- This is **scene instancing** - reusing a complete scene as a component
- The HealthBar scene has its own nodes and scripts, all included here

**Final scene tree:**
```
Player (CharacterBody2D) + Player.gd script
├── CollisionShape2D (invisible physics boundary)
├── Body (visible blue rectangle)
├── Camera2D (follows player)
└── HealthBar (entire HealthBar.tscn scene instanced here)
```

---

### Example: `HealthBar.tscn` Breakdown

```gdscene
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/HealthBar.gd" id="1"]
```
- Links to HealthBar.gd script

```gdscene
[node name="HealthBar" type="ProgressBar"]
offset_left = -50.0
offset_top = -40.0
offset_right = 50.0
offset_bottom = -30.0
```
- `ProgressBar` = Built-in Godot UI element that shows a bar (0% to 100%)
- `offset_*` = Position and size of the bar:
  - Left edge at -50 pixels (50 pixels to the left of parent)
  - Top edge at -40 pixels (40 pixels above parent)
  - Right edge at 50 pixels (50 pixels to the right)
  - Bottom edge at -30 pixels (makes it 10 pixels tall)
- This positions the health bar above the player's head

```gdscene
max_value = 100.0
value = 100.0
show_percentage = false
script = ExtResource("1")
```
- `max_value = 100.0` = The bar represents a range from 0 to 100
- `value = 100.0` = Start at 100 (full health)
- `show_percentage = false` = Don't display "100%" text on the bar
- `script = ExtResource("1")` = Attach HealthBar.gd script

---

## `.gd` Files - GDScript Files (Behavior/Logic)

**What they are:**
- Script files containing game logic and behavior
- Written in GDScript (Godot's Python-like language)
- **Can have comments** using `#`

**What they contain:**
- Variables (health, speed, position)
- Functions (take_damage, jump, move)
- Game logic (if player presses jump, apply upward force)
- Event handlers (_ready, _physics_process)

See `scripts/player/Player.gd` and `scripts/ui/HealthBar.gd` for fully commented examples.

---

## How `.tscn` and `.gd` Work Together

**The Pattern:**
1. Create a `.tscn` scene in Godot Editor (defines WHAT exists)
2. Attach a `.gd` script to nodes (defines HOW they behave)
3. The script accesses nodes using `$NodeName` or `@onready`

**Example from Player:**

**`Player.tscn` says:**
- "The Player has a HealthBar child node"

**`Player.gd` says:**
```gdscript
@onready var health_bar = $HealthBar  # Get reference to the HealthBar node

func take_damage(amount):
    health_bar.update_health(current_health, max_health)  # Tell it to update
```

---

## Key Differences

| Aspect | `.tscn` | `.gd` |
|--------|---------|-------|
| **Purpose** | Structure/layout | Behavior/logic |
| **Contains** | Nodes, properties, hierarchy | Code, functions, variables |
| **Edited in** | Godot Editor (visual) | VS Code or Godot (text) |
| **Defines** | WHAT exists and WHERE | HOW it behaves and WHEN |
| **Comments** | ❌ Not supported | ✅ Use `#` for comments |
| **Example** | "There's a health bar at position (0, -40)" | "When damage is taken, reduce health by 10" |

---

## Real-World Analogy

Think of building a car:

- **`.tscn`** = The assembly manual showing all the parts and where they go (engine, wheels, seats, steering wheel)
- **`.gd`** = The instruction manual telling you how to use each part (turn key to start, press gas to accelerate)

You need **both**:
- Without `.tscn`: Code has no objects to control
- Without `.gd`: Objects just sit there doing nothing

---

## Editing Best Practices

**For `.tscn` files:**
- Edit in Godot Editor (visual, drag-and-drop)
- Only edit in VS Code for quick property tweaks
- Never add comments (will cause parse errors)

**For `.gd` files:**
- Edit in VS Code (better autocomplete, intellisense)
- Add lots of comments to explain logic
- Use `@export` for values you want to tweak in the editor

---

## Summary

- **`.tscn`** = Blueprint (structure, nodes, hierarchy, properties)
- **`.gd`** = Instructions (code, logic, behavior, functions)
- Together = Working game objects!

All the code explanations are in the `.gd` files. The `.tscn` files are just data that Godot reads to build the scene tree.
