extends CanvasLayer

const HotbarSlot = preload("res://scripts/ui/HotbarSlot.gd")
const Inventory = preload("res://scripts/systems/Inventory.gd")

@export var slot_count: int = 8
@export var slot_size: Vector2 = Vector2(56, 56)

var inventory: Inventory
var slots: Array = []

@onready var slot_container: HBoxContainer = $Control/MarginContainer/HBoxContainer

func _ready() -> void:
	_create_slots()

func set_inventory(inv: Inventory) -> void:
	inventory = inv
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		_on_inventory_changed()

func _create_slots() -> void:
	slots.clear()
	for child in slot_container.get_children():
		child.queue_free()
	for i in slot_count:
		var slot = HotbarSlot.new()
		slot.custom_minimum_size = slot_size
		slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot.set_hotbar(self)
		slot.slot_number = i + 1
		slot_container.add_child(slot)
		slots.append(slot)

func notify_slot_changed(_slot: Control) -> void:
	_on_inventory_changed()

func _on_inventory_changed() -> void:
	if not inventory:
		return
	for slot in slots:
		var id = slot.assigned_item_id
		var label_text = "[%d]" % slot.slot_number
		if id == "":
			if slot.label:
				slot.label.text = label_text
			continue
		var qty := 0
		if id in inventory.items:
			qty = inventory.items[id]
		if slot.label:
			slot.label.text = "%s %s (%d)" % [label_text, id, qty]
