extends Area2D

const ItemFactory = preload("res://scripts/resources/ItemFactory.gd")

@export var item_id: String = "stone"
@export var amount: int = 1

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_give_item_to_player()

func _give_item_to_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		print("No player found")
		return
	
	var player = players[0]
	var inv = player.get("inventory")
	if not inv:
		print("Player inventory not found")
		return
	
	var item = ItemFactory.create_item(item_id)
	if item:
		inv.add_item(item, amount)
		print("Added %d %s to inventory" % [amount, item_id])

