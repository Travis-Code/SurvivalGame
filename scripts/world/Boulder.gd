extends Area2D

const Item = preload("res://scripts/resources/Item.gd")

@export var item_id: String = "stone"
@export var amount: int = 1

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_add_stone_to_inventory()

func _add_stone_to_inventory() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		print("No player found")
		return
	var player = players[0]
	var inv = player.get("inventory")
	if inv == null:
		print("Player inventory not found")
		return
	var stone := Item.new()
	stone.id = item_id
	stone.display_name = "Stone"
	stone.description = "A piece of stone"
	stone.max_stack = 64
	inv.add_item(stone, amount)
	print("Added %d %s to inventory" % [amount, item_id])
