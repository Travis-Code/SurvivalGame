extends Area2D

signal clicked(item_id: String)

@export var item_id: String = "stone"

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			clicked.emit(item_id)
			print("Boulder clicked: ", item_id)
