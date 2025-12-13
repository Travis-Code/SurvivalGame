extends Area2D

const ItemFactory = preload("res://scripts/resources/ItemFactory.gd")

@export var amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if amount < 1:
		amount = 1

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var inv = body.get("inventory")
	if inv == null:
		push_warning("Body lacks inventory to receive pickup")
		return
	if not inv.has_method("add_item"):
		push_warning("Inventory node missing add_item()")
		return
	var stone_item = ItemFactory.create_item("stone")
	var added: bool = inv.add_item(stone_item, amount)
	if added:
		queue_free()

