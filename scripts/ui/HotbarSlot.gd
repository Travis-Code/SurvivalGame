extends Panel

var assigned_item_id: String = ""
var hotbar: Node = null

var label: Label

func _ready() -> void:
	self_modulate = Color(1, 1, 1, 0.35)
	if has_node("Label"):
		label = $Label
	else:
		label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_child(label)

func set_hotbar(hb: Node) -> void:
	hotbar = hb

func set_item_id(id: String) -> void:
	assigned_item_id = id
	_update_visual()

func _update_visual() -> void:
	if label:
		label.text = assigned_item_id
		label.modulate = Color(1, 1, 1, 0.9)

func clear() -> void:
	set_item_id("")

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
