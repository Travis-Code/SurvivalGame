extends CanvasLayer

var debug_labels_visible: bool = false
var panel_container: PanelContainer
var item_list: VBoxContainer
var player: Node2D = null
var scene_label: Label

func _ready() -> void:
	# Create panel layout similar to Bag menu
	layer = 100

	# Always-visible scene badge
	scene_label = Label.new()
	scene_label.position = Vector2(12, 12)
	scene_label.add_theme_font_size_override("font_size", 12)
	scene_label.modulate = Color(1, 1, 1, 0.9)
	scene_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scene_label)
	
	panel_container = PanelContainer.new()
	panel_container.anchor_left = 0.01
	panel_container.anchor_top = 0.05
	panel_container.anchor_right = 0.25
	panel_container.anchor_bottom = 0.75
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
	legend.text = "Press P to toggle | Scene info below"
	legend.add_theme_font_size_override("font_size", 10)
	legend.modulate = Color(0.6, 0.6, 0.6, 0.8)
	legend.custom_minimum_size = Vector2(0, 30)
	vbox.add_child(legend)
	
	# Scroll container
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(280, 700)
	vbox.add_child(scroll)
	
	# Item list (VBoxContainer inside scroll)
	item_list = VBoxContainer.new()
	item_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_list.add_theme_constant_override("separation", 4)
	scroll.add_child(item_list)
	
	panel_container.visible = false

func _process(_delta: float) -> void:
	var cs = get_tree().current_scene
	var path = cs.scene_file_path if cs else ""
	var display_name = "Unknown"
	if path.ends_with("Main.tscn"):
		display_name = "Home"
	elif path.ends_with("Quarry.tscn"):
		display_name = "Quarry"
	else:
		display_name = cs.name if cs else "Unknown"
	scene_label.text = "Scene: %s" % display_name

	if Input.is_action_just_pressed("debug_toggle"):
		debug_labels_visible = !debug_labels_visible
		panel_container.visible = debug_labels_visible
	
	if debug_labels_visible:
		_update_debug_info()

func _update_debug_info() -> void:
	# Find player if not cached
	if not player:
		player = get_tree().current_scene.find_child("Player", false, false)
	
	# Clear and rebuild
	for child in item_list.get_children():
		child.queue_free()
	
	# Scene info
	var scene_label = _create_info_label("SCENE INFO", Color(1, 1, 0.5, 1))
	item_list.add_child(scene_label)
	
	var current_scene = get_tree().current_scene
	var scene_name = current_scene.name if current_scene else "Unknown"
	var scene_info = _create_simple_label("Scene: %s" % scene_name)
	item_list.add_child(scene_info)
	
	# Player info
	if player:
		var player_header = _create_info_label("PLAYER", Color(0.5, 1, 0.5, 1))
		item_list.add_child(player_header)
		
		var pos_label = _create_simple_label("Pos: %.0f, %.0f" % [player.global_position.x, player.global_position.y])
		item_list.add_child(pos_label)
		
		if player is CharacterBody2D:
			var vel_label = _create_simple_label("Vel: %.0f, %.0f" % [player.velocity.x, player.velocity.y])
			item_list.add_child(vel_label)
			
			var floor_label = _create_simple_label("On Floor: %s" % ("Yes" if player.is_on_floor() else "No"))
			item_list.add_child(floor_label)
		
		# Inventory if available
		if player.has_meta("inventory"):
			var inv = player.get_meta("inventory")
			if inv:
				var inv_header = _create_info_label("INVENTORY", Color(0.7, 0.5, 1, 1))
				item_list.add_child(inv_header)
				
				if inv.has_meta("items") or inv.items:
					for item_id in inv.items:
						var qty = inv.items[item_id]
						var item_label = _create_simple_label("%s: %d" % [item_id, qty])
						item_list.add_child(item_label)
				else:
					var empty_label = _create_simple_label("[Empty]")
					empty_label.modulate = Color(0.5, 0.5, 0.5, 0.8)
					item_list.add_child(empty_label)
	
	# Objects list
	var objects_header = _create_info_label("OBJECTS", Color(0.7, 0.8, 1, 1))
	item_list.add_child(objects_header)
	
	var root = get_tree().current_scene
	_create_labels_for_tree(root)

func _create_labels_for_tree(node: Node) -> void:
	# Null check
	if not node:
		return
	
	# Only create labels for Node2D nodes (skip Label nodes and the player)
	if node is Node2D and not node is Label and node != player:
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
	color_rect.custom_minimum_size = Vector2(16, 16)
	color_rect.color = Color(0.3, 0.5, 0.9, 0.7)
	top_row.add_child(color_rect)
	
	# Node name label
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 11)
	label.custom_minimum_size = Vector2(150, 0)
	top_row.add_child(label)
	
	row.add_child(top_row)
	
	# Bottom: type description
	var desc_label = Label.new()
	desc_label.text = "[%s]" % node.get_class()
	desc_label.add_theme_font_size_override("font_size", 9)
	desc_label.modulate = Color(0.6, 0.6, 0.6, 0.7)
	row.add_child(desc_label)
	
	return row

func _create_info_label(text: String, color: Color) -> Label:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 11)
	label.modulate = color
	label.custom_minimum_size = Vector2(0, 20)
	return label

func _create_simple_label(text: String) -> Label:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 10)
	label.modulate = Color(0.9, 0.9, 0.9, 0.9)
	return label
