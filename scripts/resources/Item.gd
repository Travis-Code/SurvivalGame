# Item.gd
# Defines what an item is. Create instances of this (as .tres files) for each item type.
# Example: res://resources/items/Wood.tres, res://resources/items/Stone.tres

extends Resource
class_name Item

# Unique identifier for this item type (e.g., "wood", "stone", "copper_ore")
@export var id: String = ""

# Display name shown in inventory UI (e.g., "Wood Log", "Stone")
@export var display_name: String = ""

# Description of what this item is or does
@export var description: String = ""

# How many of this item can stack in one inventory slot (e.g., 64 for stackable items)
@export var max_stack: int = 64

# Optional: texture/sprite to display in inventory
@export var icon: Texture2D

# Validate that required fields are set
func _validate_property(property: Dictionary) -> void:
	if property.name == "id" and id == "":
		push_warning("Item id is empty!")
	if property.name == "display_name" and display_name == "":
		push_warning("Item display_name is empty!")

# Get a string representation of the item (useful for debugging)
func _to_string() -> String:
	return "[Item: %s - %s]" % [id, display_name]
