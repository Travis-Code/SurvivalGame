# BaseSceneTransition.gd
# Base class for interactive scene transitions (portals, doors, etc).
# Eliminates duplicate code in Portal, House, Door.

extends Control
class_name BaseSceneTransition

@export var destination_scene: String = ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_transition()

func _transition() -> void:
	if destination_scene:
		get_tree().change_scene_to_file(destination_scene)
