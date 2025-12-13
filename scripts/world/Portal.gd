extends Area2D

@export var destination_scene: String = "res://scenes/Quarry.tscn"

var player_nearby: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_process(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		if destination_scene and ResourceLoader.exists(destination_scene):
			get_tree().paused = false
			get_tree().call_deferred("change_scene_to_file", destination_scene)

