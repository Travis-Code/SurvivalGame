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
- **I**: Open inventory

## Getting Started

1. Open the project in Godot 4.x
2. The main scene will be set up once initial development begins
3. Press F5 in Godot to run the game

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
