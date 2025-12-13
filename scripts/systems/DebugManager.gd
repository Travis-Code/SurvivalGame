extends CanvasLayer

var debug_labels_visible: bool = false
var panel_container: PanelContainer
var item_list: VBoxContainer

func _ready() -> void:
	# Create panel layout similar to Bag menu
	layer = 100
	
	panel_container = PanelContainer.new()
	panel_container.anchor_left = 0.01
	panel_container.anchor_top = 0.1
	panel_container.anchor_right = 0.25
	panel_container.anchor_bottom = 0.9
	add_child(panel_container)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 0)
	panel_container.add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "Debug"
	title.custom_minimum_size = Vector2(0, 30)
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)
	
	# Legend
	var legend = Label.new()
	legend.text = "Scene Objects\n(Click to toggle panel)"
	legend.add_theme_font_size_override("font_size", 10)
	legend.modulate = Color(0.6, 0.6, 0.6, 0.8)
	legend.custom_minimum_size = Vector2(0, 35)
	vbox.add_child(legend)
	
	# Scroll container
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(250, 600)
	vbox.add_child(scroll)
	
	# Item list (VBoxContainer inside scroll)
	item_list = VBoxContainer.new()
	item_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(item_list)
	
	panel_container.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_toggle"):
		debug_labels_visible = !debug_labels_visible
		if debug_labels_visible:
			_refresh_labels()
		panel_container.visible = debug_labels_visible

func _refresh_labels() -> void:
	# Clear old labels
	for child in item_list.get_children():
		child.queue_free()
	
	# Create new labels for all Node2D objects
	var root = get_tree().current_scene
	_create_labels_for_tree(root)

func _create_labels_for_tree(node: Node) -> void:
	# Only create labels for Node2D nodes (skip Label nodes themselves)
	if node is Node2D and not node is Label:
		var label_row = _create_label_row(node.name, node)
		item_list.add_child(label_row)
	
	# Recurse through children
	for child in node.get_children():
		_create_labels_for_tree(child)

func _create_label_row(text: String, node: Node2D) -> VBoxContainer:
	var row = VBoxContainer.new()
	row.custom_minimum_size = Vector2(0, 50)
	row.add_theme_constant_override("separation", 2)
	
	# Top: name + type
	var top_row = HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 8)
	
	# Colored indicator rectangle
	var color_rect = ColorRect.new()
	color_rect.custom_minimum_size = Vector2(20, 20)
	color_rect.color = Color(0.3, 0.5, 0.9, 0.7)
	top_row.add_child(color_rect)
	
	# Node name label
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.custom_minimum_size = Vector2(150, 0)
	top_row.add_child(label)
	
	row.add_child(top_row)
	
	# Bottom: type description
	var desc_label = Label.new()
	desc_label.text = "[%s]" % node.get_class()
	desc_label.add_theme_font_size_override("font_size", 10)
	desc_label.modulate = Color(0.7, 0.7, 0.7, 0.8)
	desc_label.custom_minimum_size = Vector2(150, 0)
	row.add_child(desc_label)
	
	return row
