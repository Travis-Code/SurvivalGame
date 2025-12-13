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
- **E**: Interact with objects
- **I**: Open Inventory
- **ESC**: Pause Menu
- **Left Click**: Click on portals to travel between scenes, click boulders to mine them

## Getting Started

1. Open the project in Godot 4.x
2. Press F5 to run the game
3. Game starts at the main menu - click "Start Game" to begin
4. Use portals (cyan rectangles) to travel between Home and Quarry scenes
## Current Features

### Gameplay
- **Main Menu**: Start screen with Start Game and Quit options
- **Pause Menu**: Press ESC to pause/resume or quit to main menu
- **2D Platformer**: Move left/right, jump with physics-based controls
- **Scene Navigation**: Click on cyan portals to travel between Home and Quarry
- **Home Scene**: Your base area with a house and portal to the Quarry
- **Quarry Scene**: Mining area with boulders and resource pickups
- **Mining System**: Click boulders multiple times to break them (6-14 clicks based on size)
- **Inventory System**: Collect items (wood, stone, copper ore) shown in the Inventory UI (I key)
- **Resource Nodes**: Various sized boulders in the Quarry, wood and copper pickups
- **Interior Exploration**: Click on the house to enter the interior
- **Scene Label**: Always-visible indicator showing current scene (Home/Quarry)
- **Water Boundaries**: Blue water fills the areas beyond platform edges

### Debug Features
- Scene name display in top-left corner
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
