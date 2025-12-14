extends Label

func _ready() -> void:
	visible = false
	var debug_manager = get_tree().root.get_node("DebugManager")
	if debug_manager:
		debug_manager.debug_state_changed.connect(_on_debug_state_changed)

func _on_debug_state_changed(is_visible: bool) -> void:
	visible = is_visible
