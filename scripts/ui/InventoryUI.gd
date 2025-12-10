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

# Item row scene for drag support
const InventoryItemRow = preload("res://scripts/ui/InventoryItemRow.gd")

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
	
	# Display each item with draggable rows
	for item_id: String in items_data:
		var quantity = items_data[item_id]
		var display_name := item_id
		if inventory.has_method("get_item_display_name"):
			display_name = inventory.get_item_display_name(item_id)
		var rect_color := _get_item_color(item_id)
		var item_row = InventoryItemRow.new()
		item_row.custom_minimum_size = Vector2(0, 30)
		item_row.setup(item_id, quantity, display_name)
		item_row.set_count_color(rect_color)
		item_row.clicked.connect(_on_item_row_clicked)
		item_list.add_child(item_row)

func _on_item_row_clicked(item_id: String) -> void:
	print("Clicked item row: ", item_id)

func _get_item_color(item_id: String) -> Color:
	match item_id:
		"wood":
			return Color(0.45, 0.25, 0.1, 0.7)
		"stone":
			return Color(0.5, 0.5, 0.5, 0.7)
		"copper_ore":
			return Color(0.78, 0.45, 0.16, 0.7)
		"pickaxe":
			return Color(0.3, 0.3, 0.4, 0.7)
		_:
			return Color(0.2, 0.2, 0.2, 0.35)

# Called when inventory changes
func _on_inventory_changed() -> void:
	if inventory_open:
		_refresh_display()
