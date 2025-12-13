extends ColorRect

signal house_clicked

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_enter_house()

func _enter_house() -> void:
	get_tree().change_scene_to_file("res://scenes/HouseInterior.tscn")
