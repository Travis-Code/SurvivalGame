# BasePickup.gd
# Base class for all pickupable items in the world.
# Eliminates duplicate code in LogPickup, StonePickup, CopperPickup.

extends Area2D
class_name BasePickup

const ItemFactory = preload("res://scripts/resources/ItemFactory.gd")

@export var item_id: String = "wood"
@export var amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if amount < 1:
		amount = 1

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	var inv = body.get("inventory")
	if not inv:
		push_warning("Body lacks inventory")
		return
	
	var item = ItemFactory.create_item(item_id)
	if not item:
		return
	
	if inv.add_item(item, amount):
		queue_free()
