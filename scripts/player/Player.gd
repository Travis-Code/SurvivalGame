extends CharacterBody2D

# Movement variables (editable in Godot editor with @export)
@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 1200.0

# Health system variables
@export var max_health: float = 100.0  # Editable in editor - change this to make the player tougher/weaker
var current_health: float              # Current health value (not exported, so not editable in editor)

# This gets a reference to the HealthBar node from the scene tree.
# @onready means it waits until the scene is ready before trying to find it.
# $HealthBar means "find the child node named HealthBar in this scene"
@onready var health_bar: ProgressBar = $HealthBar

# _ready() is called when the scene first loads, before any frames are drawn.
# Think of it like "setup" or "initialization".
func _ready() -> void:
	current_health = max_health  # Start with full health
	_update_health_bar()         # Update the visual bar to show full health

# This function reduces the player's health.
# Example: take_damage(10) reduces health by 10 points.
func take_damage(amount: float) -> void:
	# max(0, ...) ensures health never goes below 0
	current_health = max(0, current_health - amount)
	_update_health_bar()  # Update the visual bar
	# If health drops to 0, call the die() function
	if current_health <= 0:
		die()

# This function increases the player's health.
# Example: heal(20) adds 20 health points.
func heal(amount: float) -> void:
	# min(max_health, ...) ensures health never exceeds max_health
	current_health = min(max_health, current_health + amount)
	_update_health_bar()  # Update the visual bar

# This function is called when the player's health reaches 0.
func die() -> void:
	print("Player died!")
	# For now, just reset the player to the starting position and restore health.
	# Later, you could add respawn screens, game over logic, etc.
	position = Vector2(100, 100)
	current_health = max_health
	_update_health_bar()

# Helper function to update the visual health bar.
# This calls the HealthBar script's update_health() function.
func _update_health_bar() -> void:
	# Check if health_bar exists (safety check)
	if health_bar:
		# Tell the health bar to update its visual representation
		health_bar.update_health(current_health, max_health)

# _physics_process(delta) is called every frame for physics updates.
# delta is the time elapsed since the last frame (e.g., 0.016 seconds at 60 FPS).
func _physics_process(delta: float) -> void:
	# Get horizontal input from the player.
	# Input.get_action_strength() returns a value between 0 and 1.
	# "move_right" - "move_left" gives us: 1 (right), -1 (left), or 0 (no input)
	var input_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = input_dir * speed  # Move at 250 pixels per second in that direction

	# Apply gravity when the player is in the air (not on the floor)
	if not is_on_floor():
		# Add gravity each frame: velocity.y += gravity * delta
		# min(..., max_fall_speed) prevents the player from falling too fast
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	# If on the floor and jump button is pressed, jump
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity  # Negative value makes the player go up

	# Apply the velocity and handle collisions (built-in Godot function)
	move_and_slide()
	
	# Test damage/healing - press keys to test the health system
	# (You can delete this section once you've tested it)
	if Input.is_action_just_pressed("ui_accept"):  # Enter key = take damage
		take_damage(10)
	if Input.is_action_just_pressed("ui_cancel"):  # Escape key = heal
		heal(15)
