extends StaticBody2D

var is_open: bool = false

func open() -> void:
	if is_open:
		return
	is_open = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Visual.hide()
