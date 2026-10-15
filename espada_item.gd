extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_sword"):
		body.collect_sword()
		queue_free()
