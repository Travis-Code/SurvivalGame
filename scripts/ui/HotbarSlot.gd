extends Panel

var assigned_item_id: String = ""
var hotbar: Node = null

var label: Label
var icon_rect: ColorRect

func _ready() -> void:
	self_modulate = Color(1, 1, 1, 0.35)
	# Icon placeholder
	icon_rect = ColorRect.new()
	icon_rect.custom_minimum_size = Vector2(40, 40)
	icon_rect.size_flags_horizontal = Control.SIZE_FILL
	icon_rect.size_flags_vertical = Control.SIZE_FILL
	icon_rect.color = Color(0.15, 0.15, 0.15, 0.6)
	add_child(icon_rect)
	if has_node("Label"):
		label = $Label
	else:
		label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_child(label)
		move_child(label, 1)  # keep label above icon

func set_hotbar(hb: Node) -> void:
	hotbar = hb

func set_item_id(id: String) -> void:
	assigned_item_id = id
	_update_visual()

func _update_visual() -> void:
	if label:
		label.text = assigned_item_id
		label.modulate = Color(1, 1, 1, 0.9)
	if icon_rect:
		icon_rect.color = _get_item_color(assigned_item_id)

func clear() -> void:
	set_item_id("")
	if icon_rect:
		icon_rect.color = _get_item_color("")

func _can_drop_data(_pos, data) -> bool:
	if typeof(data) == TYPE_DICTIONARY and data.has("item_id"):
		print("HotbarSlot can accept drop: ", data["item_id"])
		return true
	return false

func _drop_data(_pos, data) -> void:
	if not _can_drop_data(_pos, data):
		return
	print("HotbarSlot received drop: ", data["item_id"])
	set_item_id(str(data["item_id"]))
	if hotbar:
		hotbar.notify_slot_changed(self)

func _get_item_color(id: String) -> Color:
	match id:
		"wood":
			return Color(0.45, 0.25, 0.1, 0.9)
		"stone":
			return Color(0.5, 0.5, 0.5, 0.9)
		"copper_ore":
			return Color(0.78, 0.45, 0.16, 0.9)
		"":
			return Color(0.15, 0.15, 0.15, 0.6)
		_:
			return Color(0.25, 0.25, 0.25, 0.8)
