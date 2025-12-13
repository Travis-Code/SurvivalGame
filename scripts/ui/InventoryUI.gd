# InventoryUI.gd
# Displays the inventory on screen and updates when items change.
# Shows item counts and allows viewing what the player has collected.

extends CanvasLayer

const Inventory = preload("res://scripts/systems/Inventory.gd")
const ItemFactory = preload("res://scripts/resources/ItemFactory.gd")
const InventoryItemRow = preload("res://scripts/ui/InventoryItemRow.gd")

var inventory: Inventory

@onready var item_list: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemList
@onready var panel: PanelContainer = $PanelContainer

var inventory_open: bool = false

func _ready() -> void:
	panel.visible = false
	inventory_open = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func set_inventory(inv: Inventory) -> void:
	inventory = inv
	
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		_on_inventory_changed()

func toggle_inventory() -> void:
	inventory_open = !inventory_open
	panel.visible = inventory_open
	
	if inventory_open:
		_refresh_display()

func _refresh_display() -> void:
	if not inventory:
		return
	
	for child in item_list.get_children():
		child.queue_free()
	
	var items_data = inventory.items
	
	if items_data.is_empty():
		var empty_label = Label.new()
		empty_label.text = "[Empty]"
		empty_label.modulate = Color.GRAY
		item_list.add_child(empty_label)
		return
	
	for item_id: String in items_data:
		var quantity = items_data[item_id]
		var display_name := inventory.get_item_display_name(item_id)
		var rect_color := ItemFactory.get_item_color(item_id)
		var item_row = InventoryItemRow.new()
		item_row.custom_minimum_size = Vector2(0, 30)
		item_row.setup(item_id, quantity, display_name)
		item_row.set_count_color(rect_color)
		item_row.clicked.connect(_on_item_row_clicked)
		item_list.add_child(item_row)

func _on_item_row_clicked(item_id: String) -> void:
	print("Clicked item row: ", item_id)

func _on_inventory_changed() -> void:
	if inventory_open:
		_refresh_display()

