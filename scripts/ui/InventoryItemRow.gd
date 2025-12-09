extends HBoxContainer

signal clicked(item_id: String)

var item_id: String = ""
var display_text: String = ""
var quantity: int = 0
var count_color: Color = Color(0.2, 0.2, 0.2, 0.35)

var _dragging_from_rect := false
var _press_pos := Vector2.ZERO
const _DRAG_THRESHOLD := 4.0

var name_label: Label
var count_rect: ColorRect
var qty_label: Label

func _ready() -> void:
	# Build name label
	if not name_label:
		name_label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(name_label)

	# Build count rectangle with embedded label
	if not count_rect:
		count_rect = ColorRect.new()
		count_rect.color = count_color
		count_rect.custom_minimum_size = Vector2(60, 28)
		count_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		count_rect.gui_input.connect(_on_count_rect_input)
		add_child(count_rect)

	if not qty_label:
		qty_label = Label.new()
		qty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		qty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		qty_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		qty_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		count_rect.add_child(qty_label)

	_update_labels()

func setup(id: String, qty: int, display: String = "") -> void:
	item_id = id
	display_text = display if display != "" else id
	quantity = qty
	_apply_color()
	_update_labels()

func _update_labels() -> void:
	if name_label:
		name_label.text = display_text
	if qty_label:
		qty_label.text = "x%d" % quantity
	if count_rect:
		count_rect.tooltip_text = "%s x%d" % [display_text, quantity]

func set_count_color(color: Color) -> void:
	count_color = color
	_apply_color()

func _apply_color() -> void:
	if count_rect:
		count_rect.color = count_color

func _on_count_rect_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_dragging_from_rect = true
				_press_pos = mb.position
				clicked.emit(item_id)
			else:
				_dragging_from_rect = false
	elif event is InputEventMouseMotion and _dragging_from_rect:
		var mm := event as InputEventMouseMotion
		if mm.position.distance_to(_press_pos) >= _DRAG_THRESHOLD:
			_dragging_from_rect = false
			_start_rect_drag()

func _start_rect_drag() -> void:
	if item_id == "":
		return
	var data := {
		"item_id": item_id
	}
	var preview := ColorRect.new()
	preview.color = count_color
	preview.custom_minimum_size = Vector2(60, 28)
	preview.size = preview.custom_minimum_size
	force_drag(data, preview)

func get_drag_data(_position) -> Variant:
	if item_id == "":
		return null
	var preview := ColorRect.new()
	preview.color = count_color
	preview.custom_minimum_size = Vector2(60, 28)
	preview.size = preview.custom_minimum_size
	set_drag_preview(preview)
	return {
		"item_id": item_id
	}

func can_drop_data(_position, _data) -> bool:
	return false  # inventory rows are drag sources only

func drop_data(_position, _data) -> void:
	pass
