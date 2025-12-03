extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 1200.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = input_dir * speed

	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	move_and_slide()
