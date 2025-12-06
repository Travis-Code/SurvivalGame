# InventoryUI.gd
# Displays the inventory on screen and updates when items change.
# Shows item counts and allows viewing what the player has collected.

extends CanvasLayer

# Load the Inventory class
const Inventory = preload("res://scripts/systems/Inventory.gd")

# Reference to the inventory system
var inventory: Inventory

# Reference to the container where items are displayed
@onready var item_list: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemList

# Reference to the entire UI panel
@onready var panel: PanelContainer = $PanelContainer

# Track if inventory panel is currently visible
var inventory_open: bool = false

func _ready() -> void:
	# Hide inventory by default
	panel.visible = false
	inventory_open = false

func _process(_delta: float) -> void:
	# Toggle inventory with I key
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

# Set the inventory to display (called by Player)
func set_inventory(inv: Inventory) -> void:
	inventory = inv
	
	# Connect to inventory signals so UI updates when items change
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		_on_inventory_changed()  # Initial display

# Toggle inventory visibility
func toggle_inventory() -> void:
	inventory_open = !inventory_open
	panel.visible = inventory_open
	
	if inventory_open:
		_refresh_display()

# Refresh the entire inventory display
func _refresh_display() -> void:
	if not inventory:
		return
	
	# Clear old items from display
	for child in item_list.get_children():
		child.queue_free()
	
	# Get all items from inventory
	var items_data = inventory.items
	
	# If empty, show message
	if items_data.is_empty():
		var empty_label = Label.new()
		empty_label.text = "[Empty]"
		empty_label.modulate = Color.GRAY
		item_list.add_child(empty_label)
		return
	
	# Display each item
	for item_id: String in items_data:
		var quantity = items_data[item_id]
		
		# Create a container for each item row
		var item_row = HBoxContainer.new()
		item_row.custom_minimum_size = Vector2(0, 30)
		
		# Item name label
		var name_label = Label.new()
		name_label.text = item_id
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_row.add_child(name_label)
		
		# Quantity label
		var qty_label = Label.new()
		qty_label.text = "x%d" % quantity
		qty_label.modulate = Color.YELLOW
		item_row.add_child(qty_label)
		
		item_list.add_child(item_row)

# Called when inventory changes
func _on_inventory_changed() -> void:
	if inventory_open:
		_refresh_display()
