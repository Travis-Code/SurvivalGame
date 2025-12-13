# Survival Game

A 2D survival and base-building game with scavenging mechanics.

## Game Concept

### Core Gameplay
- **Base Management**: Maintain and upgrade your apartment/shelter
- **Resource Gathering**: Mine, chop trees, and scavenge for materials
- **Crafting System**: Create tools, weapons, and upgrades
- **Exploration**: Venture into the world to find resources and supplies
- **Survival**: Manage resources and prepare for challenges

### Key Features
- 2D platformer with parallax scrolling
- Traversable background layers
- Base upgrade system
- Resource gathering (mining, woodcutting)
- Crafting and blacksmithing
- Job system for earning resources
- Peaceful base sanctuary contrasted with dangerous outside world

### Inspirations
- Fallout Shelter (base layout and management)
- Sheltered (survival mechanics)
- The Sims (life simulation elements)

## Technical Stack
- **Engine**: Godot 4.x
- **Language**: GDScript
- **Art Style**: 2D pixel art / hand-drawn

## Controls
- **A/D or Arrow Keys**: Move left/right
- **W/Space**: Jump
- **E**: Interact
- **B**: Open Bag (Inventory)
- **P**: Toggle Debug Panel

## Getting Started

1. Open the project in Godot 4.x
2. Press F5 to run the game
3. **Press P** to see the debug panel showing scene objects, player position, velocity, and inventory

## Current Features

### Gameplay
- **2D Platformer**: Move left/right, jump with physics
- **Extended Platforms**: 4800px wide platforms for exploration
- **Inventory System**: Collect items (wood, stone, copper ore) shown in the Bag UI
- **Resource Nodes**: Boulder (mineable with pickaxe), pickups (wood, stone, copper)
- **Scene Transitions**: Portal system connecting different areas
- **Interior Exploration**: Clickable house entrance leads to interior scene

### Debug Features
- **Debug Panel (P key)**: Real-time display of scene information
  - Current scene name
  - Player position and velocity
  - Player ground contact status
  - Inventory contents
  - All scene objects with node types

## Project Structure

```
/scenes/          # Game scenes
  /player/        # Player character
  /base/          # Base/home scenes
  /world/         # World and exploration scenes
  /ui/            # User interface
/scripts/         # GDScript files
  /player/        # Player scripts
  /systems/       # Game systems (inventory, crafting, etc.)
  /resources/     # Resource management
/assets/          # Game assets
  /sprites/       # Character and object sprites
  /backgrounds/   # Parallax backgrounds
  /ui/            # UI graphics
  /audio/         # Sound effects and music
/resources/       # Godot resources
  /items/         # Item definitions
  /recipes/       # Crafting recipes
```
