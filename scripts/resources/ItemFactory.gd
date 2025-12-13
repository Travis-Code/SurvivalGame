# ItemFactory.gd
# Centralized location for creating item instances.
# Eliminates duplicate item definitions across the codebase.

extends Node
class_name ItemFactory

const Item = preload("res://scripts/resources/Item.gd")

# Item definitions
static var ITEMS = {
	"wood": {
		"display_name": "Wood Log",
		"description": "A piece of wood from a tree",
		"max_stack": 64
	},
	"stone": {
		"display_name": "Stone",
		"description": "A piece of stone",
		"max_stack": 64
	},
	"copper_ore": {
		"display_name": "Copper Ore",
		"description": "Raw copper ore",
		"max_stack": 32
	},
	"pickaxe": {
		"display_name": "Pickaxe",
		"description": "A tool for mining stone and ore",
		"max_stack": 1
	}
}

# Create an item instance by ID
static func create_item(item_id: String) -> Item:
	if not item_id in ITEMS:
		push_error("Unknown item: %s" % item_id)
		return null
	
	var item = Item.new()
	var data = ITEMS[item_id]
	item.id = item_id
	item.display_name = data.get("display_name", item_id)
	item.description = data.get("description", "")
	item.max_stack = data.get("max_stack", 64)
	
	return item

# Get item color for UI display
static func get_item_color(item_id: String) -> Color:
	match item_id:
		"wood":
			return Color(0.45, 0.25, 0.1, 0.9)
		"stone":
			return Color(0.5, 0.5, 0.5, 0.9)
		"copper_ore":
			return Color(0.78, 0.45, 0.16, 0.9)
		"pickaxe":
			return Color(0.3, 0.3, 0.4, 0.9)
		"":
			return Color(0.15, 0.15, 0.15, 0.6)
		_:
			return Color(0.25, 0.25, 0.25, 0.8)
