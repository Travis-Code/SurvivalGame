# Inventory.gd
# Manages the player's inventory - items, quantities, and slot management.
# Emits signals when items are added/removed so UI can update.

extends Node
class_name Inventory

# Load the Item class
const Item = preload("res://scripts/resources/Item.gd")

# Signal emitted when an item is added (inventory, item, quantity)
signal item_added(item: Item, quantity: int)

# Signal emitted when an item is removed (inventory, item, quantity)
signal item_removed(item: Item, quantity: int)

# Signal emitted when inventory changes (full update)
signal inventory_changed

# Dictionary to store items: item.id -> quantity
# Example: {"wood": 5, "stone": 12, "copper_ore": 3}
var items: Dictionary = {}

# Maximum number of unique item types (slots)
@export var max_slots: int = 20

func _ready() -> void:
	# Print initial inventory (should be empty)
	print("Inventory ready with max_slots: %d" % max_slots)

# Add items to inventory
# Returns: true if successful, false if inventory is full (and stackable is false)
func add_item(item: Item, quantity: int = 1) -> bool:
	if quantity <= 0:
		push_error("Cannot add item with quantity <= 0")
		return false
	
	# Check if item already exists in inventory
	if item.id in items:
		# Item exists, just increase quantity (stackable)
		items[item.id] += quantity
		item_added.emit(item, quantity)
		inventory_changed.emit()
		return true
	
	# Item doesn't exist, check if we have space
	if items.size() >= max_slots:
		push_warning("Inventory full! Cannot add %s" % item.display_name)
		return false
	
	# Add new item
	items[item.id] = quantity
	item_added.emit(item, quantity)
	inventory_changed.emit()
	return true

# Remove items from inventory
# Returns: true if successful, false if not enough quantity
func remove_item(item: Item, quantity: int = 1) -> bool:
	if quantity <= 0:
		push_error("Cannot remove item with quantity <= 0")
		return false
	
	# Check if item exists
	if not item.id in items:
		push_warning("Item %s not in inventory" % item.id)
		return false
	
	# Check if we have enough quantity
	if items[item.id] < quantity:
		push_warning("Not enough %s (have %d, need %d)" % [item.display_name, items[item.id], quantity])
		return false
	
	# Remove the quantity
	items[item.id] -= quantity
	
	# If quantity is 0, remove the item completely
	if items[item.id] <= 0:
		items.erase(item.id)
	
	item_removed.emit(item, quantity)
	inventory_changed.emit()
	return true

# Check how many of an item we have
# Returns: quantity, or 0 if item doesn't exist
func get_item_quantity(item: Item) -> int:
	if item.id in items:
		return items[item.id]
	return 0

# Check if we have at least X of an item
func has_item(item: Item, quantity: int = 1) -> bool:
	return get_item_quantity(item) >= quantity

# Get all items as an array (useful for UI)
func get_all_items() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item_id: String in items:
		# We need to find the actual Item resource to return
		# For now, just return the id and quantity
		result.append({
			"id": item_id,
			"quantity": items[item_id]
		})
	return result

# Clear entire inventory
func clear() -> void:
	items.clear()
	inventory_changed.emit()

# Get inventory as string for debugging
func _to_string() -> String:
	if items.is_empty():
		return "Inventory: [empty]"
	
	var result = "Inventory: "
	for item_id: String in items:
		result += "%s x%d, " % [item_id, items[item_id]]
	
	return result.trim_suffix(", ")
