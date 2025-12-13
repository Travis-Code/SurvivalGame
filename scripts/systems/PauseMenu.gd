# PauseMenu.gd
# Main pause menu controller - handles pause state and menu display

extends CanvasLayer

var is_paused: bool = false
var panel_container: PanelContainer
var resume_btn: Button
var quit_btn: Button

func _ready() -> void:
	layer = 200
	process_mode = Node.PROCESS_MODE_ALWAYS  # Always process even when paused
	_create_pause_menu()
	panel_container.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_pause()
		get_tree().root.set_input_as_handled()

func toggle_pause() -> void:
	is_paused = !is_paused
	panel_container.visible = is_paused
	get_tree().paused = is_paused
	
	# Focus resume button when pausing
	if is_paused:
		resume_btn.grab_focus()
	else:
		panel_container.visible = false

func _create_pause_menu() -> void:
	panel_container = PanelContainer.new()
	panel_container.anchor_left = 0.35
	panel_container.anchor_top = 0.35
	panel_container.anchor_right = 0.65
	panel_container.anchor_bottom = 0.65
	panel_container.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(panel_container)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.mouse_filter = Control.MOUSE_FILTER_STOP
	panel_container.add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(0, 50)
	vbox.add_child(title)
	
	# Resume button
	resume_btn = Button.new()
	resume_btn.text = "Resume"
	resume_btn.custom_minimum_size = Vector2(200, 50)
	resume_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	resume_btn.pressed.connect(_on_resume_pressed)
	vbox.add_child(resume_btn)
	
	# Quit button
	quit_btn = Button.new()
	quit_btn.text = "Quit to Main Menu"
	quit_btn.custom_minimum_size = Vector2(200, 50)
	quit_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)

func _on_resume_pressed() -> void:
	print("Resume button pressed")
	toggle_pause()

func _on_quit_pressed() -> void:
	print("Quit button pressed")
	is_paused = false
	panel_container.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")



