extends CharacterBody2D

const Inventory = preload("res://scripts/systems/Inventory.gd")
const ItemFactory = preload("res://scripts/resources/ItemFactory.gd")
const HotbarUI = preload("res://scenes/ui/HotbarUI.tscn")

# Movement variables (editable in Godot editor with @export)
@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 1200.0
@export var water_gravity: float = 220.0
@export var water_max_fall_speed: float = 200.0
@export var water_jump_velocity: float = -600.0
@export var water_depth_margin: float = 100.0

# Health system variables
@export var max_health: float = 100.0
var current_health: float

# Inventory system
var inventory: Inventory
var inventory_ui: CanvasLayer
var hotbar_ui: CanvasLayer
var in_water: bool = false

@onready var health_bar: ProgressBar = $HealthBar
@onready var camera: Camera2D = $Camera2D
@onready var water_detector: Area2D = $WaterDetector

func _ready() -> void:
	current_health = max_health
	_update_health_bar()
	add_to_group("player")
	if water_detector:
		water_detector.area_entered.connect(_on_area_entered)
		water_detector.area_exited.connect(_on_area_exited)
	_setup_inventory()

func _setup_inventory() -> void:
	inventory = Inventory.new()
	inventory.max_slots = 20
	add_child(inventory)
	
	inventory_ui = preload("res://scenes/ui/InventoryUI.tscn").instantiate()
	add_child(inventory_ui)
	inventory_ui.set_inventory(inventory)

	hotbar_ui = HotbarUI.instantiate()
	add_child(hotbar_ui)
	hotbar_ui.set_inventory(inventory)
	
	_add_starting_inventory()

func _add_starting_inventory() -> void:
	var items_to_add = {
		"wood": 5,
		"stone": 12,
		"copper_ore": 3,
		"pickaxe": 1
	}
	
	for item_id in items_to_add:
		var item = ItemFactory.create_item(item_id)
		if item:
			inventory.add_item(item, items_to_add[item_id])

func take_damage(amount: float) -> void:
	current_health = max(0, current_health - amount)
	_update_health_bar()
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	_update_health_bar()

func die() -> void:
	print("Player died!")
	position = Vector2(100, 100)
	current_health = max_health
	_update_health_bar()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.update_health(current_health, max_health)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = input_dir * speed

	var active_gravity := water_gravity if in_water else gravity
	var active_max_fall := water_max_fall_speed if in_water else max_fall_speed

	if in_water and Input.is_action_just_pressed("jump"):
		velocity.y = water_jump_velocity

	if not is_on_floor():
		velocity.y = min(velocity.y + active_gravity * delta, active_max_fall)
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	move_and_slide()

	# Prevent sinking infinitely while in water by capping velocity
	if in_water and velocity.y > active_max_fall:
		velocity.y = active_max_fall

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		in_water = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("water"):
		in_water = false

