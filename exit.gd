extends Area2D

@export var door_path: NodePath

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var door := get_node(door_path)
	if door.is_open and body.is_in_group("player"):
		body.complete_level()
