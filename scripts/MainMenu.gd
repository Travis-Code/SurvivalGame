# MainMenu.gd
# Main menu scene controller

extends Node2D

func _ready() -> void:
	_create_menu()

func _create_menu() -> void:
	var layer = CanvasLayer.new()
	add_child(layer)

	var center = CenterContainer.new()
	center.anchor_left = 0
	center.anchor_top = 0
	center.anchor_right = 1
	center.anchor_bottom = 1
	center.grow_horizontal = Control.GROW_DIRECTION_BOTH
	center.grow_vertical = Control.GROW_DIRECTION_BOTH
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layer.add_child(center)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	center.add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "SURVIVAL GAME"
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(title)
	
	# Play button
	var play_btn = Button.new()
	play_btn.text = "Play"
	play_btn.custom_minimum_size = Vector2(200, 50)
	play_btn.pressed.connect(_on_play_pressed)
	vbox.add_child(play_btn)
	
	# Quit button
	var quit_btn = Button.new()
	quit_btn.text = "Quit"
	quit_btn.custom_minimum_size = Vector2(200, 50)
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
