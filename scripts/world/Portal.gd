extends Area2D

@export var destination_scene: String = "res://scenes/Level2.tscn"

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_enter_portal()

func _enter_portal() -> void:
	get_tree().change_scene_to_file(destination_scene)
