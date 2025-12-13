extends Area2D

@export var destination_scene: String = "res://scenes/Quarry.tscn"

func _ready() -> void:
	input_pickable = true
	# Connect using Callable for Godot 4
	input_event.connect(_on_input_event)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var collision_shape = $CollisionShape2D
		if collision_shape and collision_shape.shape:
			var shape_rect = collision_shape.shape as RectangleShape2D
			if shape_rect:
				var rect = Rect2(global_position - shape_rect.size / 2, shape_rect.size)
				if rect.has_point(mouse_pos):
					_go_to_scene()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_go_to_scene()

func _go_to_scene() -> void:
	if destination_scene and ResourceLoader.exists(destination_scene):
		get_tree().paused = false
		get_tree().call_deferred("change_scene_to_file", destination_scene)

